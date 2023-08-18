import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_scores/models/events_model.dart';
import 'package:football_scores/models/line_up_model.dart';
import 'package:football_scores/models/match_model.dart';
import 'package:football_scores/models/stats_model.dart';
import 'package:football_scores/shared/components/components.dart';
import 'package:football_scores/shared/cubit/cubit.dart';
import 'package:football_scores/shared/cubit/states.dart';
import 'package:football_scores/shared/styles/colors/colors.dart';
import 'package:football_scores/shared/styles/icon_broken.dart';

class StatsScreen extends StatelessWidget {
  final Response model;
  const StatsScreen(this.model, {super.key});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            foregroundColor: Colors.white,
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: premierColor,
                statusBarIconBrightness: Brightness.light),
            backgroundColor: premierColor,
            elevation: 0,
            centerTitle: true,
            title: Text('${model.league!.name}'),
            leading: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(10)),
                child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(IconBroken.Arrow___Left)),
              ),
            ),
          ),
          body: Container(
            color: Colors.grey[100],
            child: Column(
              children: [
                SizedBox(
                  height: 220,
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: premierColor,
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20)),
                        ),
                        height: 140,
                      ),
                      Center(child: buildLiveMatchItem(context)),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              children: [
                                Expanded(
                                    child: MaterialButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    cubit.changeMatchDetailsScreen(0);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: cubit.detailsIndex == 0
                                            ? defaultColor
                                            : Colors.grey[200],
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    height: 40,
                                    child: Center(
                                        child: Text(
                                      'Stats',
                                      style: TextStyle(
                                          color: cubit.detailsIndex == 0
                                              ? Colors.white
                                              : Colors.grey[500],
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    )),
                                  ),
                                )),
                                const SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                    child: MaterialButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    cubit.changeMatchDetailsScreen(1);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: cubit.detailsIndex == 1
                                            ? defaultColor
                                            : Colors.grey[200],
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    height: 40,
                                    child: Center(
                                        child: Text(
                                      'Line-Up',
                                      style: TextStyle(
                                          color: cubit.detailsIndex == 1
                                              ? Colors.white
                                              : Colors.grey[500],
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    )),
                                  ),
                                )),
                                const SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                    child: MaterialButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    cubit.changeMatchDetailsScreen(2);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: cubit.detailsIndex == 2
                                            ? defaultColor
                                            : Colors.grey[200],
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    height: 40,
                                    child: Center(
                                        child: Text(
                                      'Events',
                                      style: TextStyle(
                                          color: cubit.detailsIndex == 2
                                              ? Colors.white
                                              : Colors.grey[500],
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    )),
                                  ),
                                )),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (cubit.detailsIndex == 0) ...[
                                  ConditionalBuilder(
                                    condition: cubit.statsModel != null,
                                    builder: (context) {
                                      if (cubit
                                          .statsModel!.response.isNotEmpty) {
                                        return Expanded(
                                          child: ListView.builder(
                                            physics:
                                                const BouncingScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              return buildStatsItem(
                                                  cubit.statsModel!, index);
                                            },
                                            itemCount: cubit.statsModel!
                                                .response[0].statistics!.length,
                                          ),
                                        );
                                      }
                                      return const Center(
                                        child: Text(
                                          'No Stats Available',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      );
                                    },
                                    fallback: (context) => const Center(
                                        child: CircularProgressIndicator()),
                                  ),
                                ] else if (cubit.detailsIndex == 1) ...[
                                  ConditionalBuilder(
                                    condition: true,
                                    builder: (context) {
                                      if (cubit.lineUp!.response.isNotEmpty) {
                                        return Expanded(
                                            child:
                                                buildLineUpItem(cubit.lineUp!));
                                      }
                                      return const Center(
                                        child: Text(
                                          'No Line Up Available',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      );
                                    },
                                    fallback: (context) => const Center(
                                        child: CircularProgressIndicator()),
                                  ),
                                ] else ...[
                                  ConditionalBuilder(
                                    condition: cubit.events != null,
                                    builder: (context) {
                                      if (cubit.events!.response!.isNotEmpty) {
                                        return Expanded(
                                          child: ListView.separated(
                                            physics:
                                                const BouncingScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              return buildEventItem(cubit
                                                  .events!.response![index]);
                                            },
                                            separatorBuilder: (context, index) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 40),
                                                child: Container(
                                                  height: 1,
                                                  width: double.infinity,
                                                  color: Colors.grey[300],
                                                ),
                                              );
                                            },
                                            itemCount:
                                                cubit.events!.response!.length,
                                          ),
                                        );
                                      }
                                      return const Center(
                                        child: Text(
                                          'No Events Available',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      );
                                    },
                                    fallback: (context) => const Center(
                                        child: CircularProgressIndicator()),
                                  ),
                                ]
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildLineUpItem(LineUpModel model) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      '${model.response[0].team!.name} ',
                      style: const TextStyle(fontSize: 15)),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Text(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          '${model.response[0].startXI[index].number} - ${model.response[0].startXI[index].name}');
                    },
                    itemCount: model.response[0].startXI.length,
                  ),
                  Text(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      'Coach : ${model.response[0].coach!.name}'),
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: Colors.grey[300],
                  ),
                  const Text('Substitutes'),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Text(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          '${model.response[0].substitutes[index].number} - ${model.response[0].substitutes[index].name}');
                    },
                    itemCount: model.response[0].substitutes.length,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('${model.response[1].team!.name} ',
                      style: const TextStyle(fontSize: 15)),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Text(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                          '${model.response[1].startXI[index].number} - ${model.response[1].startXI[index].name}');
                    },
                    itemCount: model.response[1].startXI.length,
                  ),
                  Text(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                      'Coach : ${model.response[1].coach!.name}'),
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: Colors.grey[300],
                  ),
                  const Text('Substitutes'),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Text(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                          '${model.response[1].substitutes[index].number} - ${model.response[1].substitutes[index].name}');
                    },
                    itemCount: model.response[1].substitutes.length,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildEventItem(EventModel model) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    const CircleAvatar(
                      maxRadius: 18,
                      backgroundColor: Colors.black,
                    ),
                    if (model.type == "Goal") ...[
                      const Image(
                          height: 37,
                          width: 37,
                          image: AssetImage('assets/images/goal.png')),
                    ] else if (model.type == "subst") ...[
                      const Image(
                          height: 37,
                          width: 37,
                          image: AssetImage('assets/images/subst.png')),
                    ] else ...[
                      const Image(
                          height: 28,
                          width: 28,
                          image: AssetImage('assets/images/card.png')),
                    ],
                  ],
                ),
                Text("${model.time!.elapsed}'")
              ],
            ),
          ),
          if (model.type == "Goal") ...[
            Expanded(
              child: model.assist!.name != null
                  ? Text(
                      'Goal , ${model.team!.name} Scored by ${model.player!.name} Assist ${model.assist!.name}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: const TextStyle(
                        fontSize: 13,
                      ))
                  : Text(
                      'Goal , ${model.team!.name} Scored by ${model.player!.name}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: const TextStyle(
                        fontSize: 13,
                      )),
            ),
          ] else if (model.type == "subst") ...[
            Expanded(
              child: Text(
                  'Subsitution , ${model.team!.name}. ${model.assist!.name} replaces ${model.player!.name}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style: const TextStyle(
                    fontSize: 13,
                  )),
            ),
          ] else ...[
            Expanded(
              child: Text(
                  '${model.detail} for ${model.player!.name} (${model.team!.name}). ',
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: const TextStyle(
                    fontSize: 13,
                  )),
            ),
          ],
        ],
      ),
    );
  }

  Widget buildStatsItem(StatsModel model, index) {
    double first, second;
    if (model.response[1].statistics![index].value!.contains('%') ||
        model.response[0].statistics![index].value!.contains('%')) {
      String s1 = model.response[0].statistics![index].value!;
      String s2 = model.response[1].statistics![index].value!;
      String sub1 = s1.substring(0, s1.length - 1);
      String sub2 = s2.substring(0, s2.length - 1);
      first = double.parse(sub1);
      second = double.parse(sub2);
    } else {
      first = double.parse(model.response[0].statistics![index].value!);
      second = double.parse(model.response[1].statistics![index].value!);
    }
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${model.response[0].statistics![index].value}',
                  style: TextStyle(
                    color: premierColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                  flex: 2,
                  child: Center(
                    child: Text(
                      '${model.response[1].statistics![index].type}',
                      maxLines: 1,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey[700]),
                    ),
                  )),
              Expanded(
                child: Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Text(
                    '${model.response[1].statistics![index].value}',
                    style: TextStyle(
                      color: defaultColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20)),
                    height: 6,
                    child: FractionallySizedBox(
                      widthFactor: (first + second) == 0
                          ? 0
                          : (first / (first + second)),
                      alignment: AlignmentDirectional.centerEnd,
                      child: Container(
                        decoration: BoxDecoration(
                            color: premierColor,
                            borderRadius: BorderRadius.circular(20)),
                        height: 6,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 7,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20)),
                    height: 6,
                    child: FractionallySizedBox(
                      widthFactor: (first + second) == 0
                          ? 0
                          : (second / (first + second)),
                      alignment: AlignmentDirectional.centerStart,
                      child: Container(
                        decoration: BoxDecoration(
                            color: defaultColor,
                            borderRadius: BorderRadius.circular(20)),
                        height: 6,
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildLiveMatchItem(context) {
    return InkWell(
      onTap: () {},
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 4,
        child: Container(
            height: 200,
            width: 320,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Center(
                    child: Column(
                      children: [
                        Text('${model.fixture!.venue!.name}',
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(color: Colors.black, height: 1.1)),
                        const SizedBox(
                          height: 10,
                        ),
                        Text('${model.league!.round}',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    fontSize: 16,
                                    height: 1.1,
                                    color: Colors.grey[500]))
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      buildMatchTeamItem('${model.teams!.home!.logo}',
                          '${model.teams!.home!.name}', 'Home'),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              '${model.goals!.home} : ${model.goals!.away}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 40,
                                  color: Colors.black),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                const CircleAvatar(
                                  backgroundColor: Colors.pinkAccent,
                                ),
                                const CircleAvatar(
                                  radius: 18,
                                  backgroundColor: Colors.white,
                                ),
                                Text(
                                  "${model.fixture!.status!.elapsed}'",
                                  style: const TextStyle(color: Colors.black),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      buildMatchTeamItem('${model.teams!.away!.logo}',
                          '${model.teams!.away!.name}', 'Away'),
                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }

  Widget buildMatchTeamItem(String url, String name, String state) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildImage(url, width: 60, hight: 60),
          const SizedBox(
            height: 10,
          ),
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style:
                const TextStyle(fontSize: 18, color: Colors.black, height: 1.1),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            state,
            style:
                TextStyle(fontSize: 15, color: Colors.grey[500], height: 1.1),
          )
        ],
      ),
    );
  }
}
