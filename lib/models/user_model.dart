//User Model
class UserModel {
  String uid;
  String email;
  String firstName;
  String lastName;
  String role;
  String farmName;
  String photoUrl;

  UserModel({
    this.uid,
    this.email,
    this.firstName,
    this.lastName,
    this.role,
    this.farmName,
    this.photoUrl,
  });

  factory UserModel.fromMap(Map data) {
    return UserModel(
      uid: data['uid'],
      email: data['email'] ?? '',
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      role: data['role'] ?? '',
      farmName: data['farmName'],
      photoUrl: data['photoUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "email": email,
        "firstName": firstName,
        "lastName": lastName,
        "role": role,
        "farmName": farmName,
        "photoUrl": photoUrl
      };
}
