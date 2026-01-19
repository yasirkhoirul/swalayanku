import * as admin from "firebase-admin";
import { HttpsError, onCall } from "firebase-functions/https";
import { FieldValue } from "firebase-admin/firestore";

/**
 * Fungsi untuk membuat user baru dengan role
 * SECURITY: Hanya bisa dipanggil oleh admin yang sudah login
 * Atau saat running di emulator (development mode)
 */
export const createUserBasic = onCall(async (req) => {
  const { email, password, nama } = req.data;
  if (!email || !password || !nama) {
    throw new HttpsError("invalid-argument", "Data tidak lengkap");
  }
  try {
    let createuser: admin.auth.UserRecord;
    try {
      createuser = await admin.auth().getUserByEmail(email);
    } catch (error: any) {
      if (error.code === "auth/user-not-found") {
        createuser = await admin.auth().createUser({
          email,
          password,
          displayName: nama,
        });
      } else {
        throw error;
      }
    }
    const userFirestore = await admin
      .firestore()
      .collection("users")
      .doc(createuser.uid)
      .get();

    if (userFirestore.exists) {
      throw new HttpsError("already-exists", "User sudah terdaftar");
    }
    await admin.firestore().collection("users").doc(createuser.uid).create({
      uid: createuser.uid,
      email: email,
      nama: nama,
      role: "users",
      created_at: FieldValue.serverTimestamp(),
      updated_at: FieldValue.serverTimestamp(),
    });
    return {
      succes: true,
      message: "User berhasil dibuat",
      data: {
        nama: nama,
        email: email,
        uid: createuser.uid,
        role: "users",
      },
    };
  } catch (error: any) {
    console.error("Gagal membuat user:", error);
    throw new HttpsError("internal", error.message);
  }
});

export const createUserWithRole = onCall(async (req) => {
  const { email, password, nama, role } = req.data;

  // Check apakah running di emulator (development)
  const isEmulator = process.env.FUNCTIONS_EMULATOR === "true";

  // Jika production, harus login sebagai admin
  if (!isEmulator) {
    if (!req.auth) {
      throw new HttpsError(
        "unauthenticated",
        "Anda harus login terlebih dahulu"
      );
    }

    // Validasi bahwa yang request adalah admin
    const adminDoc = await admin
      .firestore()
      .collection("users")
      .doc(req.auth.uid)
      .get();

    if (!adminDoc.exists || adminDoc.data()?.role !== "admin") {
      throw new HttpsError(
        "permission-denied",
        "Hanya admin yang bisa membuat user baru"
      );
    }
  }

  if (!email || !password || !nama) {
    throw new HttpsError(
      "invalid-argument",
      "Email, password, dan nama harus diisi"
    );
  }

  const allowedRoles = ["admin", "kasir", "user"];
  const userRole = role || "user";

  if (!allowedRoles.includes(userRole)) {
    throw new HttpsError(
      "invalid-argument",
      `Role harus salah satu dari: ${allowedRoles.join(", ")}`
    );
  }

  try {
    // Buat user di Firebase Auth
    const userRecord = await admin.auth().createUser({
      email: email,
      password: password,
      displayName: nama,
    });

    // Set custom claims untuk role
    await admin.auth().setCustomUserClaims(userRecord.uid, { role: userRole });

    // Simpan data user di Firestore
    await admin.firestore().collection("users").doc(userRecord.uid).set({
      uid: userRecord.uid,
      email: email,
      nama: nama,
      role: userRole,
      created_at: FieldValue.serverTimestamp(),
      updated_at: FieldValue.serverTimestamp(),
    });

    return {
      success: true,
      message: "User berhasil dibuat",
      data: {
        uid: userRecord.uid,
        email: email,
        nama: nama,
        role: userRole,
      },
    };
  } catch (error: any) {
    console.error("Gagal membuat user:", error);
    throw new HttpsError("internal", error.message);
  }
});

/**
 * Fungsi untuk mendapatkan info user yang sedang login
 */
export const getUserInfo = onCall(async (req) => {
  if (!req.auth) {
    throw new HttpsError("unauthenticated", "Anda harus login terlebih dahulu");
  }

  try {
    const userDoc = await admin
      .firestore()
      .collection("users")
      .doc(req.auth.uid)
      .get();

    if (!userDoc.exists) {
      throw new HttpsError("not-found", "Data user tidak ditemukan");
    }

    const userData = userDoc.data();

    return {
      success: true,
      data: {
        uid: req.auth.uid,
        email: userData?.email,
        nama: userData?.nama,
        role: userData?.role,
      },
    };
  } catch (error: any) {
    console.error("Gagal ambil info user:", error);
    throw new HttpsError("internal", error.message);
  }
});

/**
 * Fungsi untuk update role user (hanya admin)
 */
export const updateUserRole = onCall(async (req) => {
  if (!req.auth) {
    throw new HttpsError("unauthenticated", "Anda harus login terlebih dahulu");
  }

  // Check apakah user yang request adalah admin
  const adminDoc = await admin
    .firestore()
    .collection("users")
    .doc(req.auth.uid)
    .get();

  if (!adminDoc.exists || adminDoc.data()?.role !== "admin") {
    throw new HttpsError(
      "permission-denied",
      "Hanya admin yang bisa mengubah role"
    );
  }

  const { uid, newRole } = req.data;

  if (!uid || !newRole) {
    throw new HttpsError("invalid-argument", "UID dan role baru harus diisi");
  }

  const allowedRoles = ["admin", "kasir", "user"];
  if (!allowedRoles.includes(newRole)) {
    throw new HttpsError(
      "invalid-argument",
      `Role harus salah satu dari: ${allowedRoles.join(", ")}`
    );
  }

  try {
    // Update custom claims
    await admin.auth().setCustomUserClaims(uid, { role: newRole });

    // Update di Firestore
    await admin.firestore().collection("users").doc(uid).update({
      role: newRole,
      updated_at: FieldValue.serverTimestamp(),
    });

    return {
      success: true,
      message: "Role berhasil diupdate",
    };
  } catch (error: any) {
    console.error("Gagal update role:", error);
    throw new HttpsError("internal", error.message);
  }
});
