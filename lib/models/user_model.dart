//User Model
class UserModel {
  String uid;
  String email;
  String firstName;
  String lastName;
  String address;
  String phoneNumber;
  String role;
  String farmName;
  String photoUrl;

  UserModel({
    this.uid,
    this.email,
    this.firstName,
    this.lastName,
    this.address,
    this.phoneNumber,
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
      address: data['address'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
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
        "address": address,
        "phoneNumber": phoneNumber,
        "role": role,
        "farmName": farmName,
        "photoUrl": photoUrl
      };
}
