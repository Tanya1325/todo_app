import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/screens/todo_list_screen.dart';
import 'package:todo_app/utils/app_constants.dart';
import 'package:todo_app/utils/sign_in_google.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                SizedBox(
                    height: 200,
                    width: 200,
                    child: Image.asset('assets/todo_image.png')),
                const SizedBox(
                  height: 40.0,
                ),
                const Text(
                  "ToDo App",
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
              ]),
              SizedBox(
                height: 60.0,
                width: MediaQuery.of(context).size.width / 1.5,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        backgroundColor: Colors.white,
                        elevation: 2.0),
                    onPressed: () async {
                      final User? user =
                          await signInWithGoogle(context: context);
                      debugPrint("User-->$user");
                      if (user != null) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ToDoListScreen(
                                  userData: user,
                                )));
                      }
                    },
                    child: Row(
                      children: [
                        Image.asset('assets/google_icon.png'),
                        const Text(
                          AppConstants.googleSignIn,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w800),
                        )
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
