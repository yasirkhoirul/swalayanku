import * as admin from "firebase-admin";

export class History {
  static async getHistoryAdmin(startTime: Date, endDate: Date) {
    const db = admin.firestore();
    const snapshot = await db
      .collection("pesanan")
      .where("created_at", ">=", startTime)
      .where("created_at", "<=", endDate)
      .orderBy("created_at", "desc") // Urutkan dari yang terbaru
      .get();
    const historyData = snapshot.docs.map((doc) => {
      const data = doc.data();
      return {
        id_pesanan: doc.id,
        totalharga: data.totalharga,
        status_proses: data.status_proses,
        tanggal: data.created_at.toDate().toISOString(),
        items_count: data.items.length, // Info ringkas (misal: "3 Barang")
      };
    });
    return historyData;
  }
}
