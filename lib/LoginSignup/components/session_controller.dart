class SessionController {
  static final SessionController _session = SessionController._internal();

  String? userid;
  String? username;

  factory SessionController() {
    return _session;
  }

  SessionController._internal();
}
