import 'package:hive_flutter/hive_flutter.dart';

import 'config.dart';

class DB {
  static Future<void> initialize() async {
    await Hive.initFlutter();
    await Hive.openBox(Config.dbName);
  }

  static Box getDB() {
    return Hive.box(Config.dbName);
  }

  static dynamic getValue(keyName,
      {String db = Config.dbName, dynamic defaultValue = ""}) {
    return Hive.box(db).get(keyName, defaultValue: defaultValue);
  }

  static Future<void> setValue(keyName, value,
      {String db = Config.dbName}) async {
    await Hive.box(db).put(keyName, value);
  }
}
