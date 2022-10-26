class Users {
  String name;
  String email;
  String password;
  String? photoUrl;

  Users({
    required this.name,
    required this.email,
    required this.password,
    this.photoUrl,
  });
}
