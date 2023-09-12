import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class ThemeClass{
  Color lightPrimaryColor=HexColor('#33CCFF');
  Color darkPrimaryColor=HexColor('#480032');
  Color secondaryColor=HexColor('#99FFFF');
  Color accentColor=HexColor('#0099FF');

  static ThemeData lightTheme=ThemeData(
    primaryColor: ThemeData.light().scaffoldBackgroundColor,
    colorScheme: ColorScheme.light().copyWith(
      primary: _themeClass.lightPrimaryColor,
      secondary: _themeClass.secondaryColor,
    )
  );
  static ThemeData darkTheme=ThemeData(
    primaryColor: ThemeData.dark().scaffoldBackgroundColor,
    floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: Colors.blue,),
    colorScheme: ColorScheme.dark().copyWith(
      primary: _themeClass.darkPrimaryColor,
    )
  );
}
ThemeClass _themeClass=ThemeClass();