// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

class ForgotPass extends StatefulWidget {
  const ForgotPass({super.key});

  @override
  State<ForgotPass> createState() => Recover();
}

Widget text(BuildContext context) {
  return Center(
    child: Column(
      children: const [
        SizedBox(
          height: 0,
        ),
        Text(
          "  FORGOT PASSWORD ",
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
          height: 25,
        ),
      ],
    ),
  );
}

class Recover extends State<ForgotPass> {
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

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon:
                Icon(Icons.arrow_back, color: Color.fromRGBO(254, 109, 115, 1)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )),
      //  resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(40),
            child: Center(
              child: Form(
                //autovalidateMode: AutovalidateMode.onUserInteraction,
                key: formkey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 150,
                      ),
                      text(context),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(), labelText: "Email"),
                        validator: MultiValidator([
                          RequiredValidator(errorText: "Required"),
                          EmailValidator(errorText: "Not a Valid Email")
                        ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: TextFormField(
                          obscureText: true,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Password"),
                          validator: requiredpass,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: TextFormField(
                          obscureText: true,
                          decoration: const InputDecoration(
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
                            "Confirm",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            if (formkey.currentState!.validate()) {
                              //checks data
                              final snackBar =
                                  SnackBar(content: Text("form submitted"));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 5,
                            padding: EdgeInsets.symmetric(
                                horizontal: 80, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            backgroundColor: Color.fromRGBO(254, 109, 115, 1),
                          ),
                        ),
                      ),
                    ]),
              ),
            )),
      ),
    );
  }
}
