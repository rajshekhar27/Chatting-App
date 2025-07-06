import 'package:flutter/material.dart';

class Dialogs{
  static void showSnackbar(BuildContext context, {required String msg, required Color color}){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
    ));
  }
  static void showProgressBar(BuildContext context){
    showDialog(context: context, builder: (_)=>Center(child: CircularProgressIndicator()));
  }
}