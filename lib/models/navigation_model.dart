import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigationModel {
  String title;
  IconData icon;
  Function onTap;

  NavigationModel({this.title, this.icon, this.onTap});
}