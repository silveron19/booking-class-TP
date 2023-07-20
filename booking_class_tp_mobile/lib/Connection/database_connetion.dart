import 'package:booking_class_tp_mobile/Entities/entities.dart';
import 'package:intl/intl.dart';
import 'package:mongo_dart/mongo_dart.dart';

String url =
    'mongodb+srv://K4ND4:K4ND4@cluster0.ll3ytwj.mongodb.net/MRuangan2?retryWrites=true&w=majority';

Future<DbCollection> getConnection(String namaCollection) async {
  var db = await Db.create(url);
  await db.open();
  var coll = db.collection(namaCollection);
  return coll;
}

Future getTodayClass(String id, String hari) async {
  DbCollection collection = await getConnection('Tes Session');
  List todaySubjects = [];

  await collection.find(where.eq("day", hari)).forEach((element) {
    if ((element["student"]["\$id"] as List).contains(id)) {
      print(element);
    }
  });

  collection.db.close();
}

Future loginAuthentication(String id) async {
  DbCollection collection = await getConnection('Tes User');
  var data = await collection.findOne(where.eq('_id', id));
  collection.db.close();
  return data;
}

Future insertDocument() async {
  DbCollection collection = await getConnection('USERS');
  collection.insertOne({'nama': 'test'});
  collection.db.close();
}

Future<List<Session>> getSession() async {
  String id = 'D121211030';
  List subjects = [];
  List<Session> subjectsObject = [];
  DbCollection userSession = await getConnection('Tes Session');
  await userSession.find().forEach((element) {
    var documentIds = element['student']['\$id'];
    if (documentIds.contains(id)) {
      subjects.add(element);
    }
  });

  subjects.sort((a, b) =>
      converting(a['start time']).compareTo(converting(b['start time'])));
  subjects.forEach((element) {
    subjectsObject.add(Session(
        element['_id'],
        element["day"],
        element['start time'],
        element['end time'],
        element['lecturer'],
        element['student'],
        element['subject'],
        element['classroom']));
  });
  userSession.db.close();
  return subjectsObject;
}

int converting(String time) {
  List myTime = time.split(":");
  return int.parse(myTime[0]) * 60 + int.parse(myTime[1]);
}

void main(List<String> args) async {
  await getSession();
}
