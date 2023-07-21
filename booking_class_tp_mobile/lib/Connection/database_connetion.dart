import 'package:booking_class_tp_mobile/Entities/entities.dart';
import 'package:mongo_dart/mongo_dart.dart';

String url =
    'mongodb+srv://K4ND4:K4ND4@cluster0.ll3ytwj.mongodb.net/MRuangan2?retryWrites=true&w=majority';

Future<DbCollection> getConnection(String namaCollection) async {
  var db = await Db.create(url);
  await db.open();
  var coll = db.collection(namaCollection);
  return coll;
}

Future loginAuthentication(String id) async {
  DbCollection collection = await getConnection('USERS');
  var data = await collection.findOne(where.eq('_id', id));
  collection.db.close();
  return data;
}

Future getTodayClass(String id, String hari) async {
  DbCollection collection = await getConnection('Tes Session');
  List todaySubjects = [];

  await collection.find(where.eq("day", hari)).forEach((element) {
    if ((element["student"] as List).contains(id)) {
      todaySubjects.add(element);
    }
  });

  collection.db.close();
  return todaySubjects;
}

Future<List<Session>> getSession(String id) async {
  List subjects = [];
  List<Session> subjectsObject = [];
  List<String> dayOfTheWeek = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jum\'at',
    'Sabtu',
    'Minggu'
  ];
  var hari = DateTime.now();
  DbCollection userSession = await getConnection('SESSION');
  await userSession
      .find(where.eq('day', dayOfTheWeek[hari.weekday - 1]))
      .forEach((element) {
    var documentIds = element['student'];
    if (documentIds.contains(id)) {
      subjects.add(element);
    }
  });

  if (subjects.isNotEmpty) {
    subjects.sort((a, b) =>
        converting(a['start_time']).compareTo(converting(b['start_time'])));

    for (var element in subjects) {
      var retrievedSubject = await getSubject(element['subject']);
      subjectsObject.add(Session(
          element['_id'],
          element["day"],
          element['start_time'],
          element['end_time'],
          element['lecturer'],
          element['student'],
          retrievedSubject,
          element['classroom']));
    }
  }
  userSession.db.close();
  return subjectsObject;
}

// Future insertDocument() async {
//   DbCollection collection = await getConnection('USERS');
//   collection.insertOne({'nama': 'test'});
//   collection.db.close();
// }

Future getStudents(List<String> studentsId) async {
  DbCollection collection = await getConnection('USERS');
  List<Students> studentData = [];

  // var response = await collection.findOne(where.eq('_id', 'D121211029'));
  // studentData.add(Students(response?['_id'], response?['name']));

  for (String id in studentsId) {
    await collection.findOne(where.eq('_id', id)).then(
        (value) => studentData.add(Students(value?['_id'], value?['name'])));
    // studentData.add(Students(response?['_id'], response?['name']));
  }

  collection.db.close();

  return studentData;
}

Future<Subjects> getSubject(String subjectId) async {
  DbCollection collection = await getConnection('SUBJECTS');
  var responce = await collection
      .findOne(where.eq('_id', subjectId))
      .then((value) => Subjects(value?['_id'], value?['name']));

  collection.db.close();

  return responce;
}

int converting(String time) {
  List myTime = time.split(":");
  return int.parse(myTime[0]) * 60 + int.parse(myTime[1]);
}

void main(List<String> args) async {
  var hari = DateTime.now();
  // switch (hari.weekday) {
  //   case 1:
  //     print('Print');
  //   case 2:
  //     print('Selasa');
  //   case 3:
  //     print('Rabu');
  //   case 4:
  //     print('kamis');
  //   case 5:
  //     print('Jumat');
  //   case 6:
  //     print('Sabtu');
  //   case 7:
  //     print('Minggu');
  // }
  // var newCommand = await getSession();
  // newCommand.forEach((element) {
  //   print(element.id);
  // });
  // await getStudents(['D121211020', 'D121211030']);

  // Subjects subjek = await getSubject('121211001');
  // print(subjek.name);
}
