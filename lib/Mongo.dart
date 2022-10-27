import 'Constant.dart';
import 'dart:developer';
import 'package:mongo_dart/mongo_dart.dart';

class MongoDataBase {
  static connect() async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    inspect(db);
    var status = db.serverStatus();

    // print(status);
    // var collection = db.collection(COLLECTION_USERS);
    // print(await collection.find().toList());
    //
    // await collection.insertMany([
    //   {
    //     "username": 'test 1',
    //     "password": 'test1',
    //     "email": 'test1@gmail.com',
    //   },
    //   {
    //     "username": 'test 2',
    //     "password": 'test2',
    //     "email": 'test2@gmail.com',
    //   },
    //   {
    //     "username": 'test 3',
    //     "password": 'test3',
    //     "email": 'test3@gmail.com',
    //   }
    // ]);

    return db;
  }
}
