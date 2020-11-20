import 'package:chat2/helper/authenticate.dart';
import 'package:chat2/screens/chat_room_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Widget chateRome = ChateRome();
  User user = await FirebaseAuth.instance.currentUser;

  if (user == null) {
    chateRome = Authenticate();
  }

  runApp(MyApp(chateRome));
}

class MyApp extends StatefulWidget {
  final Widget home;
  MyApp(this.home);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.grey[700],
        ),
        debugShowCheckedModeBanner: false,
        home: widget.home,
      ),
    );
  }
}
