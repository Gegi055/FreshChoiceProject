from flask import Blueprint, request, jsonify
from bson import ObjectId
import datetime
from auth_helpers import token_required

orders_bp = Blueprint("orders", __name__, url_prefix="/api/orders")


def _serialize(doc: dict) -> dict:
    doc["id"] = str(doc.pop("_id"))
    return doc


def init_orders(db):
    orders = db["orders"]
    carts  = db["carts"]

    # ── GET /api/orders ───────────────────────────────────────────────────────
    @orders_bp.route("", methods=["GET"])
    @token_required
    def get_orders(current_user):
        """Return all orders for the authenticated user (newest first)."""
        docs = list(
            orders.find({"user_id": current_user["user_id"]})
                  .sort("created_at", -1)
                  .limit(50)
        )
        return jsonify([_serialize(d) for d in docs]), 200

    # ── POST /api/orders ──────────────────────────────────────────────────────
    @orders_bp.route("", methods=["POST"])
    @token_required
    def place_order(current_user):
        """
        Place an order from the user's current cart.
        Body: { "address": str }
        The cart is cleared on success.
        """
        data    = request.get_json(silent=True) or {}
        address = data.get("address", "").strip()

        if not address:
            return jsonify({"error": "Delivery address is required"}), 400

        user_id = current_user["user_id"]
        cart    = carts.find_one({"user_id": user_id})

        if not cart or not cart.get("items"):
            return jsonify({"error": "Your cart is empty"}), 400

        items = cart["items"]
        total = sum(i.get("price", 0) * i.get("quantity", 1) for i in items)

        result = orders.insert_one({
            "user_id":    user_id,
            "items":      items,
            "total":      round(total, 2),
            "address":    address,
            "status":     "pending",   # pending → confirmed → delivered
            "created_at": datetime.datetime.utcnow(),
        })

        # Clear the cart after checkout
        carts.update_one(
            {"user_id": user_id},
            {"$set": {"items": [], "updated_at": datetime.datetime.utcnow()}},
        )

        return jsonify({
            "message":  "Order placed successfully!",
            "order_id": str(result.inserted_id),
            "total":    round(total, 2),
            "status":   "pending",
        }), 201

    # ── GET /api/orders/<id> ──────────────────────────────────────────────────
    @orders_bp.route("/<order_id>", methods=["GET"])
    @token_required
    def get_order(current_user, order_id):
        """Return a single order (must belong to the authenticated user)."""
        try:
            doc = orders.find_one({
                "_id":     ObjectId(order_id),
                "user_id": current_user["user_id"],
            })
        except Exception:
            return jsonify({"error": "Invalid order ID"}), 400

        if not doc:
            return jsonify({"error": "Order not found"}), 404

        return jsonify(_serialize(doc)), 200

    return orders_bp
