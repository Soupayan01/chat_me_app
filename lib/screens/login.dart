
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:we_chat/Apis/Api.dart';
import 'package:we_chat/helper/dialogs.dart';
import 'package:we_chat/main.dart';
import 'package:we_chat/screens/home_screen.dart';

class login_screen extends StatefulWidget {
  const login_screen({Key? key}) : super(key: key);

  @override
  State<login_screen> createState() => _login_screenState();
}

class _login_screenState extends State<login_screen> {
  bool lol=false;
  @override
     void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 1),() {
      setState(() {
        lol=true;
      });
    });
  }
  _handelGooglebtnclick() {
    Dialogs.progressbar(context);
    _signInWithGoogle().then((user)
        async {
          Navigator.pop(context);
   if(user!=null)
     {

         if((await api.isexist()))
         {
           Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context){
             return home_page();
           }));
         }
         else
         {
           api.creatuser().then((value) => {
             Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context){
               return home_page();
             })),
           });
         }
       }
        }
    );
  }
  Future<UserCredential?> _signInWithGoogle() async {
    // Trigger the authentication flow
    try
    {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    }
    catch(e)
    {
      Dialogs.showSnackbar(context, '     please Check Internet connection');
      return null;
    }
  }
  Widget build(BuildContext context) {
    mq=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title :Text("chat me"),
      ),
        body: Stack(children: [
          AnimatedPositioned(
            top: mq.height*.15,
            width: mq.width*.55,
            right:lol ?mq.width*.23: -mq.width*.7,
            duration: Duration(seconds: 1),
            child: Image.asset('assets/images/chat.png'),),
        Positioned(
        bottom: mq.height*.15,
        width: mq.width*.9,
        left:mq.width*.05,
        height: mq.height*.07,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.lightGreenAccent,
            shape: StadiumBorder(),
            elevation: 1.5,
          ),
          onPressed:() {
            _handelGooglebtnclick();
          }, icon: Image.asset('assets/images/google.png',height: mq.height*.04,), label: RichText(text: TextSpan(
    style: TextStyle(color: Colors.black, fontSize: 19  ),
    children: [
           TextSpan(text: 'sign with '),
           TextSpan(text: 'Google', style:  TextStyle(fontWeight: FontWeight.w500)),
    ])),
    ),
    ),
      ]
    ),
    );
  }
}
