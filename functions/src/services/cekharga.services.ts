import { Barang } from "../interfaces/transaksi";
import * as admin from "firebase-admin";
// import * as admin from "firebase-admin"; // <-- Gak butuh ini lagi kalau cuma baca reference

export class TransaksiService {
  static async hitungTotalHarga(items: Barang[]): Promise<number> {
    const db = admin.firestore(); // <-- HAPUS (Gak kepakai)

    // Langsung jalankan parallel request
    const checkPromises = items.map(async (e) => {
      let barangRef;
      if (typeof e.id_barang === "string") {
        barangRef = db.doc(e.id_barang);
      } else {
        barangRef = e.id_barang;
      }
      const snapShot = await barangRef.get();

      if (snapShot.exists) {
        // Kita casting 'as any' dulu atau pastikan interface Barang punya field harga
        const dataBarang = snapShot.data();

        // Safety: Kalau harga undefined, anggap 0
        const hargaAsli = dataBarang?.harga || 0;

        return hargaAsli * e.qty;
      } else {
        throw new Error(
          `Barang dengan ID ${barangRef.id} tidak ditemukan. Mohon hapus dari keranjang.`
        );
      }
    });

    // Tunggu semua selesai
    const hasilPerItem = await Promise.all(checkPromises);

    // Jumlahkan semua
    const totalHitung = hasilPerItem.reduce(
      (prev, element) => prev + element,
      0
    );

    return totalHitung;
  }
}
