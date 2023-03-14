class UserModel {
  String? uid;
  String? email;
  String? userName;
  String? bloodType;
  String? contact;
  String? status;
  String? imagePath;
  String? location;
  String? role;

  UserModel({
    this.uid,
    this.email,
    this.userName,
    this.bloodType,
    this.contact,
    this.status,
    this.imagePath,
    this.location,
    this.role,
  });

  //receive data from database
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      userName: map['username'],
      bloodType: map['bloodType'],
      contact: map['contact'],
      status: map['status'],
      imagePath: map['imagePath'],
      location: map['location'],
      role: map['role'],
    );
  }
//sending data to database
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'username': userName,
      'bloodType': bloodType,
      'status': status,
      'contact': contact,
      'location': location,
      'imagePath': imagePath,
      'role': role,
    };
  }
}
