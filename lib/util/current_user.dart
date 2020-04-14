class CurrentUser {
  int id;

  static final CurrentUser _user_instance = CurrentUser._internal();

  CurrentUser._internal();

  factory CurrentUser(int id) {
    _user_instance.id = id;
    return _user_instance;
  }
}
