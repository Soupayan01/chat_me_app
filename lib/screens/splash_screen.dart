import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:we_chat/Apis/Api.dart';
import 'package:we_chat/main.dart';
import 'package:we_chat/screens/home_screen.dart';
import 'package:we_chat/screens/login.dart';

class splash_screen extends StatefulWidget {
  const splash_screen({Key? key}) : super(key: key);

  @override
  State<splash_screen> createState() => _splash_screenState();
}
class _splash_screenState extends State<splash_screen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 1),() {
      setState(() {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(systemNavigationBarColor: Colors.white,statusBarColor: Colors.white70));
        if(api.auth.currentUser!=null)
          {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context){
              return home_page();
            }),);
          }
        else
          {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context){
              return login_screen();
            }),);
          }

      });
    });
  }
  Widget build(BuildContext context) {
    mq=MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(children: [
        Positioned(
          top: mq.height*.25,
          width: mq.width*.55,
          right:mq.width*.23,
          child: Image.asset('assets/images/chat.png'),),
        Positioned(
          bottom: mq.height*.15,
          width: mq.width*.9,
          left:mq.width*.05,
          height: mq.height*.07,
          child: Center(child: Text('Welcome to chat me',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w400)),
          ),
          ),

      ]
      ),
    );
  }
}
