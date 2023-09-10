
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/Apis/Api.dart';
import 'package:we_chat/Directory/User%20Card.dart';
import 'package:we_chat/helper/time_return.dart';
import 'package:we_chat/models/chat_user.dart';
import 'package:we_chat/models/messege.dart';
import 'package:we_chat/screens/login.dart';
import 'package:we_chat/screens/profile.dart';

import '../main.dart';
import '../screens/chat_screen.dart';
class user_card extends StatefulWidget {
  final Chatuser user;

  const user_card({super.key, required this.user});
  @override
  State<user_card> createState() => _user_cardState();
  static fromJson(Map<String, dynamic> data) {}
}

class _user_cardState extends State<user_card> {
  Messege?_messege;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width*.01,vertical:3),
      color: Colors.blue[200],
      child: InkWell(onTap:() {
        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>chat_screen(user :widget.user),
        ));
      },
      child: StreamBuilder(
        stream: api.getlastmessege(widget.user),
        builder: (context,snapshot){
          final data=snapshot.data!.docs;
          final list =data?.map((e) => Messege.fromJson(e.data())).toList() ?? [];
          if(list.isNotEmpty){
            _messege=list[0];
          }
          return ListTile(
            leading:
            ClipRRect(
              borderRadius: BorderRadius.circular(mq.width*.07),
              child: CachedNetworkImage(
                height: mq.height*.14,
                width: mq.width*.14,
                imageUrl: widget.user.image,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),

              ),
            ),
            title:  Text(widget.user.Name,style: TextStyle(fontWeight:FontWeight.w700),),
            subtitle: Text(_messege!=null?
            _messege!.type==Type.image
                ?'image'
                :_messege!.msg:
            widget.user.About,maxLines: 1,style: TextStyle(fontWeight:FontWeight.w600),),
            trailing:_messege==null?null:_messege!.read .isEmpty&&_messege?.fromId!=api.user.uid?Container(width: 16,height: 16,decoration: BoxDecoration(color: Colors.green,borderRadius: BorderRadius.circular(10)),):Text(MyDateUtil.getLastmsgTime(context: context, time: _messege!.sent),style: TextStyle(fontWeight:FontWeight.w500),),
          );
        }
      )
    ),);
  }
}
