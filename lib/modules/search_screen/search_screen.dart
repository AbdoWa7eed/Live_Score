

// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_scores/models/league_model.dart';
import 'package:football_scores/modules/standings_screen/standings_screan.dart';
import 'package:football_scores/shared/components/components.dart';
import 'package:football_scores/shared/cubit/cubit.dart';
import 'package:football_scores/shared/cubit/states.dart';
import 'package:football_scores/shared/styles/colors/colors.dart';
import 'package:football_scores/shared/styles/icon_broken.dart';

class SearchScreen extends SearchDelegate
{

  TextStyle? get searchFieldStyle => TextStyle(fontSize: 14 );
  @override
  String? get searchFieldLabel => 'Search for league';
  List<String> suggestions = [
  ];
  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      appBarTheme: AppBarTheme(
        titleTextStyle: TextStyle(
            fontSize: 14,
            fontFamily: 'Jannah'
        ),
        foregroundColor: Colors.black,
        color: Colors.grey[100],
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.grey[100],
          statusBarIconBrightness: Brightness.dark
        ),
        elevation: 2,
      ),
      textTheme: TextTheme(
        bodyText1: TextStyle(
            fontSize: 14,
            fontFamily: 'Jannah'
        )
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: InputBorder.none
      ),
      primarySwatch: buildMaterialColor(premierColor!),
      textSelectionTheme: TextSelectionThemeData(
        //cursorColor: Colors.red,
        selectionHandleColor: Colors.red,
        //selectionColor: Colors.white,
      ), // cursor color
    );
  }
  @override
  List<Widget>? buildActions(BuildContext context) {
  }
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(onPressed: ()
        {
          return close(context, null);
        }, icon: Icon(IconBroken.Arrow___Left));
  }
  @override
  Widget buildResults(BuildContext context)
  {
    AppCubit.get(context).getSaerchedLeague(query);
    return  BlocConsumer<AppCubit , AppStates>(
        listener: (context, state) {

    }, builder: (context, state) {
      var list = AppCubit.get(context).search;
      var cubit = AppCubit.get(context);
      return ConditionalBuilder(condition: list != null,
          builder: (context) {
            return ConditionalBuilder(condition: list!.response.isNotEmpty,
                builder: (context) {
                  return ListView.separated(
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return buildSearchedItem(context , cubit,list.response[index]);
                      },
                      separatorBuilder: (context, index) {
                        return
                          Container(
                            width: double.infinity,
                            height: 1,
                            color: Colors.grey[300],
                          );
                      }, itemCount: list.response.length);
                },
                fallback: (context) => Center(child: Text(
                    'No Searched Items'
                   , style: TextStyle(
                  fontFamily: 'Jannah',
                    fontSize: 25,
                ),
                ),),);
          },
          fallback: (context) => Center(child: CircularProgressIndicator(),),);
    });
  }
  Widget buildSearchedItem(context , AppCubit cubit , LeagueResponse model)
  {
    return InkWell(
      onTap: ()
      {
          cubit.getStandings(model.id!).then((value)
          {
            cubit.getMatches(model.id! , isSearch: true).then((value)
            {
              NavigateTo(context, StandingsScreen(model));
            });
          });
      },
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
          children: [
            buildImage('${model.logo}' , hight: 65 , width: 65 , fit: BoxFit.contain),
            SizedBox(
              width: 20,
            ),
            Text('${model.name}' , style: TextStyle(fontSize: 20),),
          ],
      ),
        ),
    );
  }
  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestions[index]),
          onTap: ()
          {
      
          },
        );
      },);
  }

}