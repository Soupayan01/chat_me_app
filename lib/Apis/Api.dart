

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:we_chat/models/chat_user.dart';
import 'package:we_chat/models/messege.dart';

class api{
      static FirebaseAuth auth= FirebaseAuth.instance;
      static FirebaseFirestore firestore=FirebaseFirestore.instance;
      static FirebaseStorage storage=FirebaseStorage.instance;
      static User get user=>auth.currentUser!;
      static Future<bool> isexist() async{
            return (await firestore.collection('users').doc(user.uid).get()).exists;
                                    }
      static late Chatuser me;
      static Future<void> getinfo() async{

            return await firestore.collection('users').doc(user.uid).get().then((user) async => {
                  if(user.exists)
                        {
                              me=Chatuser.fromJson(user.data()!),
                        }
                  else
                        {
                              await creatuser().then((value) => getinfo())
                        }
            });
      }

      static Future<void> creatuser() async{
            final time=DateTime.now().millisecondsSinceEpoch.toString();
            final chatuser=Chatuser(image: user.photoURL.toString(), lastActive: time, isOnline: true, id:user.uid, startAt: time , pushToken: '', Name: user.displayName.toString(), About: 'Hey,I am using Chat me', Email: user.email.toString());
            return await firestore.collection('users').doc(user.uid).set(chatuser.toJson());
      }

      static Stream<QuerySnapshot<Map<String, dynamic>>>getuser(){
            return firestore.collection('users').where('id',isNotEqualTo: user.uid).snapshots();
      }
      static Future<void> changedata() async{
            return await firestore.collection('users').doc(user.uid).update(
                {
                   'Name':me.Name,
                      'About':me.About,
                });
      }
      static Future<void> changepic(File file) async
      {
            final ext=file.path.split('.').last;
           final ref= storage.ref().child('Profile_pic/${user.uid}.$ext');
          await ref.putFile(file,SettableMetadata(contentType: 'image/$ext'));
          me.image=await ref.getDownloadURL();
            await firestore.collection('users').doc(user.uid).update(
                {
                    'image':me.image
                });
      }
      static String getconid(String id)=>user.uid.hashCode<=id.hashCode
          ?'${user.uid}_$id':'${id}_${user.uid}';
      static Stream<QuerySnapshot<Map<String, dynamic>>>getmessege(Chatuser user){
        return firestore.collection('chats/${getconid(user.id)}/messeges/').orderBy('sent',descending: true).snapshots();
      }
      static Future<void>sendmsg(Chatuser chatuser,String msg,Type type) async {
        final time=DateTime.now().millisecondsSinceEpoch.toString();
        final Messege messege=Messege(msg: msg, read: '', toId: chatuser.id, type:type, fromId:user.uid, sent: time);
        final ref=firestore.collection('chats/${getconid(chatuser.id)}/messeges/');
        await ref.doc(time).set(messege.toJson());
      }
      static Future<void>updatemsg(Messege messege) async {

        firestore.collection('chats/${getconid(messege.fromId)}/messeges/').doc(messege.sent).update({'read':DateTime.now().millisecondsSinceEpoch.toString()});
      }
      static Stream<QuerySnapshot<Map<String, dynamic>>>getlastmessege(Chatuser user){
        return firestore.collection('chats/${getconid(user.id)}/messeges/').orderBy('sent',descending: true).limit(1).snapshots();
      }
      static Future<void>sendchatimage(Chatuser chatuser,File file)
      async {
        final ext=file.path.split('.').last;
        final ref= storage.ref().child('images/${getconid(chatuser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');
        await ref.putFile(file,SettableMetadata(contentType: 'image/$ext'));
        final imageUrl=await ref.getDownloadURL();
        await sendmsg(chatuser, imageUrl, Type.image);
      }
}
