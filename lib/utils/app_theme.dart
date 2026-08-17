import 'package:flutter/material.dart';
import '../constant/app_colors.dart';

ThemeData appThemeData = ThemeData(
  fontFamily: 'Satoshi',
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: AppColors.instance.dark900),
    bodyMedium: TextStyle(color: AppColors.instance.dark900),
    bodySmall: TextStyle(color: AppColors.instance.dark900),
  ),

  scaffoldBackgroundColor: AppColors.instance.white50,
  dividerColor: AppColors.instance.transparent,
  appBarTheme: AppBarTheme(backgroundColor: AppColors.instance.white50),
  inputDecorationTheme: InputDecorationTheme(
hintStyle: TextStyle(
  fontStyle: FontStyle.normal,
  color: AppColors.instance.secondaryText,
),
    fillColor: AppColors.instance.textFiledBg,
    filled: true,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: AppColors.instance.transparent)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: AppColors.instance.dark500)),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: AppColors.instance.transparent)),
    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: AppColors.instance.error)),
    focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: AppColors.instance.error)),
  ),
  popupMenuTheme: PopupMenuThemeData(
    color: AppColors.instance.white50,
    iconColor: AppColors.instance.white50,
    shadowColor: AppColors.instance.white50,
    surfaceTintColor: AppColors.instance.white50,
    elevation: 0,
  ),
  buttonTheme: ButtonThemeData(hoverColor: AppColors.instance.transparent, highlightColor: AppColors.instance.transparent,minWidth: double.infinity),
  elevatedButtonTheme: ElevatedButtonThemeData(

    style: ButtonStyle(
      elevation: const WidgetStatePropertyAll(
        0,
      ),
      backgroundColor: WidgetStatePropertyAll(AppColors.instance.primary),
      overlayColor: WidgetStatePropertyAll(AppColors.instance.transparent),
      mouseCursor: const WidgetStatePropertyAll(MouseCursor.defer),

      // OR minimumSize if you want it to grow with child
      // minimumSize: MaterialStatePropertyAll(Size(double.infinity, 50)),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      overlayColor: WidgetStatePropertyAll(AppColors.instance.transparent),
      mouseCursor: const WidgetStatePropertyAll(MouseCursor.defer),
      fixedSize: const WidgetStatePropertyAll(
        Size(double.infinity, 44),
      ),
    ),
  ),


);
