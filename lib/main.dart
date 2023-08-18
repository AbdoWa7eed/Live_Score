// ignore_for_file: prefer_const_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_scores/firebase_options.dart';
import 'package:football_scores/layout/home_layout.dart';
import 'package:football_scores/modules/login_screen/cubit/cubit.dart';
import 'package:football_scores/modules/login_screen/login_screen.dart';
import 'package:football_scores/modules/register_screen/cubit/cubit.dart';
import 'package:football_scores/shared/bloc_observer.dart';
import 'package:football_scores/shared/components/constants.dart';
import 'package:football_scores/shared/cubit/cubit.dart';
import 'package:football_scores/shared/network/local/cache_helper.dart';
import 'package:football_scores/shared/network/remote/dio_helper.dart';
import 'package:football_scores/shared/styles/themes/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  DioHelper.init();
  await CacheHelper.init();
  UID = CacheHelper.getData('uid');
  runApp(MyApp());
  Bloc.observer = MyBlocObserver();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginCubit(),
        ),
        BlocProvider(
          create: (context) => RegisterCubit(),
        ),
        BlocProvider(create: (context) => AppCubit()..initData()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Live Score',
        theme: lightTheme,
        home: startScreen(),
      ),
    );
  }

  Widget startScreen() {
    if (UID != null) {
      return const HomeLayout();
    }
    return LoginScreen();
  }
}
