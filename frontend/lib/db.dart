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
      {String db = Config.dbName, dynamic defaultValue = 0}) {
    return Hive.box(db).get(keyName, defaultValue: defaultValue);
  }
}
