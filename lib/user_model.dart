import 'package:firebase_auth/firebase_auth.dart';

class UserModel{
  String? uid;
  String? email;
  String? userName;
  String? bloodType;
  int? contact;
  String? password;
  String? confirmPass;

  UserModel({this.uid, this.email,this.userName});

  //receive data from database
  factory UserModel.fromMap(map){
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      userName: map['username'],
    );
  }
//sending data to database
  Map<String, dynamic> toMap(){
    return{
      'uid':uid,
      'email': email,
      'username': userName,
    };
  }

}