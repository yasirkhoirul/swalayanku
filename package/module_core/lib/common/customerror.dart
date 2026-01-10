class FirebaseAuthException implements Exception {
  final String code;
  final String message;

  FirebaseAuthException({required this.code, required this.message});

  @override
  String toString() => message;
}

class FirebaseCustomError {
  static String getErrorMessage(String errorCode) {
    switch (errorCode) {
      // Auth Errors
      case 'email-already-in-use':
        return 'Email sudah terdaftar. Silakan gunakan email lain.';
      case 'invalid-email':
        return 'Format email tidak valid.';
      case 'operation-not-allowed':
        return 'Operasi tidak diizinkan.';
      case 'weak-password':
        return 'Password terlalu lemah. Minimal 6 karakter.';
      case 'user-disabled':
        return 'Akun pengguna telah dinonaktifkan.';
      case 'user-not-found':
        return 'Pengguna tidak ditemukan.';
      case 'wrong-password':
        return 'Password salah.';
      case 'invalid-credential':
        return 'Kredensial tidak valid. Periksa email dan password Anda.';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan login. Silakan coba lagi nanti.';
      case 'network-request-failed':
        return 'Gagal terhubung ke jaringan. Periksa koneksi internet Anda.';
      case 'requires-recent-login':
        return 'Operasi ini memerlukan autentikasi ulang.';
      case 'account-exists-with-different-credential':
        return 'Akun sudah ada dengan kredensial berbeda.';
      case 'invalid-verification-code':
        return 'Kode verifikasi tidak valid.';
      case 'invalid-verification-id':
        return 'ID verifikasi tidak valid.';

      // Firestore Errors
      case 'permission-denied':
        return 'Anda tidak memiliki izin untuk mengakses data ini.';
      case 'not-found':
        return 'Data tidak ditemukan.';
      case 'already-exists':
        return 'Data sudah ada.';
      case 'resource-exhausted':
        return 'Kuota terlampaui. Coba lagi nanti.';
      case 'failed-precondition':
        return 'Operasi ditolak karena kondisi tidak terpenuhi.';
      case 'aborted':
        return 'Operasi dibatalkan karena konflik.';
      case 'out-of-range':
        return 'Operasi diluar jangkauan yang valid.';
      case 'unimplemented':
        return 'Operasi tidak diimplementasikan.';
      case 'internal':
        return 'Terjadi kesalahan internal server.';
      case 'unavailable':
        return 'Layanan tidak tersedia. Coba lagi nanti.';
      case 'data-loss':
        return 'Data hilang atau rusak.';
      case 'unauthenticated':
        return 'Anda harus login terlebih dahulu.';

      // Storage Errors
      case 'storage/unauthorized':
        return 'Anda tidak memiliki izin untuk mengakses file ini.';
      case 'storage/canceled':
        return 'Upload dibatalkan.';
      case 'storage/unknown':
        return 'Terjadi kesalahan tidak dikenal saat upload.';
      case 'storage/object-not-found':
        return 'File tidak ditemukan.';
      case 'storage/bucket-not-found':
        return 'Bucket storage tidak ditemukan.';
      case 'storage/project-not-found':
        return 'Proyek tidak ditemukan.';
      case 'storage/quota-exceeded':
        return 'Kuota storage terlampaui.';
      case 'storage/unauthenticated':
        return 'Anda harus login untuk upload file.';
      case 'storage/retry-limit-exceeded':
        return 'Batas percobaan upload terlampaui.';
      case 'storage/invalid-checksum':
        return 'File yang diupload tidak valid.';
      case 'storage/canceled':
        return 'Upload dibatalkan oleh pengguna.';

      // Default
      default:
        return 'Terjadi kesalahan: $errorCode';
    }
  }

  static Exception handleFirebaseError(dynamic error) {
    if (error is FirebaseAuthException) {
      return FirebaseAuthException(
        code: error.code,
        message: getErrorMessage(error.code),
      );
    }
    
    // Handle other Firebase errors
    final errorCode = error.toString();
    if (errorCode.contains('firebase')) {
      final code = _extractErrorCode(errorCode);
      return FirebaseAuthException(
        code: code,
        message: getErrorMessage(code),
      );
    }

    return Exception(error.toString());
  }

  static String _extractErrorCode(String error) {
    // Extract error code from Firebase error string
    final regex = RegExp(r'\[.*?\/(.*?)\]');
    final match = regex.firstMatch(error);
    if (match != null && match.groupCount > 0) {
      return match.group(1) ?? 'unknown';
    }
    return 'unknown';
  }
}
