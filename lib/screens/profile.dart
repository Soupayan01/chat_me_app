import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:we_chat/Apis/Api.dart';
import 'package:we_chat/Directory/User%20Card.dart';
import 'package:we_chat/helper/dialogs.dart';
import 'package:we_chat/models/chat_user.dart';
import 'package:we_chat/screens/login.dart';
import 'package:we_chat/screens/profile.dart';

import '../main.dart';
import 'home_screen.dart';
class profile_screen extends StatefulWidget {
  final Chatuser user;
  const profile_screen({Key? key, required this.user}) : super(key: key);
  @override
  State<profile_screen> createState() => _profile_screenState();
}

class _profile_screenState extends State<profile_screen> {
  final formkey=GlobalKey<FormState>();
String?_image;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Profile'),
        ),
        body: Form(
          key: formkey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(width: mq.width,height: mq.height*.04,),
                Stack(
                  children: [
                    _image!=null?
                    ClipRRect(
                        borderRadius: BorderRadius.circular(mq.height*.1),
                        child: Image.file(
                          File(_image!),
                          height: mq.height*.2,
                          width: mq.height*.2,
                          fit: BoxFit.cover,
                        ),)
                     :
                    ClipRect(
              child: ClipRRect(
              borderRadius: BorderRadius.circular(mq.height*.1),
              child: CachedNetworkImage(
                    height: mq.height*.2,
                    width: mq.height*.2,
                    fit: BoxFit.cover,
                    imageUrl: widget.user.image,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),

              ),),
            ),
                Positioned(
                  bottom: 0,
                    right: 0,
                  child: MaterialButton(onPressed: () {
                    _showbottomsheet();
                  },
                   child: Icon(Icons.edit,color: Colors.black54,),
                    color: CupertinoColors.white,
                    shape: CircleBorder(),
                    elevation: 1,
                  ),
                )
                  ],
                ),
                SizedBox(height: mq.height*.04,),
                Text(widget.user.Email,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w400),),
                SizedBox(height: mq.height*.04,),
                TextFormField(
                initialValue: widget.user.Name,
                  onSaved: (val)=>api.me.Name=val ??'',
                  validator: (val)=> val!=null&&val.isNotEmpty?null:'Name Required!',
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person,color: Colors.black87,),
                    label: Text('Name'),
                    hintText: 'Enter Username',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      )
                  ),
              ),
                SizedBox(height: mq.height*.03,),
                TextFormField(
                  initialValue: widget.user.About,
                  onSaved: (val)=>api.me.About=val??'',
                  validator: (val)=> val!=null&&val.isNotEmpty? null:'About Required!',
                  decoration: InputDecoration(
                    label: Text('About'),
                      prefixIcon: Icon(Icons.info_outline,color: Colors.black87,),
                      hintText: 'About',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      )
                  ),
                ),
                SizedBox(height: mq.height*.03,),
              ElevatedButton.icon(onPressed: (){
                if(formkey.currentState!.validate())
                  {
                    log('uio');
                    formkey.currentState?.save();
                    api.changedata();
                  }


              }, icon: Icon(Icons.update), label: Text('Update'),)
              ],
            ),
          ),
        ),
          floatingActionButton: FloatingActionButton.extended(onPressed: () {},
         label: Text('logout'),icon: Icon(Icons.logout), backgroundColor: Colors.deepOrange,)
      ),
    );
  }
  void _showbottomsheet(){
    showModalBottomSheet(context: context,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))),builder: (_)
    {
      return ListView(
        shrinkWrap: true,
        padding: EdgeInsets.only(top:mq.height*.03,bottom: mq.height*.07),
        children: [
          Text('Select Picture',textAlign:TextAlign.center,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500
          ),),
        SizedBox(width: mq.width*.3,height:mq.height*.03,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(onPressed: () async {
              final ImagePicker picker = ImagePicker();
// Pick an image.
              final XFile? image = await picker.pickImage(source: ImageSource.gallery);
            if(image!=null)
              {
                setState(() {
                  _image=image.path;
                });
                api.changepic(File(_image!));
                Navigator.pop(context);
              }
            },style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              backgroundColor: Colors.white,
              fixedSize: Size(mq.height*.24,mq.width*.24),
            ), child: Image.asset('assets/images/photo.png'),),
            ElevatedButton(onPressed: () async {
              final ImagePicker picker = ImagePicker();
// Pick an image.
              final XFile? image = await picker.pickImage(source: ImageSource.camera);
              if(image!=null)
              {
                setState(() {
                  _image=image.path;
                });
                api.changepic(File(_image!));
                Navigator.pop(context);
              }
            },style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              backgroundColor: Colors.white,
              fixedSize: Size(mq.height*.24,mq.width*.24),
            ), child: Image.asset('assets/images/camera.png'),),
          ],
        )
        ],
      );
    });
  }
}

