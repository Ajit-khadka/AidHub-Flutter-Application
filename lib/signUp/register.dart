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
        // SizedBox(
        //   height: 0,
        // ),
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

  final _emailController= TextEditingController();
  final usernameController= TextEditingController();
  final bloodController= TextEditingController();
  final contactController= TextEditingController();
  final _passwordController= TextEditingController();
  final _confirmPasswordController= TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading : IconButton(
          icon: Icon(Icons.arrow_back,
          color: Color.fromRGBO(254, 109, 115, 1) ),
          onPressed: (){
            Navigator.of(context).pop();
          },
        )
    ),
      //resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 40),
          child: Center(
            child: Form(
              key: formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  text(context),
                  //email
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (value){
                      _emailController.text = value!;
                    },
                      textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      labelText: "Email", labelStyle: TextStyle(),
                    ),

                        validator: (value) {
                               if (value!.isEmpty || !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value!)) {
                                   return "Not a valid Email";
                              } else {
                                   return null;
                            }
                         }
                  ),
                  //Username
                  Padding(
                    padding: EdgeInsets.only(top: 25.0),
                    child: TextFormField(
                      controller: usernameController,
                      onSaved: (value){
                        usernameController.text = value!;
                      },
                      textInputAction: TextInputAction.next,
                      validator: (value){
                        if(value!.isEmpty ||!RegExp(r'^[a-z A-Z]+$').hasMatch(value!)){
                          return "Not a valid Username";
                        }else{
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ), labelText: "Username"),

                    ),
                  ),
                  //bloodType
                  Padding(
                    padding: EdgeInsets.only(top: 25.0),
                    child: TextFormField(
                      controller: bloodController,
                      onSaved: (value){
                        bloodController.text = value!;
                      },
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.bloodtype),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          labelText: "Blood Type"),
                      validator: MultiValidator([
                        RequiredValidator(errorText: "Required"),
                      ]),
                    ),
                  ),
                  //contact
                  Padding(
                    padding: EdgeInsets.only(top: 25.0),
                    child: TextFormField(
                      controller: contactController,
                      onSaved: (value){
                        contactController.text = value!;
                      },
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.phone),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ), labelText: "Contact"),
                      validator: privatenumber,
                    ),
                  ),
                  //password
                  Padding(
                    padding: EdgeInsets.only(top: 25.0),
                    child: TextFormField(
                      controller: _passwordController,
                      onSaved: (value){
                        _passwordController.text = value!;
                      },
                      textInputAction: TextInputAction.next,
                      obscureText: true,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ), labelText: "Password"),
                      validator: requiredpass,
                    ),
                  ),
                  //confirmPassword
                  Padding(
                    padding: EdgeInsets.only(top: 25.0),
                    child: TextFormField(
                      controller: _confirmPasswordController,
                      onSaved: (value){
                        _confirmPasswordController.text = value!;
                      },
                      textInputAction: TextInputAction.done,
                      obscureText: true,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),),
                          labelText: "Confirm Password"),
                      validator: requiredpass,
                    ),
                  ),
                  //signup button
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 25.0,
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
                            horizontal: 120, vertical: 15),
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
