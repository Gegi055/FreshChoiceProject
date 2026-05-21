from flask import Blueprint, request, jsonify
from bson import ObjectId
from auth_helpers import token_required

products_bp = Blueprint("products", __name__, url_prefix="/api/products")


def _serialize(doc: dict) -> dict:
    """Convert MongoDB _id to string for JSON serialisation."""
    doc["id"] = str(doc.pop("_id"))
    return doc


def init_products(db):
    products = db["products"]
    orders   = db["orders"]

    # ── GET /api/products ─────────────────────────────────────────────────────
    @products_bp.route("", methods=["GET"])
    def get_products():
        """
        Return all products.
        Optional query params:
          - category  (e.g. ?category=fruit)
          - limit     (default 20)
        """
        category = request.args.get("category", "").strip()
        limit    = int(request.args.get("limit", 20))

        query = {}
        if category:
            query["category"] = {"$regex": category, "$options": "i"}

        docs = list(products.find(query).limit(limit))
        return jsonify([_serialize(d) for d in docs]), 200

    # ── GET /api/products/search ──────────────────────────────────────────────
    @products_bp.route("/search", methods=["GET"])
    def search_products():
        """
        Search products by name or category.
        Query param: ?q=orange
        """
        q = request.args.get("q", "").strip()
        if not q:
            return jsonify({"error": "Query parameter 'q' is required"}), 400

        docs = list(products.find({
            "$or": [
                {"name":     {"$regex": q, "$options": "i"}},
                {"category": {"$regex": q, "$options": "i"}},
            ]
        }).limit(20))
        return jsonify([_serialize(d) for d in docs]), 200

    # ── GET /api/products/buy-again ───────────────────────────────────────────
    @products_bp.route("/buy-again", methods=["GET"])
    @token_required
    def buy_again(current_user):
        """
        Return the last 8 distinct products this user has ordered.
        Falls back to 8 featured products if the user has no order history.
        Requires: Authorization: Bearer <token>
        """
        user_id = current_user["user_id"]

        # Collect product IDs from past orders (most recent first)
        past_orders = list(
            orders.find({"user_id": user_id})
                  .sort("created_at", -1)
                  .limit(10)
        )

        seen, product_ids = set(), []
        for order in past_orders:
            for item in order.get("items", []):
                pid = item.get("product_id")
                if pid and pid not in seen:
                    seen.add(pid)
                    product_ids.append(ObjectId(pid))
                    if len(product_ids) == 8:
                        break

        if product_ids:
            docs = list(products.find({"_id": {"$in": product_ids}}))
        else:
            # No order history — return featured products
            docs = list(products.find({"featured": True}).limit(8))
            if not docs:
                docs = list(products.find().limit(8))

        return jsonify([_serialize(d) for d in docs]), 200

    # ── GET /api/products/<id> ────────────────────────────────────────────────
    @products_bp.route("/<product_id>", methods=["GET"])
    def get_product(product_id):
        """Return a single product by its ID."""
        try:
            doc = products.find_one({"_id": ObjectId(product_id)})
        except Exception:
            return jsonify({"error": "Invalid product ID"}), 400

        if not doc:
            return jsonify({"error": "Product not found"}), 404

        return jsonify(_serialize(doc)), 200

    return products_bp
