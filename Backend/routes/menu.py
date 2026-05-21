from flask import Blueprint, jsonify
from bson import ObjectId
import datetime

menu_bp = Blueprint("menu", __name__, url_prefix="/api/menu")


def _serialize(doc: dict) -> dict:
    doc["id"] = str(doc.pop("_id"))
    return doc


def init_menu(db):
    menu = db["menu"]

    # ── GET /api/menu/today ───────────────────────────────────────────────────
    @menu_bp.route("/today", methods=["GET"])
    def get_today_menu():
        """
        Return today's menu items.
        Matches documents where 'date' equals today's date string (YYYY-MM-DD).
        Falls back to any 'daily' menu items if nothing is set for today.
        """
        today = datetime.datetime.utcnow().strftime("%Y-%m-%d")

        docs = list(menu.find({"date": today}))
        if not docs:
            # Fallback: items tagged as daily specials
            docs = list(menu.find({"type": "daily"}))

        return jsonify([_serialize(d) for d in docs]), 200

    # ── GET /api/menu ─────────────────────────────────────────────────────────
    @menu_bp.route("", methods=["GET"])
    def get_all_menu():
        """Return all menu items (for the full menu screen)."""
        docs = list(menu.find().limit(50))
        return jsonify([_serialize(d) for d in docs]), 200

    return menu_bp
