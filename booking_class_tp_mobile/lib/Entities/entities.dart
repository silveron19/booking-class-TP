import 'package:mongo_dart/mongo_dart.dart';

class User {
  String id, name, password, department, role;
  int semester;

  User(this.id, this.name, this.password, this.department, this.semester,
      this.role);
}

class Session {
  String day, startTime, endTime, lecturer;
  ObjectId id;
  Map<String, dynamic> students, subject, classroom;

  Session(this.id, this.day, this.startTime, this.endTime, this.lecturer,
      this.students, this.subject, this.classroom);
}

class Students {
  String ref;
  Map<String, dynamic> studentId;

  Students(this.ref, this.studentId);
}

class SessionSubject {
  String ref, id;
  SessionSubject(this.id, this.ref);
}

class SessionClassroom {
  String ref, id;
  SessionClassroom(this.id, this.ref);
}
