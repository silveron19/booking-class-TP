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

Future<List<Session>> getSessions(String id) async {
  DbCollection session = await getConnection('SESSION');
  List temportal = [];
  List<Session> sessions = [];

  await session.find().forEach((element) {
    if ((element['student'] as List).contains(id)) {
      temportal.add(element);
    }
  });

  if (temportal.isNotEmpty) {
    temportal.sort((a, b) =>
        converting(a['start_time']).compareTo(converting(b['start_time'])));

    for (var element in temportal) {
      var retrievedSubject = await getSubject(element['subject']);
      sessions.add(Session(
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

  return sessions;
}

Future<List<Session>> getTodaySession(String userId) async {
  List<Session> listOfUserSession = await getSessions(userId);
  List<Session> todaySessions = [];
  List<String> dayOfTheWeek = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jum\'at',
    'Sabtu',
    'Minggu'
  ];
  var hari = DateTime.now().weekday;

  if (listOfUserSession.isNotEmpty) {
    for (Session session in listOfUserSession) {
      if (session.day == dayOfTheWeek[hari - 1]) {
        todaySessions.add(session);
      }
    }
  }

  return todaySessions;
}

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

Future<void> updateSession(
    String day, String startTime, String endTime, String classroom) async {
  DbCollection sessions = await getConnection('SESSION');

  var update = {
    r'$set': {
      'day': day,
      'start_time': startTime,
      'end_time': endTime,
      'classroom': classroom
    }
  };

  sessions.updateOne(
      where.id(ObjectId.fromHexString("64bd151c0a5b43e741ba7a4d")), update);

  sessions.db.close();
}

Future<Subjects> getSubject(String subjectId) async {
  DbCollection collection = await getConnection('SUBJECTS');
  var responce = await collection.findOne(where.eq('_id', subjectId)).then(
      (value) => Subjects(
          value?['_id'], value?['name'], value?['class_president'] ?? 'Empty'));

  collection.db.close();

  return responce;
}

int converting(String time) {
  List myTime = time.split(":");
  return int.parse(myTime[0]) * 60 + int.parse(myTime[1]);
}

Future<List> checkIfCanBook(
    String? day, String? time, String? classroom) async {
  DbCollection session = await getConnection('SESSION');
  List<String> startAndEnd = time!.split(" - ");
  List docs = [];

  await session
      .findOne(where
          .eq("day", day)
          .and(where.eq('start_time', startAndEnd[0]))
          .and(where.eq('end_time', startAndEnd[1]))
          .and(where.eq('classroom', classroom)))
      .then((value) {
    if (value != null) {
      docs.add(value);
    }
  });

  // session.find().forEach((element) async {
  //   var retrievedSubject = await getSubject(element['subject']);
  //   docs.add(Session(
  //       element['_id'],
  //       element["day"],
  //       element['start_time'],
  //       element['end_time'],
  //       element['lecturer'],
  //       element['student'],
  //       retrievedSubject,
  //       element['classroom']));
  // });

  // session.db.close();

  // return docs;
  //----------------------------------------Getting id
  // var document = await session
  //     .findOne({'_id': ObjectId.fromHexString(requestedSession.id.$oid)});
  // print(document);
  // if (document == null) {
  //   print('Can update');
  // } else {
  //   print(document);
  // }
  //-------------------------------------------------------
  session.db.close();
  return docs;
}

Future getRequest() async {
  DbCollection request = await getConnection('REQUEST');
  List userRequests = [];
  List<Request> requestObjects = [];
  await request.find().forEach((element) {
    userRequests.add(element);
  });

  for (var elemetn in userRequests) {
    print(elemetn);
  }

  for (var element in userRequests) {
    requestObjects.add(Request(
        element['_id'],
        element['session_detail'],
        element['request_by'],
        element['new_day'],
        element['new_start_time'],
        element['new_end_time'],
        element['new_classroom'],
        element['reason'],
        element['status'],
        element['created_at'],
        element['updated_at']));
  }

  print(requestObjects);
  // return userRequests;

  request.db.close();
}

Future addRequest(String userId, String sessionId, String day,
    String newDuration, String newClassroom, String reason) async {
  DbCollection requests = await getConnection('REQUEST');
  List startAndEndTime = newDuration.split(' - ');
  requests.insertOne({
    '_id': ObjectId(),
    'request_by': userId,
    'new_day': day,
    'new_start_time': startAndEndTime[0],
    'new_end_time': startAndEndTime[1],
    'new_classroom': newClassroom,
    'session_detail': ObjectId.parse(sessionId),
    'reason': reason,
    'status': 'Menunggu verifikasi',
    'created_at': DateTime.now(),
    'updated_at': DateTime.now()
  });

  requests.db.close();
  return;
}

Future getClassroom(String userId) async {
  DbCollection session = await getConnection("SESSION");
  DbCollection classroom = await getConnection('CLASSROOM');
  List thisUserSession = await getSessions(userId);
  List availableClassAndDuration = [];
  List availableSession = [];
  List<Session> sessionWhereThisUserIsInCharge = [];

  await session
      .find(where.fields(['_id', 'day', 'classroom', 'start_time', 'end_time']))
      .forEach((element) {
    availableSession.add(element);
  });

  await classroom
      .find(where.fields(['_id', 'floor', 'capacity']))
      .forEach((element) {
    availableClassAndDuration.add(element);
  });

  for (Session element in thisUserSession) {
    if (element.subject.classPresident == userId &&
        element.students.contains(userId)) {
      sessionWhereThisUserIsInCharge.add(element);
    }
  }

  classroom.db.close();
  session.db.close();

  return [
    availableClassAndDuration,
    availableSession,
    sessionWhereThisUserIsInCharge
  ];
}

void main(List<String> args) async {
  getRequest();
  // String time = "13:00 - 15:30";
  // print(time.split(" - "));

  // DbCollection mySession = await getConnection('SESSION');
  // var lists = [];
  // List<Session> thissubject = [];

  // await mySession.find().forEach((element) async {
  //   lists.add(element);
  //   // Subjects thisSubject = await getSubject(element['subject']);
  //   // lists.add(Session(
  //   //     element['_id'],
  //   //     element["day"],
  //   //     element['start_time'],
  //   //     element['end_time'],
  //   //     element['lecturer'],
  //   //     element['student'],
  //   //     thisSubject,
  //   //     element['classroom']));
  // });

  // for (var element in lists) {
  //   var retrievedSubject = await getSubject(element['subject']);
  //   thissubject.add(Session(
  //       element['_id'],
  //       element["day"],
  //       element['start_time'],
  //       element['end_time'],
  //       element['lecturer'],
  //       element['student'],
  //       retrievedSubject,
  //       element['classroom']));
  // }

  // var doc = await checkIfCanBook(thissubject[0]);

  // for (Session element in thissubject) {
  //   var objectID = element.id.$oid;
  //   print(objectID);
  // }
  // updateSession('day', 'startTime', 'endTime', 'classroom');
  // print(DateTime.now());
  // var ada = ['', '', ''];
  // print(ada.length);
  // var hari = DateTime.now();
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
