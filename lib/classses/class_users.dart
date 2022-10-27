class Users {
  String name;
  String email;
  String password;
  String? phone;
  String? ages;
  String? ffe;
  String? photoUrl;

  Users({
    required this.name,
    required this.email,
    required this.password,
    this.phone,
    this.ages,
    this.ffe,
    this.photoUrl,
  });
}
