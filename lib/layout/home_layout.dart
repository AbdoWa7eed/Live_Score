


import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_scores/modules/home_screen/home_screen.dart';
import 'package:football_scores/modules/states_screen/states_screen.dart';
import 'package:football_scores/shared/cubit/cubit.dart';
import 'package:football_scores/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<AppCubit , AppStates>(
      listener: (context, state) {
      },
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Scaffold(
          // bottomNavigationBar: BottomNavigationBar(
          //   items: cubit.bottomItems,
          //   currentIndex: cubit.current_index,
          //   onTap: (index) {
          //     cubit.ChangeBNB(index);
          //   },
          // ),
            body: HomeScreen()
        );
      },
    );
  }
}
