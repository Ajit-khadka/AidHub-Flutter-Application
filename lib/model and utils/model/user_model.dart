// ignore_for_file: non_constant_identifier_names

class UserModel {
  String? uid;
  String? email;
  String? userName;
  String? bloodType;
  String? contact;
  String? status;
  String? image;
  String? location;
  String? role;
  String? created_at;
  bool? is_online;
  String? last_active;
  String? push_token;

  UserModel({
    this.uid,
    this.email,
    this.userName,
    this.bloodType,
    this.contact,
    this.status,
    this.image,
    this.location,
    this.role,
    this.created_at,
    this.is_online,
    this.last_active,
    this.push_token,
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
      image: map['image'],
      location: map['location'],
      role: map['role'],
      created_at: map['created_at'],
      is_online: map['is_online'],
      last_active: map["last_active"],
      push_token: map['push_token'],
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
      'image': image,
      'role': role,
      'created_at': created_at,
      'is_online': is_online,
      'last_active': last_active,
      'push_token': push_token,
    };
  }
}
