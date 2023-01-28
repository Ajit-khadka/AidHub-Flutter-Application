// ignore_for_file: prefer_const_constructors, sort_child_properties_last
import 'package:blood_bank/forgotpage/forgotpage.dart';
import 'package:blood_bank/signUp/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import '../Homepage/home_page.dart';
import '../main_page.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

//text controller
final emailController = TextEditingController();
final passwordController = TextEditingController();
GlobalKey<FormState> formKey = GlobalKey<FormState>();

Widget buildEmail() {
  return Material(
    elevation: 3.5,
    color: Colors.transparent,
    borderRadius: BorderRadius.all(Radius.circular(30)),
    shadowColor: Colors.black,
    child: TextField(
      controller: emailController,
      obscureText: false,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(
        color: Color.fromARGB(255, 68, 68, 130),
        fontSize: 14,
      ),
      decoration: InputDecoration(
          filled: true,
          fillColor: Color.fromRGBO(255, 203, 205, 1),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide(color: Color.fromRGBO(255, 203, 205, 1))),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide(color: Color.fromRGBO(255, 203, 205, 1))),
          hintText: 'Email',
          hintStyle:
          TextStyle(color: Color.fromARGB(150, 68, 68, 130), fontSize: 15),
          prefixIcon: Icon(
            Icons.person,
            color: Color.fromARGB(255, 68, 68, 130),
          )),
    ),
  );
}

Widget buildPassword() {
  return Material(
    elevation: 3.5,
    color: Colors.transparent,
    borderRadius: BorderRadius.all(Radius.circular(30)),
    shadowColor: Colors.black,
    child: TextFormField(
      controller: passwordController,
      obscureText: true ,
      keyboardType: TextInputType.visiblePassword,
      style: TextStyle(
        color: Color.fromARGB(255, 68, 68, 130),
        fontSize: 14,
      ),
      decoration: InputDecoration(
          filled: true,
          fillColor: Color.fromRGBO(255, 203, 205, 1),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide(color: Color.fromRGBO(255, 203, 205, 1))),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide(color: Color.fromRGBO(255, 203, 205, 1))),
          hintText: 'Password',
          hintStyle:
          TextStyle(color: Color.fromARGB(150, 68, 68, 130), fontSize: 15),
          prefixIcon: Icon(
            Icons.lock,
            color: Color.fromARGB(255, 68, 68, 130),
          )),
    ),

  );
}

Widget buildForgotPassword(BuildContext context) {
  return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
        child: Text(
          "Forgot Password ?",
          style: TextStyle(
            color: Color.fromARGB(255, 68, 68, 130),
            fontSize: 12,
          ),
        ),

        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: ((context) {
                return ForgotPass();
              }),
            ),
          );
        },
        //padding: EdgeInsets.only(right: 0),
      ));
}

Widget signUp(BuildContext context) {
  return Container(
      alignment: Alignment.center,
      child: TextButton(
          child: Text(
            "Don’t have an Account ? Sign Up ",
            style: TextStyle(
              color: Color.fromARGB(255, 68, 68, 130),
              fontSize: 12,
            ),
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: ((context) {
                  return SignIn();
                }),
              ),
            );
          }
        //padding: EdgeInsets.only(right: 0),
      ));
}

Widget orLine() {
  return RichText(
    text: TextSpan(children: const [
      TextSpan(
        text: ("_________________  "),
        style: TextStyle(color: Colors.red),
      ),
      TextSpan(
        text: ("  OR  "),
        style: TextStyle(color: Color.fromARGB(255, 68, 68, 130)),
      ),
      TextSpan(
        text: ("  _________________"),
        style: TextStyle(color: Colors.red),
      ),
    ]),
  );
}

class LoginPageState extends State<LoginPage> {

  void signUserIn(String email, String password) async{
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      ).then((value) => Navigator.of(context).push(MaterialPageRoute(builder: (context) => MainPage())));

      }
    on FirebaseAuthException catch(e)
      {
          if(e.code=='invalid-email'){
            errorEmail();
          } else if (e.code=='wrong-password'){
            errorPassword();
          } else if (e.code=='user-not-found'){
            errorPass();
          }
        };

    emailController.clear();
    passwordController.clear();

  }

  void check(){
    String email = emailController.text;
    String password = passwordController.text;

    if(email=='' || password==''){
      fill();
    }else{
      signUserIn(email, password);
    }
  }

  void fill(){
    showDialog(context: context, builder: (context){
      return AlertDialog( title:Text("Enter Email and password",  textAlign: TextAlign.center,
        style: TextStyle(
          color: Color.fromARGB(255, 68, 68, 130),
          fontSize: 18,
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromRGBO(254, 109, 115, 1),
            ),
            child: new Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();

            },
          ),
        ],
      );
    });
  }



  void errorEmail(){
    showDialog(context: context, builder: (context){
      return AlertDialog( title:Text("Invalid Email", textAlign: TextAlign.center,style: TextStyle(
        color: Color.fromARGB(255, 68, 68, 130),
        fontSize: 18,
        fontFamily: 'OpenSans',
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromRGBO(254, 109, 115, 1),
            ),
            child: new Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();

            },
          ),
        ],);
    });
  }

  void errorPassword(){
    showDialog(context: context, builder: (context){
      return AlertDialog( title:Text("Incorrect Password", textAlign: TextAlign.center, style: TextStyle(
        color: Color.fromARGB(255, 68, 68, 130),
        fontSize: 18,
        fontFamily: 'OpenSans',
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromRGBO(254, 109, 115, 1),
            ),
            child: new Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();

            },
          ),
        ],);
    });
  }

  void errorPass(){
    showDialog(context: context, builder: (context){
      return AlertDialog( title:Text("Account doesn't Exist", textAlign: TextAlign.center, style: TextStyle(
        color: Color.fromARGB(255, 68, 68, 130),
        fontSize: 18,
        fontFamily: 'OpenSans',
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromRGBO(254, 109, 115, 1),
            ),
            child: new Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();

            },
          ),
        ],);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Container(
        color: Colors.white,
      child : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
            Text(
              "LOGIN",
              style: TextStyle(
                color: Color.fromARGB(255, 68, 68, 130),
                fontSize: 20,
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                letterSpacing: 0,
              ),
            ),
            Image.asset("images/Login.png", scale: 0.5),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Column(children: [
                buildEmail(),
                SizedBox(
                  height: 20,
                ),
                buildPassword(),
                buildForgotPassword(context),
                //buildLoginBtn(context),
                Container(
                  width: 350,
                  height: 60,
                  child: ElevatedButton(onPressed: check,
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    style: ElevatedButton.styleFrom(
                      elevation: 5,

                      padding: EdgeInsets.all(18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: Color.fromRGBO(254, 109, 115, 1),),

                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                signUp(context),
                orLine(),

              ]),
            ),

          ],
        ),
      ),
      ),
      ),
    );
  }
}