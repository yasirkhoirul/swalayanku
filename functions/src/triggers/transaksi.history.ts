import { HttpsError, onCall } from "firebase-functions/https";
import { History } from "../services/gethistory.service";
import * as admin from "firebase-admin";
import { Pesanan } from "../interfaces/transaksi";

admin.initializeApp();

export const apiTransaksiHistoryBulan = onCall(async (req) => {
  const input = req.data;
  const bulan = input.bulan;
  const tahun = input.tahun;

  if (!bulan || !tahun) {
    throw new HttpsError("invalid-argument", "format bulan dan tahun salah");
  }

  const startDate = new Date(tahun, bulan - 1, 1);
  const endDate = new Date(tahun, bulan, 0, 23, 59, 59, 999);

  try {
    const dataHistory = await History.getHistoryAdmin(startDate, endDate);

    const totalPengeluaran = dataHistory.reduce(
      (acc, curr) => acc + curr.totalharga,
      0
    );

    // Kelompokkan transaksi per hari
    const transaksiPerHari = dataHistory.reduce((acc: any, curr: any) => {
      const tanggal = new Date(curr.tanggal || curr.createdAt)
        .toISOString()
        .split("T")[0]; // Format: YYYY-MM-DD

      if (!acc[tanggal]) {
        acc[tanggal] = {
          tanggal: tanggal,
          transaksi: [],
          jumlah_transaksi: 0,
          total_pengeluaran: 0,
        };
      }

      acc[tanggal].transaksi.push(curr);
      acc[tanggal].jumlah_transaksi++;
      acc[tanggal].total_pengeluaran += curr.totalharga;

      return acc;
    }, {});

    // Convert ke array dan sort berdasarkan tanggal
    const listHariDenganTransaksi = Object.values(transaksiPerHari).sort(
      (a: any, b: any) =>
        new Date(a.tanggal).getTime() - new Date(b.tanggal).getTime()
    );

    return {
      success: true,
      data: dataHistory,
      list_hari: listHariDenganTransaksi,
      summary: {
        bulan: bulan,
        tahun: tahun,
        total_transaksi: dataHistory.length,
        total_pengeluaran: totalPengeluaran,
        jumlah_hari_ada_transaksi: listHariDenganTransaksi.length,
      },
    };
  } catch (error: any) {
    console.error("Gagal ambil history:", error);
    throw new HttpsError("internal", error.message);
  }
});

export const getTransaksiSummaryBulan = onCall(async () => {
  const db = admin.firestore();

  try {
    const pesananSnapshot = await db.collection("pesanan").get();

    // Kelompokkan transaksi per bulan
    const transaksiPerBulan: { [key: string]: any } = {};

    pesananSnapshot.forEach((doc) => {
      const data: Pesanan = doc.data() as Pesanan;
      const tanggalDoc = data.created_at || data.updated_at;

      if (!tanggalDoc) return;

      const date = tanggalDoc.toDate ? tanggalDoc.toDate() : new Date(tanggalDoc as any);
      const bulanTahun = `${date.getFullYear()}-${String(
        date.getMonth() + 1
      ).padStart(2, "0")}`;

      if (!transaksiPerBulan[bulanTahun]) {
        transaksiPerBulan[bulanTahun] = {
          bulan: date.getMonth() + 1,
          tahun: date.getFullYear(),
          jumlah_transaksi: 0,
          pending: 0,
          diterima: 0,
          ditolak: 0,
          total_nilai_diterima: 0,
        };
      }

      transaksiPerBulan[bulanTahun].jumlah_transaksi++;

      if (data.status_proses === "pending") {
        transaksiPerBulan[bulanTahun].pending++;
      } else if (data.status_proses === "diterima") {
        transaksiPerBulan[bulanTahun].diterima++;
        transaksiPerBulan[bulanTahun].total_nilai_diterima +=
          data.totalharga || 0;
      } else if (data.status_proses === "ditolak") {
        transaksiPerBulan[bulanTahun].ditolak++;
      }
    });

    // Convert ke array dan sort berdasarkan tahun dan bulan
    const listBulan = Object.values(transaksiPerBulan).sort(
      (a: any, b: any) => {
        if (a.tahun !== b.tahun) return a.tahun - b.tahun;
        return a.bulan - b.bulan;
      }
    );

    return {
      success: true,
      data: listBulan,
      summary: {
        total_bulan: listBulan.length,
        total_transaksi_keseluruhan: listBulan.reduce(
          (acc: number, curr: any) => acc + curr.jumlah_transaksi,
          0
        ),
        total_nilai_keseluruhan: listBulan.reduce(
          (acc: number, curr: any) => acc + curr.total_nilai_diterima,
          0
        ),
      },
    };
  } catch (error: any) {
    console.error("Gagal ambil summary transaksi per bulan:", error);
    throw new HttpsError("internal", error.message);
  }
});
