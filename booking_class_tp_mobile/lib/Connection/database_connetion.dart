import 'package:booking_class_tp_mobile/Entities/entities.dart';
import 'package:mongo_dart/mongo_dart.dart';

List globalSession = [];
List globalUser = [];
List globalRequest = [];
List globalSubject = [];
List globalClassroom = [];

String url =
    'mongodb+srv://K4ND4:K4ND4@cluster0.ll3ytwj.mongodb.net/MRuangan2?retryWrites=true&w=majority';

Future<DbCollection> getConnection(String namaCollection) async {
  var db = await Db.create(url);
  await db.open();
  var coll = db.collection(namaCollection);
  return coll;
}

Future getSessionFromDatabase() async {
  DbCollection session = await getConnection('SESSION');
  globalSession = [];

  await session.find().forEach((element) {
    globalSession.add(element);
  });

  session.db.close();
}

Future getRequestFromDatabase() async {
  DbCollection request = await getConnection('REQUEST');

  globalRequest = [];

  await request.find().forEach((element) {
    globalRequest.add(element);
  });
  request.db.close();
}

Future getUserFromDatabase() async {
  DbCollection user = await getConnection('USERS');

  globalUser = [];

  await user.find().forEach((element) {
    globalUser.add(element);
  });

  user.db.close();
}

Future getClassroomFromDatabase() async {
  DbCollection classroom = await getConnection('CLASSROOM');

  globalClassroom = [];

  await classroom.find().forEach((element) {
    globalClassroom.add(element);
  });

  classroom.db.close();
}

Future getSubjectsFromDatabase() async {
  DbCollection subject = await getConnection('SUBJECTS');

  globalSubject = [];

  await subject.find().forEach((element) {
    globalSubject.add(element);
  });

  subject.db.close();
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

Subjects getSubjectFromGlobalSubjectForSession(String subjectId) {
  var found =
      globalSubject.where((element) => element['_id'] == subjectId).first;

  return Subjects(found['_id'], found['name'], found['class_president']);
}

List<Students> getStudentsFromGlobalUserForSession(List<dynamic> studentList) {
  List<Students> theList = [];
  for (var element in globalUser) {
    if (studentList.contains(element['_id'])) {
      theList.add(Students(element['_id'], element['name']));
    }
  }
  return theList;
}

Session getSessionForRequest(ObjectId sessionDetail) {
  var found =
      globalSession.where((element) => (element['_id'] == sessionDetail)).first;

  var thisSubject = getSubjectFromGlobalSubjectForSession(found['subject']);

  return Session(
      found['_id'],
      found['day'],
      found['start_time'],
      found['end_time'],
      found['lecturer'],
      found['student'],
      thisSubject,
      found['classroom'],
      found['department']);
}

User getUserForRequest(String userId) {
  var foundUser = globalUser.where((element) => element['_id'] == userId).first;

  return User(foundUser['_id'], foundUser['name'], foundUser['password'],
      foundUser['department'], foundUser['semester'], foundUser['role']);
}

/// ************************

Future<void> updateSession(Request theRequest, String statusChange) async {
  DbCollection sessions = await getConnection('SESSION');
  DbCollection request = await getConnection('REQUEST');

  if (statusChange == 'Diterima') {
    var updateRequest = {
      r'$set': {'status': 'Diterima', 'updated_at': DateTime.now()}
    };

    var updateSession = {
      r'$set': {
        'day': theRequest.newDay,
        'start_time': theRequest.newStartTime,
        'end_time': theRequest.newEndTime,
        'classroom': theRequest.newClassroom
      }
    };

    request.updateOne(where.id(theRequest.id), updateRequest);

    sessions.updateOne(where.id(theRequest.sessionDetail.id), updateSession);
  } else if (statusChange == 'Ditolak') {
    var updateRequest = {
      r'$set': {'status': 'Ditolak', 'updated_at': DateTime.now()}
    };

    request.updateOne(where.id(theRequest.id), updateRequest);
  }

  sessions.db.close();
  request.db.close();
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

  session.db.close();
  return docs;
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
    'status': 'Menunggu Verifikasi',
    'created_at': DateTime.now(),
    'updated_at': DateTime.now()
  });

  requests.db.close();
  return;
}

Future deleteRequest(ObjectId theId) async {
  DbCollection request = await getConnection('REQUEST');

  request.deleteOne(where.eq('_id', theId));

  request.db.close();
}
