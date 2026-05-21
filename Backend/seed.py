"""
seed.py — Run once to populate the database with sample data.
Usage: python seed.py
"""

from pymongo import MongoClient
import datetime
from config import MONGO_URI

client = MongoClient(MONGO_URI)
db     = client["fresh_choice"]


# ── Products ──────────────────────────────────────────────────────────────────
# These match the hardcoded items in buy_again_section.dart
PRODUCTS = [
    {
        "name":     "Orange Juice",
        "price":    1.50,
        "category": "drinks",
        "image":    "https://images.unsplash.com/photo-1600271886742-f049cd451bba?w=300",
        "featured": True,
        "in_stock": True,
    },
    {
        "name":     "Red Meat",
        "price":    3.50,
        "category": "meat",
        "image":    "https://images.unsplash.com/photo-1603048297172-c92544798d5a?w=300",
        "featured": True,
        "in_stock": True,
    },
    {
        "name":     "Orange",
        "price":    1.00,
        "category": "fruit",
        "image":    "https://images.unsplash.com/photo-1547514701-42782101795e?w=300",
        "featured": True,
        "in_stock": True,
    },
    {
        "name":     "Bread",
        "price":    2.00,
        "category": "bakery",
        "image":    "https://images.unsplash.com/photo-1509440159596-0249088772ff?w=300",
        "featured": True,
        "in_stock": True,
    },
    {
        "name":     "Whole Milk",
        "price":    1.20,
        "category": "dairy",
        "image":    "https://images.unsplash.com/photo-1550583724-b2692b85b150?w=300",
        "featured": False,
        "in_stock": True,
    },
    {
        "name":     "Eggs (12 pack)",
        "price":    2.80,
        "category": "dairy",
        "image":    "https://images.unsplash.com/photo-1587486913049-53fc88980cfc?w=300",
        "featured": False,
        "in_stock": True,
    },
    {
        "name":     "Banana",
        "price":    0.80,
        "category": "fruit",
        "image":    "https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=300",
        "featured": False,
        "in_stock": True,
    },
    {
        "name":     "Pasta",
        "price":    1.30,
        "category": "dry goods",
        "image":    "https://images.unsplash.com/photo-1598866594230-a7c12756260f?w=300",
        "featured": False,
        "in_stock": True,
    },
]

# ── Recipes ───────────────────────────────────────────────────────────────────
# These match the cards in popular_recipes.dart
RECIPES = [
    {
        "title":    "Our Top Picks",
        "image":    "https://images.unsplash.com/photo-1551183053-bf91a1d81141?w=400",
        "popular":  True,
        "featured": True,
    },
    {
        "title":    "Hangover Foods",
        "image":    "https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=400",
        "popular":  True,
        "featured": False,
    },
    {
        "title":    "Remedy Foods",
        "image":    "https://images.unsplash.com/photo-1547592180-85f173990554?w=400",
        "popular":  True,
        "featured": False,
    },
    {
        "title":    "Quick & Easy",
        "image":    "https://images.unsplash.com/photo-1482049016688-2d3e1b311543?w=400",
        "popular":  False,
        "featured": False,
    },
]

# ── Today's menu ──────────────────────────────────────────────────────────────
TODAY = datetime.datetime.utcnow().strftime("%Y-%m-%d")
MENU  = [
    {
        "name":        "Grilled Chicken Salad",
        "description": "Fresh greens with grilled chicken, cherry tomatoes and balsamic",
        "price":       8.50,
        "calories":    420,
        "image":       "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400",
        "date":        TODAY,
        "type":        "daily",
    },
    {
        "name":        "Veggie Wrap",
        "description": "Hummus, roasted peppers, spinach and feta in a wholemeal tortilla",
        "price":       6.00,
        "calories":    380,
        "image":       "https://images.unsplash.com/photo-1626700051175-6818013e1d4f?w=400",
        "date":        TODAY,
        "type":        "daily",
    },
    {
        "name":        "Beef Stir Fry",
        "description": "Tender beef strips with seasonal vegetables in a ginger soy sauce",
        "price":       9.50,
        "calories":    510,
        "image":       "https://images.unsplash.com/photo-1603360946369-dc9bb6258143?w=400",
        "date":        TODAY,
        "type":        "daily",
    },
]


def seed():
    print("Seeding database...\n")

    for collection_name, data, label in [
        ("products", PRODUCTS, "products"),
        ("recipes",  RECIPES,  "recipes"),
        ("menu",     MENU,     "menu items"),
    ]:
        col = db[collection_name]
        col.drop()
        result = col.insert_many(data)
        print(f"  ✓ Inserted {len(result.inserted_ids)} {label}")

    print("\nDone! Your database is ready.")
    client.close()


if __name__ == "__main__":
    seed()
