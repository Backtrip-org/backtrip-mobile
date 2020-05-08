class User {
  int id;
  String firstName;
  String lastName;
  String picturePath;
  String email;

  User({this.id, this.firstName, this.lastName, this.picturePath, this.email});

  factory User.fromJson(dynamic json) {
    return User(
        id: json['id'],
        firstName: json['firstname'],
        lastName: json['lastname'],
        picturePath: json['picture_path'],
        email: json['email']
    );
  }

  bool hasProfilePicture() {
    return this.picturePath != null;
  }
}