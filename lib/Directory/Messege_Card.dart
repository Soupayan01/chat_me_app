import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/Apis/Api.dart';
import 'package:we_chat/helper/time_return.dart';

import '../main.dart';
import '../models/messege.dart';



class Messege_Card extends StatefulWidget {
  const Messege_Card({Key? key, required this.messege}) : super(key: key);
 final Messege messege;
  @override
  State<Messege_Card> createState() => _Messege_CardState();
}

class _Messege_CardState extends State<Messege_Card> {
  @override
  Widget build(BuildContext context) {
    return api.user.uid==widget.messege.fromId?_bluemsg():_greenmsg();
  }
  Widget _greenmsg()
  {   if(widget.messege.read.isEmpty)
    {
      api.updatemsg(widget.messege);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:[ Flexible(
        child: Container(
          padding: EdgeInsets.all(widget.messege.msg==Type.image?mq.width*.03:mq.width*.04),
          margin: EdgeInsets.symmetric(horizontal: mq.width*.04,vertical: mq.height*.01),
          decoration: BoxDecoration(color: Colors.green[100],
              border: Border.all(color: CupertinoColors.activeGreen),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(30),
                  topRight:Radius.circular(30) ,bottomLeft: Radius.circular(30))
          ),
          child:   widget.messege.type!=Type.image?
          Text(widget.messege.msg,style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500),)
              :   ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: CachedNetworkImage(

              imageUrl: widget.messege.msg,
              placeholder: (context, url) => CircularProgressIndicator(strokeWidth: 2,),
              errorWidget: (context, url, error) => Icon(Icons.image,size:70),

            ),
          ),
        ),
      ),
    Padding(
      padding: EdgeInsets.symmetric(horizontal:  mq.width*.05,vertical: mq.height*.03),
        child: Text(MyDateUtil.getFormatedTime(context: context, time: widget.messege.sent),style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400),)
      )]
    );
  }
  Widget _bluemsg()
  {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:[
          Row(
            children: [
              SizedBox(width: mq.width*.04,),
              if(widget.messege.read.isNotEmpty)
                  Icon(Icons.done_all_rounded,color: CupertinoColors.activeBlue,),

              SizedBox(width: 2,),
              Text(MyDateUtil.getFormatedTime(context: context, time: widget.messege.sent),style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400),),
            ],
          ),
          Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.messege.msg==Type.image?mq.width*.03:mq.width*.04),
            margin: EdgeInsets.symmetric(horizontal: mq.width*.04,vertical: mq.height*.01),
            decoration: BoxDecoration(color: Colors.green[100],
                border: Border.all(color: CupertinoColors.activeGreen),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30),
                    topRight:Radius.circular(30) ,bottomLeft: Radius.circular(30))
            ),
            child:   widget.messege.type!=Type.image?
  Text(widget.messege.msg,style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500),)
      :   ClipRRect(
  borderRadius: BorderRadius.circular(15),
  child: CachedNetworkImage(

  imageUrl: widget.messege.msg,
  placeholder: (context, url) => Padding(
      padding: EdgeInsets.all(8),
      child: CircularProgressIndicator(strokeWidth: 2,)),
  errorWidget: (context, url, error) => Icon(Icons.image,size:70),

  ),
    ),
        ),
          )]
    );
  }

}
