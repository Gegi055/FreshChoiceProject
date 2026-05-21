# FreshChoice Backend

Flask + MongoDB Atlas backend for the FreshChoice Flutter app.

---

## Setup

```bash
# 1. Install dependencies
pip install -r requirements.txt

# 2. Seed the database with sample data (run once)
python seed.py

# 3. Start the server
python app.py
```

The server runs at `http://localhost:5000`.

---

## API Reference

All protected routes require:
```
Authorization: Bearer <token>
```

---

### Auth

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| POST | `/api/auth/signup` | ✗ | Register a new user |
| POST | `/api/auth/login`  | ✗ | Log in and get a token |

**Signup body**
```json
{ "name": "John Doe", "email": "john@example.com", "password": "secret123" }
```

**Login body**
```json
{ "email": "john@example.com", "password": "secret123" }
```

**Both return**
```json
{
  "token": "<jwt>",
  "user": { "id": "...", "name": "John Doe", "email": "john@example.com" }
}
```

---

### Products

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| GET | `/api/products` | ✗ | All products (optional `?category=fruit&limit=20`) |
| GET | `/api/products/search?q=orange` | ✗ | Search by name or category |
| GET | `/api/products/buy-again` | ✓ | User's previously ordered products |
| GET | `/api/products/<id>` | ✗ | Single product |

---

### Recipes

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| GET | `/api/recipes` | ✗ | All recipe categories |
| GET | `/api/recipes/popular` | ✗ | Popular recipes (home screen grid) |
| GET | `/api/recipes/<id>` | ✗ | Single recipe |

---

### Cart

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| GET | `/api/cart` | ✓ | View cart |
| POST | `/api/cart` | ✓ | Add item `{ "product_id": "...", "quantity": 1 }` |
| PUT | `/api/cart/<product_id>` | ✓ | Update quantity `{ "quantity": 2 }` (0 = remove) |
| DELETE | `/api/cart/<product_id>` | ✓ | Remove one item |
| DELETE | `/api/cart` | ✓ | Clear entire cart |

---

### Orders

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| GET | `/api/orders` | ✓ | All orders for this user |
| POST | `/api/orders` | ✓ | Place order from cart `{ "address": "..." }` |
| GET | `/api/orders/<id>` | ✓ | Single order detail |

---

### Menu

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| GET | `/api/menu/today` | ✗ | Today's food menu (the banner) |
| GET | `/api/menu` | ✗ | All menu items |

---

## Connecting Flutter to the Backend

In each Flutter screen, replace the `TODO: Connect to Python backend` comment
with an HTTP call. Example for login:

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> _handleLogin() async {
  final response = await http.post(
    Uri.parse('http://YOUR_IP:5000/api/auth/login'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'email': _emailController.text.trim(),
      'password': _passwordController.text,
    }),
  );

  final data = jsonDecode(response.body);
  if (response.statusCode == 200) {
    final token = data['token']; // save this for later requests
    // Navigate to home
  } else {
    // Show data['error']
  }
}
```

Add `http: ^1.2.0` to your `pubspec.yaml` dependencies.

Use `http://10.0.2.2:5000` instead of `localhost` when testing on the Android emulator.

---

## MongoDB Collections

| Collection | Description |
|------------|-------------|
| `users`    | Registered user accounts |
| `products` | Grocery/food products |
| `recipes`  | Recipe categories (home screen) |
| `carts`    | One cart per user |
| `orders`   | Placed orders |
| `menu`     | Daily food menu items |
