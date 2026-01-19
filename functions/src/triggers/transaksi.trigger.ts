import * as admin from "firebase-admin";
import { HttpsError, onCall } from "firebase-functions/https";
import { Barang, Pesanan } from "../interfaces/transaksi";
import { TransaksiService } from "../services/cekharga.services";
import { FieldValue } from "firebase-admin/firestore";
import { StokService } from "../services/stok.services";
import { AuthService } from "../services/auth.service";

admin.initializeApp();
export const buatPesanan = onCall(async (request) => {
  // Validasi authentication
  const uidUser = AuthService.validateAuth(request.auth);
  const pesanan = request.data.items as Barang[];
  if (pesanan.length <= 0 || !pesanan) {
    throw new HttpsError("invalid-argument", "keranjang tidak memiliki item");
  }
  try {
    const totalharga = await TransaksiService.hitungTotalHarga(pesanan);
    const db = admin.firestore();

    const pesananbaru = {
      uid_user: uidUser,
      items: pesanan,
      totalharga: totalharga,
      status_verifikasi: false,
      status_proses: "pending",
      created_at: FieldValue.serverTimestamp(),
      updated_at: FieldValue.serverTimestamp(),
    };

    const docRef = db.collection("pesanan");
    await StokService.kurangiStockBatch(pesanan);
    const req = await docRef.add(pesananbaru);
    return {
      success: true,
      message: "Pesanan berhasil dibuat",
      id_pesanan: req.id,
    };
  } catch (error: any) {
    console.error("Gagal buat pesanan:", error);
    // Kirim pesan error spesifik ke user (misal: "Barang X tidak ditemukan")
    throw new HttpsError("failed-precondition", error.message);
  }
});

export const aprovedPesanan = onCall(async (req) => {
  // Validasi authentication
  const uid = AuthService.validateAuth(req.auth);
  // Check role - hanya admin yang bisa approve pesanan
  await AuthService.checkRole(uid, ["admin"]);
  const input = req.data;
  const idPesanan: string = input.idPesanan;
  const keputusan: string = (input.keputusan as "terima") || "tolak";
  if (!idPesanan || !keputusan) {
    throw new HttpsError("invalid-argument", "data tidak lengkap");
  }
  const db = admin.firestore();
  const pesananRef = db.collection("pesanan").doc(idPesanan);

  try {
    await db.runTransaction(async (transaction) => {
      const docs = await transaction.get(pesananRef);
      if (!docs.exists) {
        throw new Error("pesanan tidak ditemukan");
      }
      const data: Pesanan = docs.data() as Pesanan;
      if (data.status_proses != "pending") {
        throw new Error("Pesanan sudah di verifikasi");
      }
      if (keputusan == "terima") {
        await transaction.update(pesananRef, {
          status_verifikasi: true,
          status_proses: "diterima",
        });
      } else {
        await StokService.kembalikanStok(data.items, transaction);
        await transaction.update(pesananRef, {
          status_verifikasi: false,
          status_proses: "ditolak",
        });
      }
    });
    return { success: true, message: `Pesanan berhasil di-${keputusan}` };
  } catch (error: any) {
    console.error("gagal melakukan tindakan");
    throw new HttpsError("failed-precondition", error.message);
  }
});

export const getTransaksiSummary = onCall(async () => {
  const db = admin.firestore();

  try {
    const pesananSnapshot = await db.collection("pesanan").get();

    let jumlahTransaksi = 0;
    let pending = 0;
    let diterima = 0;
    let ditolak = 0;
    let totalNilai = 0;

    pesananSnapshot.forEach((doc) => {
      const data: Pesanan = doc.data() as Pesanan;
      jumlahTransaksi++;

      if (data.status_proses === "pending") {
        pending++;
      } else if (data.status_proses === "diterima") {
        diterima++;
        totalNilai += data.totalharga || 0;
      } else if (data.status_proses === "ditolak") {
        ditolak++;
      }
    });

    return {
      success: true,
      data: {
        jumlah_transaksi: jumlahTransaksi,
        pending: pending,
        diterima: diterima,
        ditolak: ditolak,
        total_nilai: totalNilai,
        persentase: {
          pending:
            jumlahTransaksi > 0 ? ((pending / jumlahTransaksi) * 100).toFixed(2): 0,
          diterima:
            jumlahTransaksi > 0 ? ((diterima / jumlahTransaksi) * 100).toFixed(2): 0,
          ditolak:
            jumlahTransaksi > 0 ? ((ditolak / jumlahTransaksi) * 100).toFixed(2) : 0,
        },
      },
    };
  } catch (error: any) {
    console.error("Gagal ambil summary transaksi:", error);
    throw new HttpsError("internal", error.message);
  }
});
