import 'package:flutter/material.dart';
import 'package:we_chat/screens/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:we_chat/screens/splash_screen.dart';
import 'firebase_options.dart';


late Size mq;

  void main() {

  WidgetsFlutterBinding.ensureInitialized();
  _initializeFirebase();
  runApp((const MyApp()));
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white70,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
            iconTheme: IconThemeData(color: Colors.black,size: 25),
        )
      ),
      home: const splash_screen(
      ),
    );
  }
}
_initializeFirebase() async{
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

