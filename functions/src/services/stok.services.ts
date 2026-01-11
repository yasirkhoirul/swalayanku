import * as admin from "firebase-admin";
import { Barang } from "../interfaces/transaksi";
import { DocumentReference, FieldValue } from "firebase-admin/firestore";

export class StokService {
  static async kurangiStockBatch(items: Barang[]) {
    const db = admin.firestore();
    const docsToUpdate: {
      ref: DocumentReference;
      sisaStok: number;
    }[] = [];
    return db.runTransaction(async (transaction) => {
      for (const item of items) {
        let barangRef;

        if (typeof item.id_barang == "string") {
          barangRef = db.doc(item.id_barang);
        } else {
          barangRef = item.id_barang;
        }
        const doc = await transaction.get(barangRef);

        if (!doc.exists) {
          throw new Error(`Barang tidak ditemukan ${item.id_barang}`);
        }

        const stokSekarang = doc.data()?.stok || 0;
        if (stokSekarang < item.qty) {
          throw new Error("Stok tidak mencukupi");
        }

        docsToUpdate.push({
          ref: barangRef,
          sisaStok: stokSekarang - item.qty,
        });
      }

      for (const item of docsToUpdate) {
        transaction.update(item.ref, {
          stok: item.sisaStok,
          updatedAt: FieldValue.serverTimestamp(),
        });
      }
    });
  }

  static async kembalikanStok(
    items: Barang[],
    transaksi: admin.firestore.Transaction
  ) {
    const db = admin.firestore();
    for (const item of items) {
      let itemRef: DocumentReference;
      if (typeof item.id_barang == "string") {
        itemRef = db.doc(item.id_barang);
      } else {
        itemRef = item.id_barang;
      }
      transaksi.update(itemRef, {
        stok: FieldValue.increment(item.qty),
      });
    }
  }
}
