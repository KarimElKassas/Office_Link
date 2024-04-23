import 'package:flutter/material.dart';

import 'font_manager.dart';

TextStyle _getTextStyle(double fontSize, FontWeight weight, Color color){
  return TextStyle(
      fontSize: fontSize,
      fontFamily: FontConstants.family,
      fontWeight: weight,
      color: color
  );
}
//light text style
TextStyle lightStyle({double fontSize = FontSize.s12, required Color color}){
  return _getTextStyle(fontSize, FontWeightManager.light, color);
}

//regular text style
TextStyle regularStyle({double fontSize = FontSize.s12, required Color color}){
  return _getTextStyle(fontSize, FontWeightManager.regular, color);
}

//medium text style
TextStyle boldStyle({double fontSize = FontSize.s12, required Color color}){
  return _getTextStyle(fontSize, FontWeightManager.bold, color);
}

//semi bold text style
TextStyle heavyStyle({double fontSize = FontSize.s12, required Color color}){
  return _getTextStyle(fontSize, FontWeightManager.heavy, color);
}

//bold text style
TextStyle blackStyle({double fontSize = FontSize.s12, required Color color}){
  return _getTextStyle(fontSize, FontWeightManager.black, color);
}