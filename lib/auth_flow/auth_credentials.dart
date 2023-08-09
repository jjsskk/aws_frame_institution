// 1
abstract class AuthCredentials {
  final String username;
  final String password;

  AuthCredentials({required this.username, required this.password});
}

// 2
class LoginCredentials extends AuthCredentials {
  LoginCredentials({required String username, required String password})
      : super(username: username, password: password);
}

// 3
class SignUpCredentials extends AuthCredentials {
  final String phonenumber;
  final String name;
  final String institutionnumber;

  SignUpCredentials(
      {required String username, //email(id)
      required String password,
      required this.name,
      required this.phonenumber,
      required this.institutionnumber})
      : super(username: username, password: password);
}
