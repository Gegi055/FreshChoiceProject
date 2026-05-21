"""
FreshChoice Backend — Flask + MongoDB
======================================
Start the server:
    pip install -r requirements.txt
    python app.py

Seed the database with sample data first:
    python seed.py
"""

from flask import Flask, jsonify
from flask_cors import CORS
from pymongo import MongoClient

from config import MONGO_URI, PORT
from routes.auth     import init_auth,     auth_bp
from routes.products import init_products, products_bp
from routes.recipes  import init_recipes,  recipes_bp
from routes.cart     import init_cart,     cart_bp
from routes.orders   import init_orders,   orders_bp
from routes.menu     import init_menu,     menu_bp


# ── App setup ─────────────────────────────────────────────────────────────────
app = Flask(__name__)
CORS(app)  # Allow requests from the Flutter app

# ── MongoDB connection ────────────────────────────────────────────────────────
client = MongoClient(MONGO_URI)
db     = client["fresh_choice"]

# Quick connection check at startup
try:
    client.admin.command("ping")
    print("✓ Connected to MongoDB Atlas")
except Exception as e:
    print(f"✗ MongoDB connection failed: {e}")

# ── Register routes ───────────────────────────────────────────────────────────
app.register_blueprint(init_auth(db))
app.register_blueprint(init_products(db))
app.register_blueprint(init_recipes(db))
app.register_blueprint(init_cart(db))
app.register_blueprint(init_orders(db))
app.register_blueprint(init_menu(db))


# ── Health check ──────────────────────────────────────────────────────────────
@app.route("/", methods=["GET"])
def health():
    return jsonify({"status": "ok", "app": "FreshChoice API"}), 200


# ── 404 handler ───────────────────────────────────────────────────────────────
@app.errorhandler(404)
def not_found(e):
    return jsonify({"error": "Endpoint not found"}), 404


# ── 500 handler ───────────────────────────────────────────────────────────────
@app.errorhandler(500)
def server_error(e):
    return jsonify({"error": "Internal server error"}), 500


# ── Run ───────────────────────────────────────────────────────────────────────
if __name__ == "__main__":
    print(f"\nFreshChoice API running on http://localhost:{PORT}\n")
    app.run(host="0.0.0.0", port=PORT, debug=True)
