class Mahasiswa {
  String role, department, name, password, profile, nim;
  int semester;
  Mahasiswa(
      {required this.role,
      required this.department,
      required this.name,
      required this.password,
      required this.profile,
      required this.nim,
      required this.semester});
}

class Dosen {
  String role, department, name, password, profile, nidn;
  Dosen({
    required this.role,
    required this.department,
    required this.name,
    required this.password,
    required this.profile,
    required this.nidn,
  });
}

class Admin {
  String role, name, password, profile, adminId;
  Admin({
    required this.role,
    required this.name,
    required this.password,
    required this.profile,
    required this.adminId,
  });
}
