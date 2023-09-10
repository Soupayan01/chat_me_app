import 'package:flutter/material.dart';

class Dialogs{

  static void showSnackbar(BuildContext context,String msg){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content :Text(msg),
    behavior:SnackBarBehavior.floating));
  }
  static void progressbar(BuildContext contest)
  {
    showDialog(context: contest,
             builder: (_) => Center(child: CircularProgressIndicator()));
  }
}