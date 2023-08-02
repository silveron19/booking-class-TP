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

Future<List> getStudentOfASession(List<dynamic> studentList) async {
  DbCollection students = await getConnection('USERS');
  List userList = [];
  students.find(where.fields(['_id', 'name'])).forEach((element) {
    if (studentList.contains(element['_id'])) {
      userList.add(element);
    }
  });
  return userList;
}

Future<List<Session>> getSessions(User userInfo) async {
  DbCollection session = await getConnection('SESSION');
  List temportal = [];
  List<Session> sessions = [];

  if (userInfo.role != 'admin') {
    await session.find().forEach((element) {
      if ((element['student'] as List).contains(userInfo.id)) {
        temportal.add(element);
      }
    });
  } else {
    await session.find().forEach((element) {
      print(element['department']);
      print(userInfo.department);
      print(element['department'] == userInfo.department);
      if (element['department'] == userInfo.department) {
        temportal.add(element);
      }
    });
  }

  if (temportal.isNotEmpty) {
    temportal.sort((a, b) =>
        converting(a['start_time']).compareTo(converting(b['start_time'])));

    for (var element in temportal) {
      var retrievedSubject = await getSubject(element['subject']);
      var studentList = await getStudentOfASession(element['student']);
      sessions.add(Session(
          element['_id'],
          element["day"],
          element['start_time'],
          element['end_time'],
          element['lecturer'],
          studentList,
          retrievedSubject,
          element['classroom']));
    }
  }

  return sessions;
}

Future<List<Session>> getTodaySession(User userInfo) async {
  List<Session> listOfUserSession = await getSessions(userInfo);
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

Future updateClassChief(String subjectId, String studentId) async {
  DbCollection subjects = await getConnection('SUBJECTS');
  subjects.updateOne(
      where.eq('_id', subjectId), modify.set('class_president', studentId));
  subjects.db.close();
  return;
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

Future<Session> getSessionForRequest(ObjectId sessionId) async {
  DbCollection sessionCollection = await getConnection('SESSION');
  print(sessionId);
  var session = await sessionCollection.findOne(where.eq('_id', sessionId));
  Subjects thisSubject = await getSubject(session!['subject']);
  return Session(
      session['_id'],
      session['day'],
      session['start_time'],
      session['end_time'],
      session['lecturer'],
      session['student'],
      thisSubject,
      session['classroom']);
}

Future<List<Request>> getRequest(User theUser) async {
  DbCollection request = await getConnection('REQUEST');
  List userRequests = [];
  List<Request> requestObjects = [];
  await request.find(where.eq('request_by', theUser.id)).forEach((element) {
    userRequests.add(element);
  });

  for (var element in userRequests) {
    Session thisRequestSession =
        await getSessionForRequest(element['session_detail']);
    User thisRequestUser = await getUser(element['request_by']);
    requestObjects.add(Request(
        element['_id'],
        thisRequestSession,
        thisRequestUser,
        element['new_day'],
        element['new_start_time'],
        element['new_end_time'],
        element['new_classroom'],
        element['reason'],
        element['status'],
        element['created_at'],
        element['updated_at']));
  }

  request.db.close();
  return requestObjects;
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

Future getClassroom(User userInfo) async {
  DbCollection session = await getConnection("SESSION");
  DbCollection classroom = await getConnection('CLASSROOM');
  List thisUserSession = await getSessions(userInfo);
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
    if (element.subject.classPresident == userInfo.id &&
        element.students.contains(userInfo)) {
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

Future<User> getUser(String userId) async {
  DbCollection users = await getConnection('USERS');
  User retrievedUser;
  var result = await users.findOne(where.eq('_id', userId));

  retrievedUser = User(result!['_id'], result['name'], result['password'],
      result['department'], result['semester'], result['role']);
  users.db.close();
  return retrievedUser;
}

Future deleteRequest(ObjectId theId) async {
  DbCollection request = await getConnection('REQUEST');

  request.deleteOne(where.eq('_id', theId));

  request.db.close();
}

void main(List<String> args) async {
  // getUser('D121211007');
  // getRequest();
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
