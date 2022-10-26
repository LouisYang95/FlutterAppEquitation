import 'Constant.dart';
import 'dart:developer';
import 'package:mongo_dart/mongo_dart.dart';

// Create a class to connect to the database
class MongoDataBase {
  static connect() async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    inspect(db);
    var status = db.serverStatus();

    inspect(status);

    // Return db to exploit it in the main.dart file (and then in our routes)
    return db;
  }
}
