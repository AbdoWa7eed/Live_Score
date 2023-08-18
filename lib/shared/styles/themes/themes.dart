

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:football_scores/shared/components/components.dart';
import 'package:football_scores/shared/styles/colors/colors.dart';

ThemeData lightTheme =  ThemeData(
    textSelectionTheme: const TextSelectionThemeData(
      selectionHandleColor: Colors.red, // Change bubble to red
      cursorColor: Colors.black,
    ),
    primarySwatch: buildMaterialColor(premierColor!),
    fontFamily: 'Jannah',
    appBarTheme: AppBarTheme(
      centerTitle: true,
        foregroundColor: Colors.black,
        elevation: 0,
        color: Colors.grey[100],
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.grey[100],
        )
    )
);