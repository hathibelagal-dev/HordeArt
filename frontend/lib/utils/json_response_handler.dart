import 'package:frontend/config.dart';

import './horde_http_client.dart';

class ActiveModel {
  String? name;
  int? queued;
  int? eta;
  int? count;
  ActiveModel({this.name, this.queued, this.eta, this.count});

  @override
  String toString() {
    return "$name ($count)";
  }
}

class JSONResponseHandler {
  Future<List<ActiveModel>> getActiveModels() async {
    List<ActiveModel> output = [];
    dynamic data =
        await HordeHTTPClient.getJSON(Config.modelDetails);
    if(data is List) {
      for(Map<String, dynamic> item in data) {
        output.add(ActiveModel(
          name: item["name"],
          queued: item["queued"],
          eta: item["eta"],
          count: item["count"]
        ));
      }
    }
    return output;
  }
}
