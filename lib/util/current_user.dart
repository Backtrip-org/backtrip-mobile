class CurrentUser {
  int id;

  static final CurrentUser _userInstance = CurrentUser._internal();

  CurrentUser._internal();

  factory CurrentUser(int id) {
    _userInstance.id = id;
    return _userInstance;
  }
}
