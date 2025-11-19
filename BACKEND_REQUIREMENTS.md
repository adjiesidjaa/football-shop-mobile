# Dokumentasi Backend Requirements untuk Integrasi Flutter

Dokumen ini menjelaskan semua endpoint, format request/response, dan field yang diperlukan untuk integrasi Flutter dengan Django backend.

## 1. Autentikasi

### 1.1 Login
**Endpoint:** `POST /auth/login/`

**Request Body (Form Data):**
```
username: string (required)
password: string (required)
```

**Response Success (200):**
```json
{
  "status": true,
  "message": "Login berhasil!",
  "username": "nama_user"
}
```

**Response Error (401):**
```json
{
  "status": false,
  "message": "Username atau password salah"
}
```

**Catatan:**
- Menggunakan cookie-based authentication
- Set cookie session setelah login berhasil
- Flutter menggunakan `pbp_django_auth` yang otomatis menangani cookie

---

### 1.2 Register
**Endpoint:** `POST /auth/register/`

**Request Body (JSON):**
```json
{
  "username": "string (required, min 3 karakter)",
  "password1": "string (required, min 8 karakter)",
  "password2": "string (required, harus sama dengan password1)"
}
```

**Response Success (200):**
```json
{
  "status": "success",
  "message": "Registrasi berhasil!"
}
```

**Response Error (400):**
```json
{
  "status": "error",
  "message": "Error message detail"
}
```

**Catatan:**
- Content-Type: `application/json`
- Flutter mengirim data dengan `jsonEncode()`

---

### 1.3 Logout
**Endpoint:** `POST /auth/logout/`

**Request:** Tidak memerlukan body, hanya cookie session

**Response Success (200):**
```json
{
  "status": true,
  "message": "Logged out successfully!",
  "username": "nama_user"
}
```

**Response Error (401):**
```json
{
  "status": false,
  "message": "Logout failed."
}
```

**Catatan:**
- Menggunakan cookie session untuk autentikasi
- Hapus session setelah logout berhasil

---

## 2. Product Management

### 2.1 Get Product List
**Endpoint:** `GET /product/json/`

**Request:** Tidak memerlukan body, hanya cookie session (jika diperlukan autentikasi)

**Response Success (200):**
```json
[
  {
    "user": 1,
    "name": "Nama Produk",
    "price": 100000,
    "description": "Deskripsi produk",
    "thumbnail": "https://example.com/image.jpg",
    "category": "Jersey",
    "is_featured": true,
    "stock": 50,
    "brand": "Nike"
  },
  {
    "user": 1,
    "name": "Produk Lain",
    "price": 200000,
    "description": "Deskripsi produk lain",
    "thumbnail": "",
    "category": "Shoes",
    "is_featured": false,
    "stock": 30,
    "brand": "Adidas"
  }
]
```

**Response Error (401/404):**
```json
{
  "error": "Error message"
}
```

**Catatan:**
- Mengembalikan array/list produk
- Field `thumbnail` bisa string kosong jika tidak ada
- Field `is_featured` adalah boolean

---

### 2.2 Get Product Detail
**Endpoint:** `GET /product/<id>/json/`

**Request:** Tidak memerlukan body, hanya cookie session (jika diperlukan autentikasi)

**Response Success (200):**
```json
{
  "user": 1,
  "name": "Nama Produk",
  "price": 100000,
  "description": "Deskripsi produk lengkap",
  "thumbnail": "https://example.com/image.jpg",
  "category": "Jersey",
  "is_featured": true,
  "stock": 50,
  "brand": "Nike"
}
```

**Response Error (404):**
```json
{
  "error": "Product not found"
}
```

**Catatan:**
- Mengembalikan single object (bukan array)
- `<id>` adalah ID produk (integer)

---

### 2.3 Create Product
**Endpoint:** `POST /create-flutter/`

**Request Body (JSON):**
```json
{
  "name": "string (required)",
  "price": 100000,
  "description": "string (required)",
  "category": "string (required, salah satu: Jersey, Shoes, Equipment, Accessories, Ball)",
  "thumbnail": "string (optional, URL gambar)",
  "is_featured": false,
  "stock": 50,
  "brand": "string (required)"
}
```

**Response Success (200):**
```json
{
  "status": "success",
  "message": "Product created successfully"
}
```

**Response Error (400/401):**
```json
{
  "status": "error",
  "message": "Error message detail"
}
```

**Catatan:**
- Content-Type: `application/json`
- Field `user` TIDAK dikirim dari Flutter, backend harus mengambil dari session/login
- Field `thumbnail` bisa string kosong jika tidak diisi
- Field `is_featured` adalah boolean
- Field `price` dan `stock` adalah integer

---

## 3. Model Product Structure

**Field yang diperlukan di Django Model:**

```python
class Product(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    name = models.CharField(max_length=255)
    price = models.IntegerField()
    description = models.TextField()
    thumbnail = models.CharField(max_length=500, blank=True, null=True)
    category = models.CharField(max_length=50)
    is_featured = models.BooleanField(default=False)
    stock = models.IntegerField()
    brand = models.CharField(max_length=100)
    
    # Optional: jika ada field tambahan
    # date_added = models.DateTimeField(auto_now_add=True)
```

**Field Mapping:**
- `user` → Diambil dari `request.user` (session)
- `name` → Dari request body
- `price` → Integer dari request body
- `description` → String dari request body
- `thumbnail` → String (bisa kosong) dari request body
- `category` → String dari request body
- `is_featured` → Boolean dari request body
- `stock` → Integer dari request body
- `brand` → String dari request body

---

## 4. CORS & Security

### 4.1 CORS Configuration
Pastikan Django mengizinkan request dari Flutter:
- Untuk development: Izinkan semua origin
- Untuk production: Izinkan origin Flutter app

**settings.py:**
```python
CORS_ALLOWED_ORIGINS = [
    "http://localhost:8000",
    "http://10.0.2.2:8000",  # Android emulator
    # Tambahkan origin Flutter lainnya
]

CORS_ALLOW_CREDENTIALS = True
```

### 4.2 CSRF Exemption
Untuk endpoint Flutter, gunakan `@csrf_exempt`:
```python
from django.views.decorators.csrf import csrf_exempt

@csrf_exempt
def create_flutter(request):
    # Your code here
```

**Catatan:** `pbp_django_auth` sudah menangani cookie dan session, jadi CSRF exemption diperlukan.

---

## 5. Response Format Standard

### Success Response
```json
{
  "status": "success" atau true,
  "message": "Success message",
  "data": {} // optional
}
```

### Error Response
```json
{
  "status": "error" atau false,
  "message": "Error message detail"
}
```

---

## 6. Checklist Backend

- [ ] Endpoint `/auth/login/` dengan cookie session
- [ ] Endpoint `/auth/register/` dengan validasi password
- [ ] Endpoint `/auth/logout/` untuk clear session
- [ ] Endpoint `/product/json/` mengembalikan array produk
- [ ] Endpoint `/product/<id>/json/` mengembalikan single product
- [ ] Endpoint `/create-flutter/` untuk create product
- [ ] Model Product dengan semua field yang diperlukan
- [ ] Auto-assign `user` dari `request.user` saat create product
- [ ] CORS configuration untuk Flutter
- [ ] CSRF exemption untuk endpoint Flutter
- [ ] JSON response format yang konsisten

---

## 7. Testing Endpoints

### Test dengan curl:

**Login:**
```bash
curl -X POST http://localhost:8000/auth/login/ \
  -d "username=testuser&password=testpass" \
  -c cookies.txt
```

**Get Products:**
```bash
curl -X GET http://localhost:8000/product/json/ \
  -b cookies.txt
```

**Create Product:**
```bash
curl -X POST http://localhost:8000/create-flutter/ \
  -H "Content-Type: application/json" \
  -b cookies.txt \
  -d '{
    "name": "Test Product",
    "price": 100000,
    "description": "Test description",
    "category": "Jersey",
    "thumbnail": "",
    "is_featured": false,
    "stock": 10,
    "brand": "Nike"
  }'
```

---

## 8. Catatan Penting

1. **Cookie Session:** Flutter menggunakan `pbp_django_auth` yang otomatis menyimpan dan mengirim cookie session. Pastikan Django mengembalikan dan menerima cookie dengan benar.

2. **Field User:** Saat create product, Flutter TIDAK mengirim field `user`. Backend harus mengambil dari `request.user` yang sudah login.

3. **JSON Format:** Semua endpoint yang menerima JSON harus menggunakan `Content-Type: application/json`.

4. **Error Handling:** Pastikan semua error mengembalikan format JSON yang konsisten dengan field `status` dan `message`.

5. **URL Base:** Ganti `http://[YOUR_APP_URL]` di Flutter dengan URL Django yang sebenarnya:
   - Development: `http://localhost:8000` (Chrome/web)
   - Android Emulator: `http://10.0.2.2:8000`

---

## 9. Contoh Implementasi Django View

```python
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.contrib.auth import authenticate, login as auth_login, logout as auth_logout
import json

@csrf_exempt
def login(request):
    if request.method == 'POST':
        username = request.POST.get('username')
        password = request.POST.get('password')
        user = authenticate(request, username=username, password=password)
        if user is not None:
            auth_login(request, user)
            return JsonResponse({
                'status': True,
                'message': 'Login berhasil!',
                'username': user.username
            })
        else:
            return JsonResponse({
                'status': False,
                'message': 'Username atau password salah'
            }, status=401)

@csrf_exempt
def register(request):
    if request.method == 'POST':
        data = json.loads(request.body)
        # Implementasi registrasi
        # ...
        return JsonResponse({
            'status': 'success',
            'message': 'Registrasi berhasil!'
        })

@csrf_exempt
def logout(request):
    if request.method == 'POST':
        username = request.user.username
        auth_logout(request)
        return JsonResponse({
            'status': True,
            'message': 'Logged out successfully!',
            'username': username
        })

@csrf_exempt
def product_json(request):
    if request.method == 'GET':
        products = Product.objects.all()
        products_data = [{
            'user': p.user.id,
            'name': p.name,
            'price': p.price,
            'description': p.description,
            'thumbnail': p.thumbnail or '',
            'category': p.category,
            'is_featured': p.is_featured,
            'stock': p.stock,
            'brand': p.brand
        } for p in products]
        return JsonResponse(products_data, safe=False)

@csrf_exempt
def create_flutter(request):
    if request.method == 'POST':
        if not request.user.is_authenticated:
            return JsonResponse({
                'status': 'error',
                'message': 'User not authenticated'
            }, status=401)
        
        data = json.loads(request.body)
        product = Product.objects.create(
            user=request.user,  # Auto-assign dari session
            name=data['name'],
            price=data['price'],
            description=data['description'],
            category=data['category'],
            thumbnail=data.get('thumbnail', ''),
            is_featured=data.get('is_featured', False),
            stock=data['stock'],
            brand=data['brand']
        )
        return JsonResponse({
            'status': 'success',
            'message': 'Product created successfully'
        })
```

---

**Dokumen ini harus diberikan ke tim backend Django untuk memastikan integrasi berjalan dengan baik.**

