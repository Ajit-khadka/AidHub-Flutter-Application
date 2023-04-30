// ignore_for_file: file_names

class AdminModel {
  String? uid;
  String? email;
  String? userName;
  String? role;
  String? contact;
  String? status;
  String? imagePath;
  String? location;

  AdminModel({
    this.uid,
    this.email,
    this.userName,
    this.contact,
    this.status,
    this.imagePath,
    this.location,
    this.role,
  });

  //receive data from database
  factory AdminModel.fromMap(map) {
    return AdminModel(
      uid: map['uid'],
      email: map['email'],
      userName: map['username'],
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
      'status': status,
      'contact': contact,
      'location': location,
      'imagePath': imagePath,
      'role': role
    };
  }
}
