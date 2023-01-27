import 'package:frontend/config.dart';
import 'package:frontend/db.dart';
import 'package:frontend/models/image_result.dart';
import 'package:frontend/models/job_status.dart';
import 'package:logger/logger.dart';

import './horde_http_client.dart';
import '../models/active_model.dart';

class JSONResponseHandler {
  static Logger logger = Logger();

  Future<List<ActiveModel>> getActiveModels() async {
    List<ActiveModel> output = [];
    dynamic data = await HordeHTTPClient.getJSON(Config.modelDetails);
    if (data is List) {
      for (Map<String, dynamic> item in data) {
        output.add(ActiveModel(
            name: item["name"],
            queued: item["queued"],
            eta: item["eta"],
            count: item["count"]));
      }
    }
    return output;
  }

  Future<JobStatus> getJobStatus(String job) async {
    dynamic data =
        await HordeHTTPClient.getJSON("${Config.asyncStatusCheck}/$job");
    if (data is Map) {
      if(data.containsKey("done")) {
        return JobStatus(data["done"], true);
      } else {
        return JobStatus(true, false);
      }
    }
    return JobStatus(false, false);
  }

  Future<bool> generateImage(String prompt, String negativePrompts,
      String sampler, String seed, String postProcessor, String model) async {
    negativePrompts = negativePrompts
        .split(",")
        .map((n) {
          return "$n:-1";
        })
        .toList()
        .join(", ");
    prompt = "$prompt, $negativePrompts";
    Map<String, dynamic> payload = {
      "prompt": prompt,
      "params": {
        "sampler_name": sampler,
        "denoising_strength": 0.75,
        "seed": seed,
        "post_processing": [postProcessor],
      },
      "models": [model]
    };
    dynamic data =
        await HordeHTTPClient.postJSON(Config.asyncGenerateImage, payload);
    if (data is Map && data.containsKey("id")) {
      String pending = DB.getValue("pending", defaultValue: "");
      pending = "$pending,${data['id']}";
      await DB.setValue("pending", pending);
      logger.i("Started job: $data['id']");
      return true;
    }
    logger.e("Couldn't start job");
    return false;
  }

  Future<void> downloadImage(String job) async {
    dynamic data = await HordeHTTPClient.getJSON(Config.fullImageStatus);
    if (data is Map && data["generations"].length > 0) {
      Map<String, dynamic> item = data["generations"][0];
      ImageResult result = ImageResult(item["img"], item["id"]);
      bool success = await HordeHTTPClient.saveWebP(result.url, result.id);
      if (success) {
        logger.i("Image saved successfully");
      } else {
        logger.e("Could not save image");
      }
    }
  }
}
