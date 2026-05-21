from flask import Blueprint, request, jsonify
from bson import ObjectId
import datetime
from auth_helpers import token_required

cart_bp = Blueprint("cart", __name__, url_prefix="/api/cart")


def init_cart(db):
    carts    = db["carts"]
    products = db["products"]

    def _get_or_create_cart(user_id: str) -> dict:
        """Return the user's cart, creating one if it doesn't exist yet."""
        cart = carts.find_one({"user_id": user_id})
        if not cart:
            carts.insert_one({"user_id": user_id, "items": [], "updated_at": datetime.datetime.utcnow()})
            cart = carts.find_one({"user_id": user_id})
        return cart

    def _cart_response(cart: dict) -> dict:
        """Build a clean cart dict with a total field."""
        items = cart.get("items", [])
        total = sum(item.get("price", 0) * item.get("quantity", 1) for item in items)
        return {
            "items":      items,
            "item_count": sum(i.get("quantity", 1) for i in items),
            "total":      round(total, 2),
        }

    # ── GET /api/cart ─────────────────────────────────────────────────────────
    @cart_bp.route("", methods=["GET"])
    @token_required
    def get_cart(current_user):
        """Return the authenticated user's current cart."""
        cart = _get_or_create_cart(current_user["user_id"])
        return jsonify(_cart_response(cart)), 200

    # ── POST /api/cart ────────────────────────────────────────────────────────
    @cart_bp.route("", methods=["POST"])
    @token_required
    def add_to_cart(current_user):
        """
        Add a product to the cart (or increase quantity if already present).
        Body: { "product_id": str, "quantity": int }
        """
        data       = request.get_json(silent=True) or {}
        product_id = data.get("product_id", "").strip()
        quantity   = int(data.get("quantity", 1))

        if not product_id:
            return jsonify({"error": "product_id is required"}), 400
        if quantity < 1:
            return jsonify({"error": "quantity must be at least 1"}), 400

        try:
            product = products.find_one({"_id": ObjectId(product_id)})
        except Exception:
            return jsonify({"error": "Invalid product_id"}), 400

        if not product:
            return jsonify({"error": "Product not found"}), 404

        user_id = current_user["user_id"]
        cart    = _get_or_create_cart(user_id)
        items   = cart.get("items", [])

        # If the product is already in the cart, bump its quantity
        for item in items:
            if item["product_id"] == product_id:
                item["quantity"] += quantity
                break
        else:
            items.append({
                "product_id": product_id,
                "name":       product["name"],
                "price":      product.get("price", 0),
                "image":      product.get("image", ""),
                "quantity":   quantity,
            })

        carts.update_one(
            {"user_id": user_id},
            {"$set": {"items": items, "updated_at": datetime.datetime.utcnow()}},
        )

        updated = carts.find_one({"user_id": user_id})
        return jsonify({"message": "Item added to cart", **_cart_response(updated)}), 200

    # ── PUT /api/cart/<product_id> ────────────────────────────────────────────
    @cart_bp.route("/<product_id>", methods=["PUT"])
    @token_required
    def update_cart_item(current_user, product_id):
        """
        Set a specific quantity for a cart item.
        Body: { "quantity": int }  — send 0 to remove the item.
        """
        data     = request.get_json(silent=True) or {}
        quantity = int(data.get("quantity", 1))

        user_id = current_user["user_id"]
        cart    = _get_or_create_cart(user_id)
        items   = cart.get("items", [])

        if quantity <= 0:
            items = [i for i in items if i["product_id"] != product_id]
        else:
            for item in items:
                if item["product_id"] == product_id:
                    item["quantity"] = quantity
                    break
            else:
                return jsonify({"error": "Item not in cart"}), 404

        carts.update_one(
            {"user_id": user_id},
            {"$set": {"items": items, "updated_at": datetime.datetime.utcnow()}},
        )

        updated = carts.find_one({"user_id": user_id})
        return jsonify({"message": "Cart updated", **_cart_response(updated)}), 200

    # ── DELETE /api/cart/<product_id> ─────────────────────────────────────────
    @cart_bp.route("/<product_id>", methods=["DELETE"])
    @token_required
    def remove_from_cart(current_user, product_id):
        """Remove a product entirely from the cart."""
        user_id = current_user["user_id"]
        cart    = _get_or_create_cart(user_id)
        items   = [i for i in cart.get("items", []) if i["product_id"] != product_id]

        carts.update_one(
            {"user_id": user_id},
            {"$set": {"items": items, "updated_at": datetime.datetime.utcnow()}},
        )

        updated = carts.find_one({"user_id": user_id})
        return jsonify({"message": "Item removed", **_cart_response(updated)}), 200

    # ── DELETE /api/cart ──────────────────────────────────────────────────────
    @cart_bp.route("", methods=["DELETE"])
    @token_required
    def clear_cart(current_user):
        """Empty the user's entire cart."""
        carts.update_one(
            {"user_id": current_user["user_id"]},
            {"$set": {"items": [], "updated_at": datetime.datetime.utcnow()}},
        )
        return jsonify({"message": "Cart cleared", "items": [], "item_count": 0, "total": 0}), 200

    return cart_bp
