import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgetPass extends StatefulWidget {
  const ForgetPass({super.key});

  @override
  State<ForgetPass> createState() => _ForgetPassState();
}

GlobalKey<FormState> formkey = GlobalKey<FormState>();
final emailController = TextEditingController();

String? errorMessage;

class _ForgetPassState extends State<ForgetPass> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Color.fromRGBO(254, 109, 115, 1)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formkey,
          child: Column(
            children: [
              const Text(
                "  Forgot Password ",
                style: TextStyle(
                  color: Color.fromARGB(255, 68, 68, 130),
                  fontSize: 22,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Image.asset(
                'images/verification.png',
                fit: BoxFit.cover,
              ),
              const SizedBox(
                height: 25,
              ),
              const Text(
                "Enter your Email to change password.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black38,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                child: TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (value) {
                      emailController.text = value!;
                    },
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelText: "Email",
                      labelStyle: const TextStyle(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty ||
                          !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value)) {
                        return "Not a valid Email";
                      } else {
                        return null;
                      }
                    }),
              ),
              const SizedBox(
                height: 35,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (formkey.currentState!.validate()) {
                    try {
                      await FirebaseAuth.instance
                          .sendPasswordResetEmail(
                              email: emailController.text.toString())
                          .then((value) {
                        Fluttertoast.showToast(
                            msg: "Recovery Password is sent to your email ");
                      });
                    } on FirebaseAuthException catch (error) {
                      switch (error.code) {
                        case "invalid-email":
                          errorMessage =
                              "Your email address appears to be malformed.";
                          break;
                        case "too-many-requests":
                          errorMessage = "Too many requests";
                          break;
                        case "user-not-found":
                          errorMessage = "Email doesn't exists";
                          break;
                        default:
                          errorMessage = "Something went wrong Try again later";
                      }

                      Fluttertoast.showToast(msg: errorMessage!);
                      debugPrint(error.code);
                    }
                    emailController.clear();
                  }
                },
                style: ElevatedButton.styleFrom(
                  elevation: 5,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  backgroundColor: const Color.fromRGBO(254, 109, 115, 1),
                ),
                child: const Text(
                  "Send",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
