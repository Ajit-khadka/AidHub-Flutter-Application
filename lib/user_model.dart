import 'package:firebase_auth/firebase_auth.dart';

class UserModel{
  String? uid;
  String? email;
  String? userName;
  String? bloodType;
  String? contact;
  String? password;
  String? confirmPass;

  UserModel({this.uid, this.email,this.userName,this.bloodType,this.contact,this.password,this.confirmPass});

  //receive data from database
  factory UserModel.fromMap(map){
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      userName: map['username'],
      bloodType: map['bloodType'],
      contact: map['contact'],
      password: map['password'],
      confirmPass: map['confirmpass']

    );
  }
//sending data to database
  Map<String, dynamic> toMap(){
    return{
      'uid':uid,
      'email': email,
      'username': userName,
      'bloodType':bloodType,
      'contact': contact,
      'password': password,
      'confirmpass':confirmPass
    };
  }

}