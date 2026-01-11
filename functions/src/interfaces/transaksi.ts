import { DocumentReference, Timestamp } from "firebase-admin/firestore";

export interface Barang {
  id_barang: DocumentReference;
  nama_barang: string;
  harga: number;
  qty: number;
}

export interface Pesanan {
  id_pesanan: string;
  items: Barang[];
  total_harga: number;
  status_verifikasi?: boolean;
  status_proses?: string;
  tanggal_pesanan: Timestamp;
}
