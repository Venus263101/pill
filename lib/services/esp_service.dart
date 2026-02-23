import 'dart:io';
import 'package:http/http.dart' as http;

class ESPService {
  static const String baseUrl = "http://192.168.4.1";

  static Future<bool> uploadFace(File imageFile, String userName) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/register'),
      );

      request.fields['name'] = userName;

      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
        ),
      );

      var response = await request.send();

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Upload error: $e");
      return false;
    }
  }
}