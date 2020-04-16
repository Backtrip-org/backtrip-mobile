class Login {
  int id;
  String status;
  String message;
  String authorization;

  Login({this.id, this.status, this.message, this.authorization});

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      id: json['id'],
      status: json['status'],
      message: json['message'],
      authorization: json['Authorization'],
    );
  }
}