# Testing Firebase Cloud Functions dengan Postman di Lokal

## 1. Setup Firebase Emulator

Jalankan emulator:
```bash
cd functions
firebase emulators:start
```

Emulator akan berjalan di:
- Functions: http://localhost:5001
- Auth: http://localhost:9099
- Firestore: http://localhost:8080

## 2. Cara Login dengan Postman

### A. Buat User Dulu (Tanpa Auth - First Time Setup)

**Endpoint:** `POST http://localhost:5001/{project-id}/us-central1/createUserWithRole`

**Headers:**
```
Content-Type: application/json
```

**Body (raw JSON):**
```json
{
  "data": {
    "email": "admin@test.com",
    "password": "admin123",
    "nama": "Admin User",
    "role": "admin"
  }
}
```

**Response:**
```json
{
  "result": {
    "success": true,
    "message": "User berhasil dibuat",
    "data": {
      "uid": "abc123...",
      "email": "admin@test.com",
      "nama": "Admin User",
      "role": "admin"
    }
  }
}
```

### B. Login untuk Dapatkan ID Token

**Endpoint:** `POST http://localhost:9099/identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=fake-api-key`

**Headers:**
```
Content-Type: application/json
```

**Body (raw JSON):**
```json
{
  "email": "admin@test.com",
  "password": "admin123",
  "returnSecureToken": true
}
```

**Response:**
```json
{
  "idToken": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...",
  "email": "admin@test.com",
  "refreshToken": "...",
  "expiresIn": "3600",
  "localId": "abc123..."
}
```

**COPY `idToken` dari response!**

### C. Test Fungsi dengan Authentication

Untuk semua request ke Cloud Functions yang memerlukan auth:

**Headers:**
```
Content-Type: application/json
Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...
```

**Body format:**
```json
{
  "data": {
    // parameter function
  }
}
```

## 3. Contoh Request ke Cloud Functions

### Get User Info (Test Auth Berhasil)

**Endpoint:** `POST http://localhost:5001/{project-id}/us-central1/getUserInfo`

**Headers:**
```
Content-Type: application/json
Authorization: Bearer {idToken-dari-login}
```

**Body:**
```json
{
  "data": {}
}
```

### Buat Pesanan (Dengan Auth)

**Endpoint:** `POST http://localhost:5001/{project-id}/us-central1/buatPesanan`

**Headers:**
```
Content-Type: application/json
Authorization: Bearer {idToken-dari-login}
```

**Body:**
```json
{
  "data": {
    "items": [
      {
        "id": "barang1",
        "nama": "Sabun",
        "harga": 5000,
        "qty": 2
      }
    ]
  }
}
```

### Approve Pesanan (Hanya Admin)

**Endpoint:** `POST http://localhost:5001/{project-id}/us-central1/aprovedPesanan`

**Headers:**
```
Content-Type: application/json
Authorization: Bearer {idToken-dari-login-admin}
```

**Body:**
```json
{
  "data": {
    "idPesanan": "pesanan123",
    "keputusan": "terima"
  }
}
```

## 4. Postman Environment Variables

Buat Environment di Postman dengan variables:

```
baseUrl = http://localhost:5001/{project-id}/us-central1
authUrl = http://localhost:9099/identitytoolkit.googleapis.com/v1
idToken = (akan di-set setelah login)
```

## 5. Error Response

### Tidak Login:
```json
{
  "error": {
    "code": "unauthenticated",
    "message": "Anda harus login terlebih dahulu"
  }
}
```

### Role Tidak Sesuai:
```json
{
  "error": {
    "code": "permission-denied",
    "message": "Akses ditolak. Memerlukan role: admin"
  }
}
```

## 6. Tips Testing

1. **Token Expired**: ID Token berlaku 1 jam, setelah itu login ulang
2. **Multiple Users**: Buat beberapa user dengan role berbeda untuk testing
3. **Emulator Data**: Data di emulator akan hilang saat restart
4. **Project ID**: Ganti `{project-id}` dengan project ID Firebase Anda

## 7. Struktur User Roles

- **admin**: Bisa approve/tolak pesanan, lihat summary
- **kasir**: Bisa buat pesanan, lihat transaksi
- **user**: Hanya bisa buat pesanan sendiri

## 8. Quick Start Script

Buat user admin pertama kali:
```bash
# Di Postman:
POST http://localhost:5001/{project-id}/us-central1/createUserWithRole
Body: {"data": {"email": "admin@test.com", "password": "admin123", "nama": "Admin", "role": "admin"}}
```

Login:
```bash
POST http://localhost:9099/identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=fake-api-key
Body: {"email": "admin@test.com", "password": "admin123", "returnSecureToken": true}
```

Copy idToken, pakai di header semua request selanjutnya!
