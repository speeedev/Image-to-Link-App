import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class NetworkService {
  static const String _baseUrl = "https://api.imgur.com/3/image";
  static const String _clientId = "4d6f5c1baafa058";

  Future<Map<String, dynamic>?> uploadImage(File file) async {
    try {
      var request = http.MultipartRequest("POST", Uri.parse(_baseUrl));
      request.fields["title"] = "Dummy";
      request.headers["Authorization"] = "CLIENT-ID $_clientId";
      var picture = await http.MultipartFile.fromPath("image", file.path);
      request.files.add(picture);
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.toBytes();
        var responseDataString = String.fromCharCodes(responseData);
        return json.decode(responseDataString);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
