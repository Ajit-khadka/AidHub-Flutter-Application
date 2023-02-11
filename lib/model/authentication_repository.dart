

import 'package:blood_bank/Homepage/home_page.dart';
import 'package:blood_bank/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../welcomeScreen/welcome.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  var verificationId = ''.obs;

  //Variables
  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;

  //Will be load when app launches this func will be called and set the firebaseUser state
  @override
  void onReady() {
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  /// If we are setting initial screen from here
  /// then in the main.dart => App() add CircularProgressIndicator()
  _setInitialScreen(User? user) {
    user == null
        ? Get.offAll(() => const WelcomeScreen())
        : Get.offAll(() => const HomePage());
  }

  Future<void> phoneAuthentication(String phoneNo) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNo,
      verificationCompleted: (credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
      },
      codeSent: (verificationId, resendToken) {
        this.verificationId.value = verificationId;
      },
      codeAutoRetrievalTimeout: (verficationId) {
        verificationId.value = verficationId;
      },
      verificationFailed: (e) {
        if (e.code == 'invalid-phone-number') {
          Get.snackbar('error', 'The provided phone number is not valid');
        } else {
          Get.snackbar('error', 'Something went wrong try again ');
        }
      },
    );
  }

  Future<bool> verifyOTP(String otp) async {
    var credentials = await FirebaseAuth.instance.signInWithCredential(
        PhoneAuthProvider.credential(
            verificationId: verificationId.value, smsCode: otp));
    return credentials.user != null ? true : false;
  }

//fetch data
  Future<UserModel> getUserDetails(String email) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    final snapshot = await firebaseFirestore
        .collection("users")
        .where("email", isEqualTo: email)
        .get();

    final userData = snapshot.docs.map((e) => UserModel.fromMap(e)).single;

    return userData;
  }

  Future<List<UserModel>> allUser(String email) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    final snapshot = await firebaseFirestore.collection("users").get();

    final userData = snapshot.docs.map((e) => UserModel.fromMap(e)).toList();
    return userData;
  }

  Future<void> logout() async => await _auth.signOut();
}
