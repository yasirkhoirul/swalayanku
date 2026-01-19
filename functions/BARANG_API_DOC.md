# 📦 Barang Management API Documentation

## Overview
API untuk mengelola barang/produk dengan fitur lengkap termasuk CRUD, soft delete, restore, dan tracking stok.

**Role Required**: **Admin Only** (kecuali Get Barang - public)

---

## 📋 Endpoints

### 1. **Tambah Barang** - `apiTambahBarang`

Menambahkan barang baru ke inventory.

**Request:**
```json
{
  "data": {
    "nama": "Indomie Goreng",
    "harga": 3000,
    "stok": 100,
    "kategori": "Makanan",      // Optional
    "deskripsi": "Mie instan",  // Optional
    "gambar": "https://example.com/image.jpg"  // Optional, URL gambar
  }
}
```

**Response Success:**
```json
{
  "result": {
    "success": true,
    "message": "Barang berhasil ditambahkan",
    "id_barang": "abc123...",
    "data": {
      "id": "abc123...",
      "nama": "Indomie Goreng",
      "harga": 3000,
      "stok": 100,
      "kategori": "Makanan",
      "deskripsi": "Mie instan",
      "gambar": "https://example.com/image.jpg",
      "created_by": "uid_admin",
      "created_at": "timestamp",
      "updated_at": "timestamp"
    }
  }
}
```

**Validasi:**
- ✅ `nama` - Required
- ✅ `harga` - Required, harus > 0
- ✅ `stok` - Required, harus >= 0
- ⚠️ Hanya admin yang bisa menambah barang

---

### 2. **Update Barang** - `apiUpdateBarang`

Update informasi barang (semua field optional kecuali id_barang).

**Request:**
```json
{
  "data": {
    "id_barang": "abc123",
    "nama": "Indomie Goreng Jumbo",     // Optional
    "harga": 3500,                      // Optional
    "stok": 120,                        // Optional
    "kategori": "Makanan Instant",      // Optional
    "deskripsi": "Update deskripsi",    // Optional
    "gambar": "https://new-url.jpg"     // Optional
  }
}
```

**Response:**
```json
{
  "result": {
    "success": true,
    "message": "Barang berhasil diupdate",
    "id_barang": "abc123"
  }
}
```

**Note:**
- Hanya field yang dikirim yang akan di-update
- Field lain tetap seperti semula

---

### 3. **Update Stok Barang** - `apiUpdateStok`

Khusus untuk update stok saja (dengan audit trail).

**Request:**
```json
{
  "data": {
    "id_barang": "abc123",
    "stok": 150,
    "keterangan": "Restock dari supplier"  // Optional
  }
}
```

**Response:**
```json
{
  "result": {
    "success": true,
    "message": "Stok berhasil diupdate",
    "id_barang": "abc123",
    "stok_lama": 100,
    "stok_baru": 150,
    "selisih": 50
  }
}
```

**Features:**
- 📝 Menyimpan history perubahan stok di collection `stok_history`
- 📊 Tracking selisih stok
- 🔍 Audit trail (siapa yang update)

---

### 4. **Hapus Barang** - `apiHapusBarang`

Menghapus barang (soft delete atau permanent).

**Soft Delete (Default):**
```json
{
  "data": {
    "id_barang": "abc123",
    "hard_delete": false
  }
}
```

**Response:**
```json
{
  "result": {
    "success": true,
    "message": "Barang berhasil dihapus (soft delete)",
    "id_barang": "abc123",
    "info": "Data masih tersimpan, bisa direstore"
  }
}
```

**Hard Delete (Permanent):**
```json
{
  "data": {
    "id_barang": "abc123",
    "hard_delete": true
  }
}
```

**Response:**
```json
{
  "result": {
    "success": true,
    "message": "Barang berhasil dihapus permanent",
    "id_barang": "abc123"
  }
}
```

**Perbedaan:**
| Type | Soft Delete | Hard Delete |
|------|-------------|-------------|
| Data | Masih di DB | Terhapus permanent |
| Restore | ✅ Bisa | ❌ Tidak bisa |
| Tampil di list | ❌ Tidak (by default) | ❌ Tidak |

---

### 5. **Restore Barang** - `apiRestoreBarang`

Mengembalikan barang yang di-soft delete.

**Request:**
```json
{
  "data": {
    "id_barang": "abc123"
  }
}
```

**Response:**
```json
{
  "result": {
    "success": true,
    "message": "Barang berhasil direstore",
    "id_barang": "abc123"
  }
}
```

---

### 6. **Get Semua Barang** - `apiGetBarang` 🌐 Public

Mendapatkan list semua barang.

**Request:**
```json
{
  "data": {
    "include_deleted": false  // Optional, default: false
  }
}
```

**Response:**
```json
{
  "result": {
    "success": true,
    "total": 10,
    "data": [
      {
        "id": "abc123",
        "nama": "Indomie Goreng",
        "harga": 3000,
        "stok": 100,
        "kategori": "Makanan",
        "deskripsi": "Mie instan",
        "gambar": "https://example.com/image.jpg",
        "created_at": "timestamp"
      },
      // ... more items
    ]
  }
}
```

**Note:**
- ✅ Tidak perlu authentication
- By default tidak menampilkan barang yang di-delete
- Set `include_deleted: true` untuk melihat barang deleted (admin saja)

---

### 7. **Get Detail Barang** - `apiGetDetailBarang` 🌐 Public

Mendapatkan detail lengkap satu barang.

**Request:**
```json
{
  "data": {
    "id_barang": "abc123"
  }
}
```

**Response:**
```json
{
  "result": {
    "success": true,
    "data": {
      "id": "abc123",
      "nama": "Indomie Goreng",
      "harga": 3000,
      "stok": 100,
      "kategori": "Makanan",
      "deskripsi": "Mie instan rasa goreng",
      "gambar": "https://example.com/image.jpg",
      "created_by": "uid_admin",
      "created_at": "timestamp",
      "updated_at": "timestamp"
    }
  }
}
```

---

## 🔒 Security & Permissions

### Role Requirements:

| Function | Admin | Kasir | User | Public |
|----------|-------|-------|------|--------|
| Tambah Barang | ✅ | ❌ | ❌ | ❌ |
| Update Barang | ✅ | ❌ | ❌ | ❌ |
| Update Stok | ✅ | ❌ | ❌ | ❌ |
| Hapus Barang | ✅ | ❌ | ❌ | ❌ |
| Restore Barang | ✅ | ❌ | ❌ | ❌ |
| Get Semua Barang | ✅ | ✅ | ✅ | ✅ |
| Get Detail Barang | ✅ | ✅ | ✅ | ✅ |

---

## 📊 Database Structure

### Collection: `barang`

```typescript
{
  id: string,                    // Auto-generated
  nama: string,                  // Required
  harga: number,                 // Required, > 0
  stok: number,                  // Required, >= 0
  kategori: string,              // Optional, default: "Umum"
  deskripsi: string,             // Optional
  gambar: string | null,         // Optional, URL gambar
  
  // Metadata
  created_by: string,            // UID admin yang buat
  created_at: Timestamp,
  updated_at: Timestamp,
  updated_by?: string,           // UID admin yang update
  
  // Soft delete
  deleted?: boolean,
  deleted_at?: Timestamp,
  deleted_by?: string,
  
  // Restore
  restored_at?: Timestamp,
  restored_by?: string
}
```

### Collection: `stok_history`

```typescript
{
  id_barang: string,
  nama_barang: string,
  stok_lama: number,
  stok_baru: number,
  selisih: number,              // stok_baru - stok_lama
  keterangan: string,           // "Update manual", "Restock", etc
  updated_by: string,           // UID admin
  created_at: Timestamp
}
```

---

## 🖼️ Upload Gambar

### Option 1: External URL (Recommended untuk awal)

Simpan gambar di hosting lain (Cloudinary, ImgBB, dll) lalu simpan URL-nya:

```json
{
  "gambar": "https://cloudinary.com/image/indomie.jpg"
}
```

### Option 2: Firebase Storage (Future Enhancement)

Untuk upload langsung ke Firebase Storage, perlu tambah endpoint terpisah:

```typescript
// Future: uploadGambarBarang
// 1. Upload file ke Storage
// 2. Get download URL
// 3. Save URL ke Firestore
```

**Sementara**, gunakan URL external untuk gambar.

---

## 🧪 Testing dengan Postman

### Setup:
1. Import `Swalayam_Ku.postman_collection.json`
2. Login sebagai admin untuk dapat token
3. Test endpoints di folder **"4. Barang Management (Admin)"**

### Test Flow:

```
1. Login Admin → Get Token
2. Tambah Barang → Copy id_barang
3. Update Barang → Ubah harga/nama
4. Update Stok → Tambah stok
5. Get Semua Barang → Lihat list
6. Hapus Barang (Soft) → Barang hilang dari list
7. Get Semua Barang (include_deleted: true) → Barang muncul
8. Restore Barang → Barang kembali
9. Hapus Permanent → Barang hilang selamanya
```

---

## ⚠️ Error Handling

### Common Errors:

**Unauthenticated:**
```json
{
  "error": {
    "code": "unauthenticated",
    "message": "Anda harus login terlebih dahulu"
  }
}
```

**Permission Denied:**
```json
{
  "error": {
    "code": "permission-denied",
    "message": "Akses ditolak. Memerlukan role: admin"
  }
}
```

**Not Found:**
```json
{
  "error": {
    "code": "not-found",
    "message": "Barang tidak ditemukan"
  }
}
```

**Invalid Argument:**
```json
{
  "error": {
    "code": "invalid-argument",
    "message": "Harga harus lebih dari 0"
  }
}
```

---

## 🚀 Production URLs

Replace `localhost` dengan production URL setelah deploy:

```
https://us-central1-swalayanku-30436.cloudfunctions.net/apiTambahBarang
https://us-central1-swalayanku-30436.cloudfunctions.net/apiUpdateBarang
https://us-central1-swalayanku-30436.cloudfunctions.net/apiUpdateStok
https://us-central1-swalayanku-30436.cloudfunctions.net/apiHapusBarang
https://us-central1-swalayanku-30436.cloudfunctions.net/apiGetBarang
https://us-central1-swalayanku-30436.cloudfunctions.net/apiGetDetailBarang
https://us-central1-swalayanku-30436.cloudfunctions.net/apiRestoreBarang
```

---

## 📝 Best Practices

1. **Soft Delete First**: Gunakan soft delete untuk keamanan data
2. **Audit Trail**: Update stok melalui `apiUpdateStok` untuk tracking
3. **Gambar**: Gunakan CDN/cloud storage untuk performa
4. **Validation**: Selalu validasi input di client sebelum API call
5. **Batch Operations**: Untuk update banyak barang, pertimbangkan batch endpoint

---

## 🔄 Future Enhancements

- [ ] Bulk upload barang (CSV/Excel)
- [ ] Upload gambar ke Firebase Storage
- [ ] Kategori management (CRUD kategori)
- [ ] Low stock alert
- [ ] Batch update stok
- [ ] Export data barang (PDF/Excel)
- [ ] Barcode/QR code integration

**Happy Managing! 📦**
