// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => Register();
}

Widget text(BuildContext context) {
  return Center(
    child: Column(
      children: const [
        SizedBox(
          height: 40,
        ),
        Text(
          "  SIGNUP ",
          style: TextStyle(
            color: Color.fromARGB(255, 68, 68, 130),
            fontSize: 20,
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.bold,
            letterSpacing: 0,
          ),
        ),
        SizedBox(
          height: 25,
        ),
        Text(
          "Create an account it's Free",
          style: TextStyle(
              color: Color.fromARGB(255, 68, 68, 130),
              fontSize: 10,
              fontFamily: 'OpenSans'),
        ),
        SizedBox(
          height: 30,
        ),
      ],
    ),
  );
}

class Register extends State<SignIn> {

  GlobalKey<FormState> formkey = GlobalKey<FormState>();


  String? requiredpass(value) {

     if (value.length < 6) {
      return "Minimum 6 digit";
    } else if (value.length > 10) {
      return "Maximum 10 digit";
    } else {
      return null;
    }
  }

  String? privatenumber(value) {

    if(value!.isEmpty){
      return "Required";
    } else if (value.length > 10) {
      return "Maximum 10 digit";
    } else {
      return null;
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: Center(
            child: Form(
              key: formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  text(context),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: "Email", labelStyle: TextStyle()),
                        validator: (value) {
                               if (value!.isEmpty || !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value!)) {
                                   return "Not a valid Email";
                              } else {
                                   return null;
                            }
                         }
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: TextFormField(
                      validator: (value){
                        if(value!.isEmpty ||!RegExp(r'^[a-z A-Z]+$').hasMatch(value!)){
                          return "Not a valid Username";
                        }else{
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), labelText: "Username"),

                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Blood Type"),
                      validator: MultiValidator([
                        RequiredValidator(errorText: "Required"),
                      ]),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), labelText: "Contact"),
                      validator: privatenumber,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), labelText: "Password"),
                      validator: requiredpass,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Confirm Password"),
                      validator: requiredpass,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20.0,
                    ),
                    child: ElevatedButton(
                      child: Text(
                        "Signup",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: (){
                        if(formkey.currentState!.validate()){
                          //checks data
                          // final snackBar = SnackBar(content: Text("form submitted"));
                          // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 5,
                        padding: EdgeInsets.symmetric(
                            horizontal: 80, vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        backgroundColor: Color.fromRGBO(254, 109, 115, 1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
