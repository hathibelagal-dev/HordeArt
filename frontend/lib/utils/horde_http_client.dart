import 'dart:convert' show json, jsonDecode, utf8;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

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
        logger.e("Unable to decode result of getJSON");
        return {};
      }
    }
    return {};
  }

  static Future<bool> saveWebP(String url, String id) async {
    Uri uri = Uri.parse(url);
    http.Response response = await http.get(uri);
    try {
      File f =
          File("${(await getApplicationDocumentsDirectory()).path}/$id.webp");
      await f.writeAsBytes(response.bodyBytes);
      return true;
    } catch (e) {
      logger.e(e);
      return false;
    }
  }

  static Future<dynamic> postJSON(String url, Map<String, dynamic> body) async {
    Uri uri = Uri.parse(url);
    Map<String, String> headers = {
      "Client-Agent": Config.clientAgent,
      "apikey": Config.defaultAPIKey,
      "Content-type": "application/json",
      "Accept": "application/json"
    };
    http.Response response =
        await http.post(uri, headers: headers, body: json.encode(body));
    try {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } catch (e) {
      logger.e("Unable to decode generate image response");
    }
  }
}
