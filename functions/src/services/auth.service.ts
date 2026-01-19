import * as admin from "firebase-admin";
import { HttpsError } from "firebase-functions/https";

export class AuthService {
  /**
   * Dapatkan role user dari Firestore
   */
  static async getUserRole(uid: string): Promise<string> {
    const userDoc = await admin
      .firestore()
      .collection("users")
      .doc(uid)
      .get();

    if (!userDoc.exists) {
      throw new HttpsError("not-found", "User tidak ditemukan");
    }

    return userDoc.data()?.role || "user";
  }

  /**
   * Validasi apakah user memiliki role yang diperbolehkan
   */
  static async checkRole(
    uid: string,
    allowedRoles: string[]
  ): Promise<void> {
    const role = await this.getUserRole(uid);

    if (!allowedRoles.includes(role)) {
      throw new HttpsError(
        "permission-denied",
        `Akses ditolak. Memerlukan role: ${allowedRoles.join(" atau ")}`
      );
    }
  }

  /**
   * Validasi authentication dari request
   */
  static validateAuth(auth: any): string {
    if (!auth || !auth.uid) {
      throw new HttpsError(
        "unauthenticated",
        "Anda harus login terlebih dahulu"
      );
    }
    return auth.uid;
  }
}

