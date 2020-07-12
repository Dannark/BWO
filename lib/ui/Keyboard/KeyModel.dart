import 'package:flutter/material.dart';

class KeyModel {
  String value;
  double widthOnGrid = 1;
  double margin = 0;
  Color color;
  Color txtColor;

  KeyModel(this.value, this.widthOnGrid,
      {this.color, this.txtColor, this.margin = 0});
}
