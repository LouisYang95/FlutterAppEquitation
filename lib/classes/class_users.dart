class Users {
  String name;
  String email;
  String password;
  String? league;
  String? phone;
  String? ages;
  String? ffe;
  String? photoUrl;
  List? horses;

  Users({
    required this.name,
    required this.email,
    required this.password,
    this.league,
    this.phone,
    this.ages,
    this.ffe,
    this.photoUrl,
    this.horses,
  });
}
