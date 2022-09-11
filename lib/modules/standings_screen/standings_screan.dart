

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_scores/models/league_model.dart';
import 'package:football_scores/models/standings_model.dart';
import 'package:football_scores/shared/components/components.dart';
import 'package:football_scores/shared/cubit/cubit.dart';
import 'package:football_scores/shared/cubit/states.dart';
import 'package:football_scores/shared/styles/icon_broken.dart';

class StandingsScreen extends StatelessWidget {
  LeagueResponse model;
  StandingsScreen(this.model);
  @override
  Widget build(BuildContext context) {
    return
      BlocConsumer<AppCubit , AppStates>(
        listener: (context, state) {

        },
        builder:(context, state) {
          var cubit = AppCubit.get(context);
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                foregroundColor: Colors.black,
                leading: IconButton(onPressed: ()
                {
                  Navigator.pop(context);
                }, icon: Icon(IconBroken.Arrow___Left)),
                elevation: 4,
                centerTitle: true,
                title: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:buildImage(model.logo! , width: 35 , hight: 35)
                    ),
                    Expanded(
                      child: Text('${model.name}' ,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),),
                    ),
                  ],
                ),
                bottom: TabBar(
                    onTap: (index)
                    {

                    },
                    tabs: [
                      Text('Matches',  style: TextStyle(
                        color: Colors.black,
                      ),),
                      Text('Standings' ,
                        style: TextStyle(
                          color: Colors.black,
                        ),)
                    ]),
              ),
              body: Container(
                color: Colors.grey[100],
                child: ConditionalBuilder(
                  condition: state is! AppGetMatchesLoadingState && state is! AppGetStandingsSuccessState ,
                  builder:(context) {
                    return TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child:
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Live Matches' , style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey[700] , fontWeight: FontWeight.bold
                                ),),
                                SizedBox(
                                  height: 8,
                                ),
                                Container(
                                  height: 220,
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: ConditionalBuilder(
                                            condition: cubit.searchedLiveMatches.isNotEmpty,
                                            builder:
                                                (context) {
                                              return ListView.separated(
                                                  physics: BouncingScrollPhysics(),
                                                  scrollDirection: Axis.horizontal,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return buildLiveMatchItem(cubit ,context ,cubit.searchedLiveMatches[index]);
                                                  },
                                                  separatorBuilder: (context, index) {
                                                    return SizedBox(
                                                      width: 10,
                                                    );
                                                  }, itemCount: cubit.searchedLiveMatches.length);
                                            },
                                            fallback: (context) {
                                              return Center(
                                                child: Container(
                                                  child: Text('No Live Matches' ,
                                                    style: TextStyle(color: Colors.black , fontSize: 25 , fontWeight: FontWeight.bold),),
                                                ),
                                              );
                                            },
                                          )
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text('Matches' , style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey[700] , fontWeight: FontWeight.bold
                                ),),
                                SizedBox(
                                  height: 10,
                                ),
                                ConditionalBuilder(condition: cubit.nsSearchedMatches.isNotEmpty,
                                  builder: (context) {
                                    return  ListView.separated(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return buildMatchItem(cubit , cubit.nsSearchedMatches[index], index , context);
                                        },
                                        separatorBuilder: (context, index) {
                                          return SizedBox(
                                            height: 10,
                                          );
                                        },
                                        itemCount: cubit.nsSearchedMatches.length);
                                  },
                                  fallback: (context) {
                                    return Center(
                                      child: Container(
                                        child: Text('No Matches' ,
                                          style: TextStyle(color: Colors.black , fontSize: 25 , fontWeight: FontWeight.bold),),
                                      ),
                                    );
                                  },),
                              ],
                            ),
                          ),
                        ),
                        SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            child: SingleChildScrollView(
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                child:
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                     for(int i = 0 ; i < cubit.standings!.response[0].standings!.length ; i++)
                                       ...[

                                        if(cubit.standings!.response[0].standings!.length > 1) ...[
                                          Padding(
                                            padding: const EdgeInsets.only(left: 8.0 , top: 8.0),
                                            child: Text('${cubit.standings!.response[0].standings![i][0].group}'),
                                          ),
                                        ],
                                         buildDateTabel(cubit , i),
                                      ]
                                  ],

                                ),
                            )),
                      ],
                    );
                  },
                  fallback:(context) =>  Center(child: CircularProgressIndicator()),
                ),
              ),
            ),
          );
        },
      );
  }

  Widget buildDateTabel(AppCubit cubit , index)
  {
    final columns = ['Club','MP', 'W', 'D', 'L', 'GF', 'GA', 'GD', 'Pts'];
    return DataTable(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20)
        ),
        dataRowHeight: 50,
        columnSpacing: 15,
        horizontalMargin: 10,
        headingRowHeight: 35,
        columns: getColumns(columns),
        rows: getRows(cubit.standings!.response[0].standings![index]));
  }
  List<DataRow> getRows(List<RankInfo> models)
  {

    return models.map((e) => DataRow(
      cells: [
        DataCell(Container(
          width: 200,
          child: Row(children: [
            Text('${e.rank}'),
            SizedBox(
              width: 5,
            ),
            buildImage(e.team!.logo! , width: 30 , hight: 30),
            SizedBox(width: 5,),
            Text(e.team!.name!),
          ],),
        )),
        DataCell(Text('${e.all!.played}')),
        DataCell(Text('${e.all!.win}')),
        DataCell(Text('${e.all!.draw}')),
        DataCell(Text('${e.all!.lose}')),
        DataCell(Text('${e.all!.goals!.GF}')),
        DataCell(Text('${e.all!.goals!.GA}')),
        DataCell(Text('${e.GD}')),
        DataCell(Text('${e.points}')),
      ]
    )).toList();
  }
  List<DataColumn> getColumns(List<String> columns)
  => columns.map((e) => DataColumn(
      label: Text(e)) ).toList();

  /*

  ListView.separated(
   itemBuilder: (context, index) {
     return buildClub();
      },
    separatorBuilder: (context, index) =>   Container(
    width: double.infinity,
    height: 1,
    color: Colors.grey[300],
     ),
   itemCount: 20),*/
  Widget buildClub()
  {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [

          buildImage(model.logo! , width: 30 , hight: 30),
          SizedBox(
            width: 10 ,
          ),
          Text('Manchester city')
        ],
      ),
    );
  }
  List<String>
  list =
  [
    'MP',
    'W',
    'D',
    'L',
    'GF',
    'GA',
    'GD',
    'Pts'
  ];
  Widget buildText(String text)
  {
    return Text(text , style: TextStyle(
      color: Colors.grey[700]
    ),);
  }
}
