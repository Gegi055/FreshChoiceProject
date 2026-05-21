import os
from dotenv import load_dotenv

load_dotenv()

MONGO_URI  = os.getenv("MONGO_URI")
JWT_SECRET = os.getenv("JWT_SECRET", "change_me_in_production")
PORT       = int(os.getenv("PORT", 5000))
