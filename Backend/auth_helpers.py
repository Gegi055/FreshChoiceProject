import jwt
import bcrypt
from datetime import datetime, timedelta, timezone
from functools import wraps
from flask import request, jsonify
from config import JWT_SECRET


# ── Password helpers ──────────────────────────────────────────────────────────

def hash_password(plain: str) -> str:
    """Hash a plain-text password with bcrypt."""
    return bcrypt.hashpw(plain.encode(), bcrypt.gensalt()).decode()


def check_password(plain: str, hashed: str) -> bool:
    """Return True if plain matches the stored hash."""
    return bcrypt.checkpw(plain.encode(), hashed.encode())


# ── JWT helpers ───────────────────────────────────────────────────────────────

def create_token(user_id: str, email: str) -> str:
    """Create a JWT that expires in 7 days."""
    payload = {
        "user_id": user_id,
        "email":   email,
        "exp":     datetime.now(timezone.utc) + timedelta(days=7),
    }
    return jwt.encode(payload, JWT_SECRET, algorithm="HS256")


def decode_token(token: str) -> dict:
    """Decode and verify a JWT. Raises on failure."""
    return jwt.decode(token, JWT_SECRET, algorithms=["HS256"])


# ── Route decorator ───────────────────────────────────────────────────────────

def token_required(f):
    """
    Decorator for protected routes.
    Reads the Bearer token from the Authorization header and injects
    `current_user` (dict with user_id + email) into the route function.

    Usage:
        @app.route('/protected')
        @token_required
        def protected(current_user):
            return jsonify({"user": current_user})
    """
    @wraps(f)
    def decorated(*args, **kwargs):
        auth_header = request.headers.get("Authorization", "")
        if not auth_header.startswith("Bearer "):
            return jsonify({"error": "Missing or invalid Authorization header"}), 401

        token = auth_header.split(" ", 1)[1]
        try:
            payload = decode_token(token)
        except jwt.ExpiredSignatureError:
            return jsonify({"error": "Token has expired — please log in again"}), 401
        except jwt.InvalidTokenError:
            return jsonify({"error": "Invalid token"}), 401

        return f(payload, *args, **kwargs)
    return decorated
