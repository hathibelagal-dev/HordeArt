import 'dart:convert' show jsonDecode, utf8;
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../config.dart';

class HordeHTTPClient {
  static Logger logger = Logger();

  static Future<dynamic> getJSON(String url) async {
    Uri uri = Uri.parse(url);
    Map<String, String> headers = {"Client-Agent": Config.clientAgent};
    http.Response response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      try {
        return jsonDecode(utf8.decode(response.bodyBytes));
      } catch (e) {
        logger.e("Unable to decode message");
        return {};
      }
    }
    return {};
  }
}
