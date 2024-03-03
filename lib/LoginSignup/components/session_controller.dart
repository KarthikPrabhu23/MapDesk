class SessionController {
  factory SessionController() {
    return _session;
  }

  SessionController._internal();

  String? userid;
  String? username;

  static final SessionController _session = SessionController._internal();
}
