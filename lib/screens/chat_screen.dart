import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:we_chat/Apis/Api.dart';
import 'package:we_chat/Directory/Messege_Card.dart';
import 'package:we_chat/models/chat_user.dart';
import 'package:we_chat/screens/home_screen.dart';

import '../main.dart';
import '../models/messege.dart';
class chat_screen extends StatefulWidget {
  final Chatuser user;
  const chat_screen({Key? key, required this.user}) : super(key: key);

  @override
  State<chat_screen> createState() => _chat_screenState();
}

class _chat_screenState extends State<chat_screen> {
   List<Messege>_list=[];
   bool _showemogie=false,_isuploading=false;
   final _textcontroller=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: ()=>FocusScope.of(context).unfocus(),
          child: SafeArea(
            child:
            WillPopScope(
          onWillPop: () {

    if(_showemogie)
    {
    setState(() {
    _showemogie=!_showemogie;
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
                  flexibleSpace: _appbar(),
                ),
                backgroundColor: Colors.blue[50],
                body: Column(
                  children: [Expanded(
                    child: StreamBuilder(
                      stream: api.getmessege(widget.user),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                          case ConnectionState.none:
                            return SizedBox();
                          case ConnectionState.active:
                          case ConnectionState.done:
                            final data = snapshot.data!.docs;

                            _list = data?.map((e) => Messege.fromJson(e.data()))
                                .toList() ?? [];

                            if (_list.isNotEmpty) {
                              return ListView.builder(
                                reverse: true,
                                  itemCount: _list.length,
                                  physics: BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return Messege_Card(messege: _list[index]);
                                    // return Text('lola');
                                  });
                            }
                            else {
                              return Center(child: Text('Say Hello',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600, fontSize: 20)));
                            }
                        }
                      },
                    ),
                  ),
                    if(_isuploading)
                    Align(
                      alignment: Alignment.centerRight,
                        child:  Padding(
                            padding: EdgeInsets.symmetric(vertical: 8,horizontal: 20),
                            child: CircularProgressIndicator(strokeWidth: 2,))
                    ),
                    _lowbar(),
                    if(_showemogie)
                      SizedBox(
                          height: mq.height * .35,
                          child: EmojiPicker(

                            textEditingController: _textcontroller,
                            config: Config(
                              columns: 8,
                              emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),

                            ),

                          )
                      )
                  ],
                ),
          ),
            ),
        ),
      ),
    ) ;
  }
  Widget _appbar()
  {
    return InkWell(
      onTap: (){},
      child: Row(
        children: [
          IconButton(onPressed:()=>Navigator.pushReplacement(context, MaterialPageRoute(builder: (_){ return home_page();})),
           icon: Icon(Icons.arrow_back,color: Colors.black,)),
          ClipRRect(
            borderRadius: BorderRadius.circular(mq.height*.03),
            child: CachedNetworkImage(
              height: mq.height*.05,
              width: mq.height*.05,
              imageUrl: widget.user.image,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          SizedBox(width: 8,),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Text(widget.user.Name,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
               Text(widget.user.About,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),),
             ],
          )
        ],
      ),
    );
  }
Widget _lowbar()
{
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: mq.width*.01,vertical: mq.height*.02),
    child: Row(
      children: [
        Expanded(
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Row(
                    children: [
                      IconButton(onPressed:(){
                        setState(() {
                          FocusScope.of(context).unfocus();
                          _showemogie=!_showemogie;
                        });
                      },
                          icon: Icon(Icons.emoji_emotions_outlined,color: Colors.blue,)),
                      Expanded(child: TextField(
                        controller: _textcontroller,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        onTap: (){
                          if(_showemogie)
                            setState(() {
                            _showemogie=!_showemogie;
                          });
                        },
                        decoration: InputDecoration(hintText: 'Type something.....',hintStyle: TextStyle(color: Colors.blue),
                        border: InputBorder.none),
                      )),
                      IconButton(onPressed:() async {
                        final ImagePicker picker = ImagePicker();
// Pick an image.
                        final List<XFile> images = await picker.pickMultiImage(imageQuality: 70);
                       for(var i in images)
                         {
                           setState(() {
                             _showemogie=true;
                           });
                           await api.sendchatimage(widget.user,File(i.path));
                           setState(() {
                             _showemogie=false;
                           });
                         }

                      },
                          icon: Icon(Icons.image
                            ,color: Colors.blue,)),
                      IconButton(
                        onPressed:() async {
final ImagePicker picker = ImagePicker();
// Pick an image.
final XFile? image = await picker.pickImage(source: ImageSource.camera,imageQuality: 70);
if(image!=null)
{
  setState(() {
    _showemogie=true;
  });
await api.sendchatimage(widget.user,File(image.path));
  setState(() {
    _showemogie=false;
  });
};
},
                          icon: Icon(Icons.camera_alt,color: Colors.blue,),)

                    ],
                  ),
              ),
        ),
        MaterialButton(onPressed: (){
          if(_textcontroller.text.isNotEmpty)
            {
              api.sendmsg(widget.user, _textcontroller.text,Type.text);
              _textcontroller.text='';
            }
        },child: Icon(Icons.send,size: 24,color: Colors.white,),shape: CircleBorder(),padding: EdgeInsets.only(top: 10,bottom: 10,right: 5,left: 10),minWidth: 0,color: Colors.blue,)
      ],
    ),
  );
}
}


