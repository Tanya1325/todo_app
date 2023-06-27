import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:todo_app/screens/login_screen.dart';
import 'package:todo_app/screens/todo_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBTdr3__pksFTSK1fWbrngrhqQJs6unhR4",
          appId: "1:1015948700058:android:f594c08ccd769b156d7223",
          messagingSenderId: '1015948700058',
          projectId: "todo-app-dffc7",
          databaseURL: "https://todo-app-dffc7-default-rtdb.firebaseio.com"));
  User? user = FirebaseAuth.instance.currentUser;
  runApp(MyApp(user: user));
}

class MyApp extends StatelessWidget {
  final User? user;
  const MyApp({super.key, @required this.user});

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: user != null ? ToDoListScreen(userData: user) : const LoginScreen(),
        theme: ThemeData(
            fontFamily: GoogleFonts.montserrat().fontFamily,
            appBarTheme: AppBarTheme(backgroundColor: Colors.grey.shade100)),
      ),
    );
  }
}
