import 'dart:io';

class ESPService {
  //  DEVELOPMENT MODE (NO HARDWARE)
  static const bool useMockMode = true;

  static Future<bool> uploadFace(File imageFile, String userName) async {
    if (useMockMode) {
      // Simulate 2-second delay like real upload
      await Future.delayed(const Duration(seconds: 2));
      return true; // Always succeed in mock mode
    }

    // Real hardware code
    // For now, just safely return false
    return false;
  }
}