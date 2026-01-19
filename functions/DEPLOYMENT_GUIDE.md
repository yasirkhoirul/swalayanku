# 🚀 Panduan Deploy ke Firebase Production

## 📋 Pre-Deployment Checklist

### 1. Security Check ✅
- ✅ `createUserWithRole` sudah di-secure (hanya admin/emulator)
- ✅ `aprovedPesanan` hanya bisa dipanggil admin
- ✅ `buatPesanan` butuh authentication

### 2. Build & Test
```bash
cd functions
npm run build
npm test  # jika ada test
```

### 3. Review Firebase Project
```bash
firebase projects:list
firebase use <project-id>  # Pilih project yang benar
```

---

## 🔥 Cara Deploy

### Deploy Semua Functions
```bash
cd functions
firebase deploy --only functions
```

### Deploy Function Spesifik
```bash
firebase deploy --only functions:apiBuatPesanan
firebase deploy --only functions:apiTindakanPesanan
```

### Deploy dengan Preview
```bash
firebase deploy --only functions --debug
```

---

## 👤 Setup Admin Pertama (Manual di Firebase Console)

**⚠️ PENTING: Buat admin pertama secara manual untuk keamanan!**

### Method 1: Via Firebase Console (Recommended)

#### Step 1: Buat User di Authentication
1. Buka [Firebase Console](https://console.firebase.google.com)
2. Pilih project Anda
3. **Authentication** → **Users** → **Add User**
4. Masukkan:
   - Email: `admin@yourdomain.com`
   - Password: (password kuat)
5. Copy **User UID** yang baru dibuat

#### Step 2: Set Custom Claims via Cloud Functions Console

Di Cloud Functions Console, run script ini:

```javascript
const admin = require('firebase-admin');
admin.initializeApp();

const uid = 'PASTE_UID_DARI_STEP_1';

admin.auth().setCustomUserClaims(uid, { role: 'admin' })
  .then(() => {
    console.log('✅ Custom claims set');
    return admin.firestore().collection('users').doc(uid).set({
      uid: uid,
      email: 'admin@yourdomain.com',
      nama: 'Super Admin',
      role: 'admin',
      created_at: admin.firestore.FieldValue.serverTimestamp(),
      updated_at: admin.firestore.FieldValue.serverTimestamp()
    });
  })
  .then(() => console.log('✅ Firestore updated'))
  .catch(err => console.error('❌ Error:', err));
```

#### Step 3: Atau Gunakan Firebase CLI

```bash
# Install firebase-admin jika belum
npm install -g firebase-tools

# Buat file setup-admin.js
```

Buat file `setup-admin.js`:

```javascript
const admin = require('firebase-admin');
const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const email = 'admin@yourdomain.com';
const password = 'YourStrongPassword123!';
const nama = 'Super Admin';

async function setupAdmin() {
  try {
    // Create user
    const userRecord = await admin.auth().createUser({
      email: email,
      password: password,
      displayName: nama
    });
    
    console.log('✅ User created:', userRecord.uid);
    
    // Set custom claims
    await admin.auth().setCustomUserClaims(userRecord.uid, { role: 'admin' });
    console.log('✅ Custom claims set');
    
    // Save to Firestore
    await admin.firestore().collection('users').doc(userRecord.uid).set({
      uid: userRecord.uid,
      email: email,
      nama: nama,
      role: 'admin',
      created_at: admin.firestore.FieldValue.serverTimestamp(),
      updated_at: admin.firestore.FieldValue.serverTimestamp()
    });
    
    console.log('✅ Admin setup complete!');
    console.log('Email:', email);
    console.log('UID:', userRecord.uid);
    
    process.exit(0);
  } catch (error) {
    console.error('❌ Error:', error);
    process.exit(1);
  }
}

setupAdmin();
```

Jalankan:
```bash
node setup-admin.js
```

### Method 2: Via Firebase Functions (Temporary)

Buat function sementara yang hanya jalan sekali:

```typescript
// functions/src/setup/init-admin.ts
import * as admin from "firebase-admin";
import { onRequest } from "firebase-functions/v2/https";

// HAPUS SETELAH ADMIN PERTAMA DIBUAT!
export const initFirstAdmin = onRequest(async (req, res) => {
  // Security: Hanya bisa dipanggil sekali
  const adminExists = await admin
    .firestore()
    .collection("users")
    .where("role", "==", "admin")
    .limit(1)
    .get();

  if (!adminExists.empty) {
    res.status(403).send("Admin sudah ada! Function ini disabled.");
    return;
  }

  const email = "admin@yourdomain.com";
  const password = "ChangeThisPassword123!";
  
  try {
    const userRecord = await admin.auth().createUser({
      email: email,
      password: password,
      displayName: "First Admin"
    });

    await admin.auth().setCustomUserClaims(userRecord.uid, { role: "admin" });

    await admin.firestore().collection("users").doc(userRecord.uid).set({
      uid: userRecord.uid,
      email: email,
      nama: "First Admin",
      role: "admin",
      created_at: admin.firestore.FieldValue.serverTimestamp(),
      updated_at: admin.firestore.FieldValue.serverTimestamp()
    });

    res.send({
      success: true,
      message: "Admin pertama berhasil dibuat!",
      uid: userRecord.uid,
      email: email,
      warning: "SEGERA HAPUS FUNCTION INI!"
    });
  } catch (error: any) {
    res.status(500).send({ error: error.message });
  }
});
```

Deploy & call sekali:
```bash
firebase deploy --only functions:initFirstAdmin
curl https://YOUR-REGION-YOUR-PROJECT.cloudfunctions.net/initFirstAdmin
```

**⚠️ SEGERA HAPUS FUNCTION INI SETELAH DIGUNAKAN!**

---

## 🔒 Security Rules Firestore

Buat file `firestore.rules`:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Users collection
    match /users/{userId} {
      // Hanya user sendiri atau admin yang bisa baca
      allow read: if request.auth != null && 
                     (request.auth.uid == userId || 
                      get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin');
      
      // Hanya admin yang bisa write
      allow write: if request.auth != null && 
                      get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
    
    // Pesanan collection
    match /pesanan/{pesananId} {
      // User bisa baca pesanannya sendiri, admin bisa baca semua
      allow read: if request.auth != null && 
                     (resource.data.uid_user == request.auth.uid || 
                      get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin');
      
      // User bisa create pesanannya sendiri
      allow create: if request.auth != null && 
                       request.resource.data.uid_user == request.auth.uid;
      
      // Hanya admin yang bisa update (approve/reject)
      allow update: if request.auth != null && 
                       get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
      
      allow delete: if false; // Tidak ada yang bisa delete
    }
    
    // Barang collection (public read, admin write)
    match /barang/{barangId} {
      allow read: if true;
      allow write: if request.auth != null && 
                      get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
    
    // Default: deny all
    match /{document=**} {
      allow read, write: if false;
    }
  }
}
```

Deploy rules:
```bash
firebase deploy --only firestore:rules
```

---

## 🧪 Test di Production

### 1. Login Admin Pertama

```bash
POST https://YOUR-REGION-YOUR-PROJECT.cloudfunctions.net/apiGetUserInfo
Headers:
  Authorization: Bearer <id_token_from_login>
```

### 2. Buat User Baru (Sebagai Admin)

```bash
POST https://YOUR-REGION-YOUR-PROJECT.cloudfunctions.net/apiCreateUser
Headers:
  Authorization: Bearer <admin_token>
Body:
{
  "data": {
    "email": "kasir1@yourdomain.com",
    "password": "kasir123",
    "nama": "Kasir 1",
    "role": "kasir"
  }
}
```

---

## 📊 Monitoring

### Lihat Logs
```bash
firebase functions:log
firebase functions:log --only apiTindakanPesanan
```

### Real-time Logs
```bash
firebase functions:log --follow
```

### Error Alerts
Setup di Firebase Console → Functions → Usage

---

## 🔄 Rollback jika Ada Masalah

```bash
# Lihat deployment history
firebase functions:list

# Rollback ke versi sebelumnya
firebase functions:rollback <function-name>
```

---

## 📝 Environment Variables (Optional)

Jika butuh API keys atau config:

```bash
firebase functions:config:set someservice.key="THE_API_KEY"
firebase deploy --only functions
```

Akses di code:
```typescript
const apiKey = functions.config().someservice.key;
```

---

## ✅ Post-Deployment Checklist

- [ ] Admin pertama sudah dibuat
- [ ] Function `initFirstAdmin` sudah dihapus (jika digunakan)
- [ ] Test login admin berhasil
- [ ] Test create user sebagai admin berhasil
- [ ] Test approve pesanan sebagai admin berhasil
- [ ] Test user biasa tidak bisa approve
- [ ] Firestore rules sudah di-deploy
- [ ] Monitoring & logs dicek
- [ ] Dokumentasi API sudah update dengan URL production

---

## 🆘 Troubleshooting

### Error: "Functions deployment failed"
```bash
# Check logs
firebase functions:log --only <function-name>

# Try deploy dengan debug
firebase deploy --only functions --debug
```

### Error: "Permission denied"
- Pastikan custom claims sudah di-set
- User harus logout & login ulang setelah role diubah
- Check Firestore rules

### Token Expired
- Token Firebase berlaku 1 jam
- Client harus refresh token atau login ulang

---

## 🎯 Next Steps

1. Setup monitoring & alerts
2. Backup Firestore secara berkala
3. Setup staging environment
4. CI/CD automation dengan GitHub Actions

**Production URL Format:**
```
https://YOUR-REGION-YOUR-PROJECT.cloudfunctions.net/FUNCTION_NAME
```

Region biasanya: `us-central1`, `asia-southeast1`, dll.

**Happy Deploying! 🚀**
