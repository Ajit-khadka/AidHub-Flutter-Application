import 'package:blood_bank/loginPage/login.dart';
import 'package:blood_bank/main_page.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../Homepage/home_page.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/welcome.png"), fit: BoxFit.cover),
        ),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            Container(
              height: 80,
            ),
            const Text(
              "  Welcome To Blood Bank  ",
              style: TextStyle(
                color: Color.fromARGB(255, 68, 68, 130),
                fontSize: 20,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(
              height: 400,
            ),
            const Text(
              "    You Don't Have To\n Be Doctor To Save Life\n    Just Donate Blood ! ",
              style: TextStyle(
                color: Color.fromARGB(255, 68, 68, 130),
                fontSize: 20,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(
              height: 45,
            ),
            //to create a button
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    backgroundColor: const Color.fromARGB(255, 68, 68, 130),
                    minimumSize: const Size(50, 10)),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: ((context) {
                        return const MainPage();
                      }),
                    ),
                  );
                },
                //for icon inside the button
                child: IconButton(
                  icon: const Icon(Icons.arrow_forward_outlined),
                  iconSize: 25,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: ((context) {
                          return const LoginPage();
                        }),
                      ),
                    );
                  },
                )),
          ],
        ),
      ),
    );
  }
}


// crossAxisAlignment: CrossAxisAlignment.start,
//mainAxisAlignment: MainAxisAlignment.center,