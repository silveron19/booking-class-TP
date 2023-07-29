import 'package:mongo_dart/mongo_dart.dart';

class User {
  String id, name, password, department, role;
  int semester;

  User(this.id, this.name, this.password, this.department, this.semester,
      this.role);
}

class Session {
  String day, startTime, endTime, lecturer, classroom;
  ObjectId id;
  List<dynamic> students;
  Subjects subject;

  Session(this.id, this.day, this.startTime, this.endTime, this.lecturer,
      this.students, this.subject, this.classroom);
}

class Students {
  String id, name;
  Students(this.id, this.name);
}

class Subjects {
  String id, name, classPresident;
  Subjects(this.id, this.name, this.classPresident);
}

class Request {
  ObjectId id, sessionDetail;
  String requestBy,
      newDay,
      newStartTime,
      newEndTime,
      newClassroom,
      reason,
      status;
  DateTime createdAt, updatedAt;
  Request(
      this.id,
      this.sessionDetail,
      this.requestBy,
      this.newDay,
      this.newStartTime,
      this.newEndTime,
      this.newClassroom,
      this.reason,
      this.status,
      this.createdAt,
      this.updatedAt);
}
