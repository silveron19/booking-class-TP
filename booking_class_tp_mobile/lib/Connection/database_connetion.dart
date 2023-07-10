import 'package:mongo_dart/mongo_dart.dart';

String url =
    'mongodb+srv://K4ND4:K4ND4@cluster0.ll3ytwj.mongodb.net/Tembus_Pagi?retryWrites=true&w=majority';

Future<DbCollection> getConnection(String namaCollection) async {
  var db = await Db.create(url);

  await db.open();

  var coll = db.collection(namaCollection);

  return coll;
}

Future<List> loginAuthentication(String username, password) async {
  DbCollection collection = await getConnection('USER');

  List errors = [];

  collection.find().forEach((element) {
    if (element['name'] == username) {
      if (element['password'] == password) {
        return;
      } else {
        errors.add('password anda salah');
        return;
      }
    }
    errors.add('Username tidak ditemukan');
  });

  collection.db.close();
  return errors;
}

void main(List<String> args) async {
  DbCollection newMain = await getConnection('USER');
  print(newMain.find().forEach((element) {
    print(element['role']);
  }));
}
