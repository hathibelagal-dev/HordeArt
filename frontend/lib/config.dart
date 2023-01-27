class Config {
  static const String clientAgent = "HordeArt/1.0";
  static const String dbName = "local-storage";

  static const String baseURL = "https://stablehorde.net/api/v2";
  static const String modelDetails = "$baseURL/status/models";
  static const String asyncGenerateImage = "$baseURL/generate/async";
  static const String asyncStatusCheck = "$baseURL/generate/check";
  static const String fullImageStatus = "$baseURL/generate/status";

  static const String defaultModel = "stable_diffusion";
  static const String defaultSampler = "k_lms";
  static const List<String> availableSamplers = [
    "k_lms",
    "k_heun",
    "k_euler",
    "k_euler_a"
  ];

  static const String defaultPostProcessor = "None";
  static const List<String> availablePostProcessors = [
    "None",
    "GFPGAN",
    "RealESRGAN_x4plus",
    "CodeFormers"
  ];

  static const String defaultAPIKey = "0000000000";
}
