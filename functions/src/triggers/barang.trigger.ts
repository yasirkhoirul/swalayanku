import * as admin from "firebase-admin";
import { HttpsError, onCall } from "firebase-functions/https";
import { FieldValue } from "firebase-admin/firestore";
import { AuthService } from "../services/auth.service";

/* eslint-disable camelcase */
// Disable camelcase karena API menggunakan snake_case untuk konsistensi

/**
 * Tambah barang baru (Admin only)
 * Support dengan gambar URL
 */
export const tambahBarang = onCall(async (req) => {
  // Validasi authentication & role
  const uid = AuthService.validateAuth(req.auth);
  await AuthService.checkRole(uid, ["admin"]);

  const { nama, harga, stok, kategori, deskripsi, gambar } = req.data;

  // Validasi input
  if (!nama || !harga || stok === undefined) {
    throw new HttpsError(
      "invalid-argument",
      "Nama, harga, dan stok harus diisi"
    );
  }

  if (harga <= 0) {
    throw new HttpsError("invalid-argument", "Harga harus lebih dari 0");
  }

  if (stok < 0) {
    throw new HttpsError("invalid-argument", "Stok tidak boleh negatif");
  }

  try {
    const db = admin.firestore();
    const barangData = {
      nama: nama,
      harga: harga,
      stok: stok,
      kategori: kategori || "Umum",
      deskripsi: deskripsi || "",
      gambar: gambar || null,
      created_by: uid,
      created_at: FieldValue.serverTimestamp(),
      updated_at: FieldValue.serverTimestamp(),
    };

    const docRef = await db.collection("barang").add(barangData);

    return {
      success: true,
      message: "Barang berhasil ditambahkan",
      id_barang: docRef.id,
      data: {
        id: docRef.id,
        ...barangData,
      },
    };
  } catch (error: any) {
    console.error("Gagal tambah barang:", error);
    throw new HttpsError("internal", error.message);
  }
});

/**
 * Update barang (Admin only)
 * Bisa update semua field termasuk gambar
 */
export const updateBarang = onCall(async (req) => {
  // Validasi authentication & role
  const uid = AuthService.validateAuth(req.auth);
  await AuthService.checkRole(uid, ["admin"]);

  const { id_barang, nama, harga, stok, kategori, deskripsi, gambar } =
    req.data;

  if (!id_barang) {
    throw new HttpsError("invalid-argument", "ID barang harus diisi");
  }

  // Validasi harga dan stok jika ada
  if (harga !== undefined && harga <= 0) {
    throw new HttpsError("invalid-argument", "Harga harus lebih dari 0");
  }

  if (stok !== undefined && stok < 0) {
    throw new HttpsError("invalid-argument", "Stok tidak boleh negatif");
  }

  try {
    const db = admin.firestore();
    const barangRef = db.collection("barang").doc(id_barang);

    // Check apakah barang exists
    const barangDoc = await barangRef.get();
    if (!barangDoc.exists) {
      throw new HttpsError("not-found", "Barang tidak ditemukan");
    }

    // Build update data (hanya field yang dikirim)
    const updateData: any = {
      updated_at: FieldValue.serverTimestamp(),
      updated_by: uid,
    };

    if (nama !== undefined) updateData.nama = nama;
    if (harga !== undefined) updateData.harga = harga;
    if (stok !== undefined) updateData.stok = stok;
    if (kategori !== undefined) updateData.kategori = kategori;
    if (deskripsi !== undefined) updateData.deskripsi = deskripsi;
    if (gambar !== undefined) updateData.gambar = gambar;

    await barangRef.update(updateData);

    return {
      success: true,
      message: "Barang berhasil diupdate",
      id_barang: id_barang,
    };
  } catch (error: any) {
    console.error("Gagal update barang:", error);
    throw new HttpsError("internal", error.message);
  }
});

/**
 * Update stok barang saja (Admin only)
 * Khusus untuk adjust stok manual
 */
export const updateStokBarang = onCall(async (req) => {
  // Validasi authentication & role
  const uid = AuthService.validateAuth(req.auth);
  await AuthService.checkRole(uid, ["admin"]);

  const { id_barang, stok, keterangan } = req.data;

  if (!id_barang || stok === undefined) {
    throw new HttpsError("invalid-argument", "ID barang dan stok harus diisi");
  }

  if (stok < 0) {
    throw new HttpsError("invalid-argument", "Stok tidak boleh negatif");
  }

  try {
    const db = admin.firestore();
    const barangRef = db.collection("barang").doc(id_barang);

    // Check apakah barang exists
    const barangDoc = await barangRef.get();
    if (!barangDoc.exists) {
      throw new HttpsError("not-found", "Barang tidak ditemukan");
    }

    const oldStok = barangDoc.data()?.stok || 0;

    await barangRef.update({
      stok: stok,
      updated_at: FieldValue.serverTimestamp(),
      updated_by: uid,
    });

    // Log perubahan stok (optional - untuk audit trail)
    await db.collection("stok_history").add({
      id_barang: id_barang,
      nama_barang: barangDoc.data()?.nama,
      stok_lama: oldStok,
      stok_baru: stok,
      selisih: stok - oldStok,
      keterangan: keterangan || "Update manual",
      updated_by: uid,
      created_at: FieldValue.serverTimestamp(),
    });

    return {
      success: true,
      message: "Stok berhasil diupdate",
      id_barang: id_barang,
      stok_lama: oldStok,
      stok_baru: stok,
      selisih: stok - oldStok,
    };
  } catch (error: any) {
    console.error("Gagal update stok:", error);
    throw new HttpsError("internal", error.message);
  }
});

/**
 * Hapus barang (Admin only)
 * Soft delete - set flag deleted
 */
export const hapusBarang = onCall(async (req) => {
  // Validasi authentication & role
  const uid = AuthService.validateAuth(req.auth);
  await AuthService.checkRole(uid, ["admin"]);

  const { id_barang, hard_delete } = req.data;

  if (!id_barang) {
    throw new HttpsError("invalid-argument", "ID barang harus diisi");
  }

  try {
    const db = admin.firestore();
    const barangRef = db.collection("barang").doc(id_barang);

    // Check apakah barang exists
    const barangDoc = await barangRef.get();
    if (!barangDoc.exists) {
      throw new HttpsError("not-found", "Barang tidak ditemukan");
    }

    if (hard_delete === true) {
      // Hard delete - hapus permanent
      await barangRef.delete();
      return {
        success: true,
        message: "Barang berhasil dihapus permanent",
        id_barang: id_barang,
      };
    } else {
      // Soft delete - set flag deleted
      await barangRef.update({
        deleted: true,
        deleted_at: FieldValue.serverTimestamp(),
        deleted_by: uid,
      });

      return {
        success: true,
        message: "Barang berhasil dihapus (soft delete)",
        id_barang: id_barang,
        info: "Data masih tersimpan, bisa direstore",
      };
    }
  } catch (error: any) {
    console.error("Gagal hapus barang:", error);
    throw new HttpsError("internal", error.message);
  }
});

/**
 * Get semua barang (Public)
 * Filter barang yang tidak di-delete
 */
export const getSemuaBarang = onCall(async (req) => {
  const { include_deleted } = req.data || {};

  try {
    const db = admin.firestore();
    let query = db.collection("barang").orderBy("nama");

    // Hanya admin yang bisa lihat barang deleted
    if (!include_deleted) {
      query = query.where("deleted", "!=", true);
    }

    const snapshot = await query.get();
    const barangList = snapshot.docs.map((doc) => ({
      id: doc.id,
      ...doc.data(),
    }));

    return {
      success: true,
      total: barangList.length,
      data: barangList,
    };
  } catch (error: any) {
    console.error("Gagal ambil barang:", error);
    throw new HttpsError("internal", error.message);
  }
});

/**
 * Get detail barang by ID
 */
export const getDetailBarang = onCall(async (req) => {
  const { id_barang } = req.data;

  if (!id_barang) {
    throw new HttpsError("invalid-argument", "ID barang harus diisi");
  }

  try {
    const db = admin.firestore();
    const barangDoc = await db.collection("barang").doc(id_barang).get();

    if (!barangDoc.exists) {
      throw new HttpsError("not-found", "Barang tidak ditemukan");
    }

    return {
      success: true,
      data: {
        id: barangDoc.id,
        ...barangDoc.data(),
      },
    };
  } catch (error: any) {
    console.error("Gagal ambil detail barang:", error);
    throw new HttpsError("internal", error.message);
  }
});

/**
 * Restore barang yang di-soft delete (Admin only)
 */
export const restoreBarang = onCall(async (req) => {
  // Validasi authentication & role
  const uid = AuthService.validateAuth(req.auth);
  await AuthService.checkRole(uid, ["admin"]);

  const { id_barang } = req.data;

  if (!id_barang) {
    throw new HttpsError("invalid-argument", "ID barang harus diisi");
  }

  try {
    const db = admin.firestore();
    const barangRef = db.collection("barang").doc(id_barang);

    const barangDoc = await barangRef.get();
    if (!barangDoc.exists) {
      throw new HttpsError("not-found", "Barang tidak ditemukan");
    }

    await barangRef.update({
      deleted: false,
      deleted_at: FieldValue.delete(),
      deleted_by: FieldValue.delete(),
      restored_at: FieldValue.serverTimestamp(),
      restored_by: uid,
    });

    return {
      success: true,
      message: "Barang berhasil direstore",
      id_barang: id_barang,
    };
  } catch (error: any) {
    console.error("Gagal restore barang:", error);
    throw new HttpsError("internal", error.message);
  }
});
