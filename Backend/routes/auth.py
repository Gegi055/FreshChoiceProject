from flask import Blueprint, request, jsonify
from bson import ObjectId
from auth_helpers import hash_password, check_password, create_token

auth_bp = Blueprint("auth", __name__, url_prefix="/api/auth")


def init_auth(db):
    users = db["users"]

    # ── POST /api/auth/signup ─────────────────────────────────────────────────
    @auth_bp.route("/signup", methods=["POST"])
    def signup():
        """
        Register a new user.
        Body: { "name": str, "email": str, "password": str }
        """
        data = request.get_json(silent=True) or {}

        name     = data.get("name", "").strip()
        email    = data.get("email", "").strip().lower()
        password = data.get("password", "")

        # Validation
        if not name or not email or not password:
            return jsonify({"error": "name, email and password are required"}), 400
        if "@" not in email:
            return jsonify({"error": "Invalid email address"}), 400
        if len(password) < 6:
            return jsonify({"error": "Password must be at least 6 characters"}), 400

        # Check for existing account
        if users.find_one({"email": email}):
            return jsonify({"error": "An account with this email already exists"}), 409

        # Insert user
        result = users.insert_one({
            "name":            name,
            "email":           email,
            "password_hash":   hash_password(password),
            "created_at":      __import__("datetime").datetime.utcnow(),
        })

        token = create_token(str(result.inserted_id), email)
        return jsonify({
            "message": f"Welcome to Fresh Choice, {name}!",
            "token":   token,
            "user": {
                "id":    str(result.inserted_id),
                "name":  name,
                "email": email,
            },
        }), 201

    # ── POST /api/auth/login ──────────────────────────────────────────────────
    @auth_bp.route("/login", methods=["POST"])
    def login():
        """
        Log in an existing user.
        Body: { "email": str, "password": str }
        """
        data = request.get_json(silent=True) or {}

        email    = data.get("email", "").strip().lower()
        password = data.get("password", "")

        if not email or not password:
            return jsonify({"error": "email and password are required"}), 400

        user = users.find_one({"email": email})
        if not user or not check_password(password, user["password_hash"]):
            return jsonify({"error": "Incorrect email or password"}), 401

        token = create_token(str(user["_id"]), email)
        return jsonify({
            "message": f"Welcome back, {user['name']}!",
            "token":   token,
            "user": {
                "id":    str(user["_id"]),
                "name":  user["name"],
                "email": user["email"],
            },
        }), 200

    return auth_bp
