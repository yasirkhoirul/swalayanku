# 🚀 Quick Start Guide - Testing dengan Postman

## ✅ Status: Emulator Berjalan!

Emulator sudah running di:
- 🔥 **Functions**: http://localhost:5001
- 🔐 **Auth**: http://localhost:9099  
- 📦 **Firestore**: http://localhost:8080
- 🎨 **Emulator UI**: http://localhost:4001

---

## 📋 Langkah Testing (Copy-Paste Ready!)

### 1. Import Postman Collection

1. Buka Postman
2. Klik **Import** 
3. Pilih file: `Swalayam_Ku.postman_collection.json`
4. **PENTING**: Edit variable `baseUrl` → ganti `YOUR-PROJECT-ID` dengan project ID Firebase Anda

### 2. Buat User Admin (First Time)

**Request:** `1. Auth → Create User (Admin)`

Klik **Send**

✅ Response:
```json
{
  "result": {
    "success": true,
    "message": "User berhasil dibuat",
    "data": {
      "uid": "...",
      "email": "admin@test.com",
      "role": "admin"
    }
  }
}
```

### 3. Login & Dapatkan Token

**Request:** `1. Auth → Login`

Klik **Send**

✅ Response akan otomatis save `idToken` ke environment variable!

```json
{
  "idToken": "eyJhbGciOi...",
  "email": "admin@test.com",
  "localId": "..."
}
```

### 4. Test Authentication

**Request:** `1. Auth → Get User Info`

Klik **Send** (Token sudah auto attach di header)

✅ Response:
```json
{
  "result": {
    "success": true,
    "data": {
      "uid": "...",
      "email": "admin@test.com",
      "nama": "Admin User",
      "role": "admin"
    }
  }
}
```

### 5. Buat Pesanan

**Request:** `2. Transaksi → Buat Pesanan`

Klik **Send**

✅ Response:
```json
{
  "result": {
    "success": true,
    "message": "Pesanan berhasil dibuat",
    "id_pesanan": "abc123..."
  }
}
```

**COPY id_pesanan dari response!**

### 6. Approve Pesanan (Admin Only)

**Request:** `2. Transaksi → Approve Pesanan`

1. **Paste** `id_pesanan` ke body request
2. Klik **Send**

✅ Response:
```json
{
  "result": {
    "success": true,
    "message": "Pesanan berhasil di-terima"
  }
}
```

### 7. Lihat Summary

**Request:** `3. Summary & History → Get Summary Transaksi`

Klik **Send**

✅ Response:
```json
{
  "result": {
    "success": true,
    "data": {
      "jumlah_transaksi": 1,
      "pending": 0,
      "diterima": 1,
      "ditolak": 0,
      "total_nilai": 25000,
      "persentase": {
        "pending": "0.00",
        "diterima": "100.00",
        "ditolak": "0.00"
      }
    }
  }
}
```

---

## 🧪 Test Scenarios

### Test Role-Based Access

1. **Buat user kasir**:
   - Request: `1. Auth → Create User (Kasir)`
   - Email: `kasir@test.com`

2. **Login sebagai kasir**:
   - Request: `1. Auth → Login`
   - Ganti body: `{"email": "kasir@test.com", "password": "kasir123", "returnSecureToken": true}`

3. **Coba approve pesanan** (harusnya GAGAL):
   - Request: `2. Transaksi → Approve Pesanan`
   - Expected error: `permission-denied`

### Test Tanpa Login

1. Hapus header `Authorization` dari request
2. Coba buat pesanan
3. Expected error: `unauthenticated`

---

## 🔧 Troubleshooting

### Token Expired?
Re-run request **Login** untuk dapatkan token baru

### Port sudah dipakai?
```bash
netstat -ano | findstr "9099 8080"
taskkill /F /PID [PID_NUMBER]
```

### Lihat data di Emulator UI
Buka: http://localhost:4001

---

## 📌 Endpoint Summary

| Endpoint | Auth Required | Role | Deskripsi |
|----------|--------------|------|-----------|
| `apiCreateUser` | ❌ | - | Buat user baru |
| `apiGetUserInfo` | ✅ | All | Info user login |
| `apiBuatPesanan` | ✅ | All | Buat pesanan |
| `apiTindakanPesanan` | ✅ | Admin | Approve/tolak |
| `getSumarry` | ❌ | - | Summary total |
| `getSummaryMonth` | ❌ | - | Summary per bulan |
| `apiHistory` | ❌ | - | History bulan tertentu |

---

## 🎯 Next Steps

1. ✅ Test semua endpoint
2. ✅ Verifikasi role admin vs kasir
3. ✅ Check data di Emulator UI
4. Deploy ke production: `firebase deploy --only functions`

**Happy Testing! 🎉**
