class LoginSession {
  final String empId;
  final String name;
  final String designation;
  final bool isStaff;

  LoginSession(
      {required this.empId,
      required this.name,
      required this.designation,
      required this.isStaff});
}
