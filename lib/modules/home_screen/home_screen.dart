import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_scores/models/league_model.dart';
import 'package:football_scores/modules/profile_screen/profile_screen.dart';
import 'package:football_scores/modules/search_screen/search_screen.dart';
import 'package:football_scores/shared/components/components.dart';
import 'package:football_scores/shared/components/constants.dart';
import 'package:football_scores/shared/cubit/cubit.dart';
import 'package:football_scores/shared/cubit/states.dart';
import 'package:football_scores/shared/styles/colors/colors.dart';
import 'package:football_scores/shared/styles/icon_broken.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        var cubit = AppCubit.get(context);
        if (state is AppGetMatchesErrorState ||
            state is AppGetLeaguesErrorState) {
          cubit.isError = true;
        }

        if (state is AppGetMatchesSuccessState ||
            state is AppGetLeaguesSuccessState) {
          cubit.isError = false;
        }
      },
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return ConditionalBuilder(
          condition: userModel != null,
          builder: (context) {
            return Scaffold(
              appBar: AppBar(
                leading: InkWell(
                  onTap: () {
                    navigateTo(context, ProfileScreen());
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: CircleAvatar(
                        child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: buildImage(userModel!.image ?? "",
                          width: 40, hight: 40),
                    )),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                          onPressed: () {
                            showSearch(
                                context: context, delegate: SearchScreen());
                          },
                          icon: const Icon(IconBroken.Search),
                          color: Colors.grey[700]),
                    ),
                  )
                ],
                centerTitle: true,
                title: const Image(
                  image: AssetImage('assets/images/home_logo.png'),
                  height: 50,
                  width: 150,
                ),
              ),
              body: ConditionalBuilder(
                condition: !cubit.isError,
                builder: (context) {
                  return Container(
                      height: double.infinity,
                      color: Colors.grey[100],
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SingleChildScrollView(
                          physics: state is! AppGetMatchesLoadingState
                              ? const BouncingScrollPhysics()
                              : const NeverScrollableScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 65,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ListView.builder(
                                        physics: const BouncingScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return biuldTabItem(cubit,
                                              cubit.leagues[index], index);
                                        },
                                        itemCount: cubit.leagues.length,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Center(
                                child: ConditionalBuilder(
                                  condition:
                                      state is! AppGetMatchesLoadingState,
                                  builder: (context) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Live Matches',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.grey[700],
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        SizedBox(
                                          height: 220,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                  child: ConditionalBuilder(
                                                condition: cubit
                                                    .liveMatches.isNotEmpty,
                                                builder: (context) {
                                                  return ListView.separated(
                                                      physics:
                                                          const BouncingScrollPhysics(),
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return buildLiveMatchItem(
                                                            cubit,
                                                            context,
                                                            cubit.liveMatches[
                                                                index]);
                                                      },
                                                      separatorBuilder:
                                                          (context, index) {
                                                        return const SizedBox(
                                                          width: 10,
                                                        );
                                                      },
                                                      itemCount: cubit
                                                          .liveMatches.length);
                                                },
                                                fallback: (context) {
                                                  return const Center(
                                                    child: SizedBox(
                                                      child: Text(
                                                        'No Live Matches',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 25,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ))
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          'Matches',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.grey[700],
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        ConditionalBuilder(
                                          condition: cubit.nsMatches.isNotEmpty,
                                          builder: (context) {
                                            return ListView.separated(
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemBuilder: (context, index) {
                                                  return buildMatchItem(
                                                      cubit,
                                                      cubit.nsMatches[index],
                                                      index,
                                                      context);
                                                },
                                                separatorBuilder:
                                                    (context, index) {
                                                  return const SizedBox(
                                                    height: 10,
                                                  );
                                                },
                                                itemCount:
                                                    cubit.nsMatches.length);
                                          },
                                          fallback: (context) {
                                            return const Center(
                                              child: Text(
                                                textAlign: TextAlign.center,
                                                'No Matches',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 25,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                  fallback: (context) => const Center(
                                      child: CircularProgressIndicator()),
                                ),
                              )
                            ],
                          ),
                        ),
                      ));
                },
                fallback: (context) {
                  return buildErrorWidget(state, cubit, context);
                },
              ),
            );
          },
          fallback: (context) =>
              const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget buildErrorWidget(AppStates state, AppCubit cubit, context) {
    return Scaffold(
        body: Container(
      color: Colors.grey[100],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Unexpected error occurred',
                  style: TextStyle(
                    fontSize: 20,
                  )),
              const SizedBox(
                height: 10,
              ),
              MaterialButton(
                onPressed: () {
                  cubit.getLeagues();
                  cubit.getMatches(39);
                },
                color: premierColor,
                padding: EdgeInsets.zero,
                child:
                    const Text('Retry', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Widget biuldTabItem(AppCubit cubit, LeagueResponse league, int index) {
    Color tabColor = index == cubit.tabIndex ? Colors.white : Colors.grey;
    Color itemColor =
        index == cubit.tabIndex ? Colors.pinkAccent : Colors.white;
    return InkWell(
      onTap: () {
        cubit.changeTabIndex(index);
        cubit.getMatches(league.id!);
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0, bottom: 10, right: 10),
        child: Container(
          decoration: BoxDecoration(
              color: itemColor, borderRadius: BorderRadius.circular(30)),
          height: 45,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                buildImage('${league.logo}',
                    width: 30, hight: 25, fit: BoxFit.contain),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  '${league.name}',
                  style: TextStyle(
                    color: tabColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
