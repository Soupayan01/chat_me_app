import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:we_chat/Apis/Api.dart';
import 'package:we_chat/Directory/User%20Card.dart';
import 'package:we_chat/helper/dialogs.dart';
import 'package:we_chat/models/chat_user.dart';
import 'package:we_chat/screens/login.dart';
import 'package:we_chat/screens/profile.dart';
class home_page extends StatefulWidget {
  const home_page({Key? key}) : super(key: key);

  @override
  State<home_page> createState() => _home_pageState();
}

class _home_pageState extends State<home_page> {
  List<Chatuser> list=[];
  final List<Chatuser> _searchlist=[];
  bool _issearching =false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    api.getinfo();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),
      child: WillPopScope(

        onWillPop: () {
          if(_issearching)
            {
              setState(() {
                _issearching=!_issearching;
              });

              return Future.value(false);
            }
          else
            {
              return Future.value(true);
            }
        },
        child: Scaffold(
          appBar: AppBar(
            leading :Icon(Icons.home),
              title: _issearching?TextField(
                decoration: InputDecoration(border: InputBorder.none,hintText: 'Type Name or Email...',),
              autofocus: true,
              onChanged: (val){
                  _searchlist.clear();
                  for(var i in list)
                    {
                      if(i.Name.toLowerCase().contains(val.toLowerCase())||i.Email.toLowerCase().contains(val.toLowerCase()))
                        {
                          _searchlist.add(i);
                        }
                      setState(() {
                        _searchlist;
                      });
                    }
              },
              style: TextStyle(fontSize: 18,letterSpacing: .8,fontWeight: FontWeight.w500),):Text('Let Chat'),
          actions: [
            IconButton(onPressed:() {
              setState(() {
                _issearching=!_issearching;
              });
            }, icon: Icon(_issearching?CupertinoIcons.clear_circled_solid:Icons.search)),
            IconButton(onPressed:() {
              Navigator.push(context, MaterialPageRoute(builder: (_) =>profile_screen(user: api.me,)));
            }, icon: Icon(Icons.more_vert)),
          ],
          ),
         floatingActionButton: FloatingActionButton(onPressed: () async {
            await api.auth.signOut();
            await GoogleSignIn().signOut();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_){
              return login_screen();
            }));
         },child: Icon(Icons.account_circle_rounded),),

        body: StreamBuilder(
          stream: api.getuser(),
          builder: (context,snapshot)
          {
            switch(snapshot.connectionState)
            {
              case ConnectionState.waiting:
              case ConnectionState.none:
             return Center(child: CircularProgressIndicator());
              case ConnectionState.active:
              case ConnectionState.done:
                final data=snapshot.data!.docs;
              list =data?.map((e) => Chatuser.fromJson(e.data())).toList() ?? [];
              if(list.isNotEmpty)
                {
                  log('${list.length}');
                  return ListView.builder(
                      itemCount: _issearching?_searchlist.length:list.length,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context,index){
                        return user_card(user :_issearching?_searchlist[index]:list[index]);
                      });
                }
          else
            {
              return Center(child: Text('User not found,Try again!',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20)));
            }

            }
          },
        ),
        ),
      ),
    );
  }
}

