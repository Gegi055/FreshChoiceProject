from flask import Blueprint, request, jsonify
from bson import ObjectId

recipes_bp = Blueprint("recipes", __name__, url_prefix="/api/recipes")


def _serialize(doc: dict) -> dict:
    doc["id"] = str(doc.pop("_id"))
    return doc


def init_recipes(db):
    recipes = db["recipes"]

    # ── GET /api/recipes ──────────────────────────────────────────────────────
    @recipes_bp.route("", methods=["GET"])
    def get_recipes():
        """
        Return all recipe categories shown on the home screen.
        Optional query param: ?limit=10
        """
        limit = int(request.args.get("limit", 10))
        docs  = list(recipes.find().limit(limit))
        return jsonify([_serialize(d) for d in docs]), 200

    # ── GET /api/recipes/popular ──────────────────────────────────────────────
    @recipes_bp.route("/popular", methods=["GET"])
    def get_popular():
        """Return recipes marked as popular (the home-screen grid)."""
        docs = list(recipes.find({"popular": True}).limit(6))
        return jsonify([_serialize(d) for d in docs]), 200

    # ── GET /api/recipes/<id> ─────────────────────────────────────────────────
    @recipes_bp.route("/<recipe_id>", methods=["GET"])
    def get_recipe(recipe_id):
        """Return a single recipe/category by ID."""
        try:
            doc = recipes.find_one({"_id": ObjectId(recipe_id)})
        except Exception:
            return jsonify({"error": "Invalid recipe ID"}), 400

        if not doc:
            return jsonify({"error": "Recipe not found"}), 404

        return jsonify(_serialize(doc)), 200

    return recipes_bp
