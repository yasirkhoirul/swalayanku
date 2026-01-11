import * as admin from "firebase-admin";
import { onRequest } from "firebase-functions/v2/https";
import { aprovedPesanan, buatPesanan } from "./triggers/transaksi.trigger";
// Import trigger transaksi kamu (sesuaikan path-nya jika beda)

// --- [PENTING] STARTER MESINNYA DI SINI ---
// Baris ini wajib ada dan cuma boleh dipanggil sekali
if (admin.apps.length === 0) {
  admin.initializeApp();
}
// ------------------------------------------

// 1. Export Trigger Transaksi (Yang logic pengurangan stok)

// 2. Export Tombol Ajaib (Isi Data Test)
export const isiDataTest = onRequest(async (req, res) => {
  const db = admin.firestore();
  const batch = db.batch();
  try {
    // A. Reset Barang (Stok jadi 100)
    const indomieRef = db.doc("barang/indomie");
    batch.set(indomieRef, {
      nama_barang: "Indomie Goreng",
      harga: 3500,
      stok: 50, // Stok Awal
    });

    // Barang B: Telur
    const telurRef = db.doc("barang/telur");
    batch.set(telurRef, {
      nama_barang: "Telur Ayam (1kg)",
      harga: 28000,
      stok: 20, // Stok Awal
    });

    // Barang C: Beras
    const berasRef = db.doc("barang/beras");
    batch.set(berasRef, {
      nama_barang: "Beras Pandan Wangi (5kg)",
      harga: 75000,
      stok: 10, // Stok Awal
    });

    await batch.commit();
    res.send(
      "✅ BERHASIL! Data Barang (Stok 100) dan Pesanan (Beli 5) sudah dibuat. Silakan cek Emulator UI."
    );
  } catch (error) {
    res.status(500).send(`❌ GAGAL: ${error}`);
  }
});

export const apiBuatPesanan = buatPesanan;
export const apiTindakanPesanan = aprovedPesanan;

