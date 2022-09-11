
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_scores/models/events_model.dart';
import 'package:football_scores/models/league_model.dart';
import 'package:football_scores/models/line_up_model.dart';
import 'package:football_scores/models/match_model.dart';
import 'package:football_scores/models/standings_model.dart';
import 'package:football_scores/models/stats_model.dart';
import 'package:football_scores/models/user_model.dart';
import 'package:football_scores/shared/components/constants.dart';
import 'package:football_scores/shared/cubit/states.dart';
import 'package:football_scores/shared/network/end_points.dart';
import 'package:football_scores/shared/network/remote/dio_helper.dart';
import 'package:football_scores/shared/styles/icon_broken.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppIntialState());

  static AppCubit get(context) => BlocProvider.of(context);
  int tabIndex = 0;
  int MatchIndex = 0;
  int detailsIndex = 0;
  MatchModel? matchModel;
  List<Response> NSMatches = [];
  List<Response> liveMatches = [];
  List<Response> nsSearchedMatches = [];
  List<Response> searchedLiveMatches = [];

  void changeTabIndex(index) {
    tabIndex = index;
    emit(AppChangeTabItemState());
  }

  void changeMatchIndex(index) {
    MatchIndex = index;
    emit(AppChangeMatchIndexState());
  }

  void changeMatchDetailsScreen(index) {
    detailsIndex = index;
    emit(AppChangeMatchDetailsState());
  }

  String formatTime(Response model) {
    String dateTime = model.fixture!.date!;
    String Time = dateTime.substring(
        dateTime.indexOf('T') + 1, dateTime.indexOf('T') + 6);
    return Time;
  }

  String formatDate(Response model) {
    String dateTime = model.fixture!.date!;
    String Sdate = dateTime.substring(0, dateTime.indexOf('T'));
    String? dateFormat = DateFormat('d MMM')
        .format(DateTime.parse(Sdate))
        .toUpperCase();
    return dateFormat;
  }

  Future<void> getMatches(int leagueID, {bool isSearch = false}) async
  {
    NSMatches = [];
    liveMatches = [];
    nsSearchedMatches = [];
    searchedLiveMatches = [];
    emit(AppGetMatchesLoadingState());
    String? round;
    DioHelper.getData(url: ROUNDS, query: {
      'league': leagueID,
      'season': 2022,
      'current': true
    }).then((value) {
      print(value.data);
      round = value.data['response'][0];
      if(value.data['response'].length > 1 )
       {
         for(int i = 0 ; i < value.data['response'].length ; i++ )
           {
             DioHelper.getData(url: FIXTURES, query: {
               'league': leagueID,
               'season': 2022,
               'round': value.data['response'][i],
               'timezone': 'Africa/Cairo',
             }).then((value) {
               matchModel = MatchModel.fromJson(value.data);
               matchModel?.response.forEach((element) {
                 if (isSearch) {
                   if (element.fixture?.status?.short == 'NS') {
                     nsSearchedMatches.add(element);
                   } else if (element.fixture?.status?.short == '1H' ||
                       element.fixture?.status?.short == '2H' ||
                       element.fixture?.status?.short == 'HT') {
                     searchedLiveMatches.add(element);
                   }
                 }
                 else {
                   if (element.fixture?.status?.short == 'NS') {
                     NSMatches.add(element);
                   } else if (element.fixture?.status?.short == '1H' ||
                       element.fixture?.status?.short == '2H' ||
                       element.fixture?.status?.short == 'HT') {
                     liveMatches.add(element);
                   }
                 }
               });
               NSMatches.sort((a, b) => a.fixture!.date!.compareTo(b.fixture!.date!),);
               if(nsSearchedMatches.isNotEmpty)
               {
                 nsSearchedMatches.sort((a, b) => a.fixture!.date!.compareTo(b.fixture!.date!),);
               }
               if(i  == value.data['response'].length-1)
               {
                 emit(AppGetMatchesSuccessState());
               }
               else
                {
                  emit(AppGetMultiMatchesSuccessState());
                }
             }).catchError((onError) {
               print('Error While Getting  : $onError');
               emit(AppGetMultiMatchesErrorState());
             });
           }

       }
      else{
        DioHelper.getData(url: FIXTURES, query: {
          'league': leagueID,
          'season': 2022,
          'round': round,
          'timezone': 'Africa/Cairo',
        }).then((value) {
          matchModel = MatchModel.fromJson(value.data);
          matchModel?.response.forEach((element) {
            if (isSearch) {
              if (element.fixture?.status?.short == 'NS') {
                nsSearchedMatches.add(element);
              } else if (element.fixture?.status?.short == '1H' ||
                  element.fixture?.status?.short == '2H' ||
                  element.fixture?.status?.short == 'HT') {
                searchedLiveMatches.add(element);
              }
            }
            else {
              if (element.fixture?.status?.short == 'NS') {
                NSMatches.add(element);
              } else if (element.fixture?.status?.short == '1H' ||
                  element.fixture?.status?.short == '2H' ||
                  element.fixture?.status?.short == 'HT') {
                liveMatches.add(element);
              }
            }
          });
          NSMatches.sort((a, b) => a.fixture!.date!.compareTo(b.fixture!.date!),);
          if(nsSearchedMatches.isNotEmpty)
          {
            nsSearchedMatches.sort((a, b) => a.fixture!.date!.compareTo(b.fixture!.date!),);
          }
          emit(AppGetMatchesSuccessState());
        }).catchError((onError) {
          print('Error While Getting  : $onError');
          emit(AppGetMatchesErrorState());
        });
      }

    }
        ).catchError((onError) {
      print('Error While Round  : $onError');
      emit(AppGetMatchesErrorState());
    });
  }

  MatchModel? liveMatch;

  void getLiveMatch() {
    DioHelper.getData(url: FIXTURES, query: {
      'live': 'all',
      'id': 946856,
      'timezone': 'Africa/Cairo',
    }).then((value) {
      liveMatch = MatchModel.fromJson(value.data);
      liveMatches.add(liveMatch!.response[0]);
      emit(AppGetMatchesSuccessState());
    }).catchError((onError) {
      print('Error While Getting  : $onError');
      emit(AppGetMatchesErrorState());
    });
  }

  List<LeagueResponse> leagues = [];
  LeagueModel? league;

  Future<void> getLeagues() async {
    emit(AppGetLeaguesLoadingState());
    DioHelper.getData(url: LEAGUES,
        query: {
          'season': 2022
        }).then((value) {
      league = LeagueModel.fromJson(value.data);
      print(league?.response[0].id);
      league?.response.forEach((element) {
        if (element.id == 39 || element.id == 140 || element.id == 78 ||
            element.id == 135 || element.id == 61) {
          leagues.add(element);
        }
      });
      print(leagues);
      emit(AppGetLeaguesSuccessState());
    }).catchError((onError) {
      print('Error While Getting leagues : $onError');
      emit(AppGetLeaguesErrorState());
    });
  }

  EventResponse? events;

  Future<void> getEvents(int fixtureId) async
  {
    emit(AppGetEventsLoadingState());
    DioHelper.getData(url: Events,
        query: {
          'fixture': fixtureId
        }).then((value) {
      events = EventResponse.fromJson(value.data);
      emit(AppGetEventsSuccessState());
    }).catchError((onError) {
      print('Error While Getting leagues : $onError');
      emit(AppGetEventsErrorState());
    });
  }

  LeagueModel? search;

  void getSaerchedLeague(String name) {
    search = null;
    emit(AppGetLeaguesLoadingState());
    DioHelper.getData(url: LEAGUES,
        query: {
          'season': 2022,
          'name': name
        }).then((value) {
      print('Done');
      print(value.data['response']);
      search = LeagueModel.fromJson(value.data);
      print(search?.response.length);
      emit(AppGetLeaguesSuccessState());
    }).catchError((onError) {
      print('Error While Getting leagues : $onError');
      emit(AppGetLeaguesErrorState());
    });
  }

  StatsModel? statsModel;

  Future<void> getStats(int fixtureID) async {
    emit(AppGetStatsLoadingState());
    DioHelper.getData(url: Stats, query: {
      'fixture': fixtureID
    }).then((value) {
      statsModel = StatsModel.fromJson(value.data);
      emit(AppGetStatsSuccessState());
    }).catchError((onError) {
      print('Error While getting stats : $onError');
      emit(AppGetStatsErrorState());
    });
  }

  LineUpModel? lineUp;

  Future<void> getLineUp(int fixtureID) async {
    emit(AppGetLineUpLoadingState());
    DioHelper.getData(url: LINE_UP, query: {
      'fixture': fixtureID
    }).then((value) {
      print(value.data);
      lineUp = LineUpModel.fromJson(value.data);
      print(lineUp!.response[0]);
      emit(AppGetLineUpSuccessState());
    }).catchError((onError) {
      print('Error While getting Line Up : $onError');
      emit(AppGetLineUpErrorState());
    });
  }

  StandingsResponse? standings;

  Future<void> getStandings(int leagueID) async {
    emit(AppGetStandingsLoadingState());
    DioHelper.getData(url: STANDINGS, query: {
      'league': leagueID,
      'season': 2022,
    }).then((value) {
      print(value.data);
      standings = StandingsResponse.fromJson(value.data);
      print(standings!.response[0].standings![0][0].all!.goals!.GA);
      emit(AppGetStandingsSuccessState());
    }).catchError((onError) {
      print('Error While getting Standings : $onError');
      emit(AppGetStandingsErrorState());
    });
  }

  Future<void> getUserData(uid) async {
    emit(GetUserLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uid).get().then((value) {
      print(uid);
      value.data() != null
          ? userModel = UserModel.fromjson(value.data()!)
          : userModel = null;
      print(userModel);
      emit(GetUserSuccessState());
    }).catchError((onError) {
      print('Error While Getting : ${onError}');
      GetUserErrorState(onError.toString());
    });
  }

  final ImagePicker _image = ImagePicker();
  XFile? image;
  File? myImage;

  void getImage() async
  {
    image = await _image.pickImage(source: ImageSource.gallery);
    myImage = File(image!.path);
    print(myImage!.path);
    emit(GetImageState());
  }

  void updateData({
    String? name,
    String? email,
    String? image,
  }) async
  {
    UserModel model;
    String? path;
    emit(UpdateUserLoadingState());
    if(image == null)
    {
       model = UserModel(
          image: image??userModel!.image,
          email: email??userModel!.email,
          name: name??userModel!.name,
          uid: userModel!.uid
      );
       FirebaseFirestore.instance.collection('users').doc(userModel!.uid).update(model.toMap())
           .then((value) async
       {
         print("path2651451 : $path");
         emit(UpdateUserSuccessState());
         await FirebaseAuth.instance.currentUser!.updateEmail(model.email!).then((value)
         {
           FirebaseAuth.instance.currentUser!.updateDisplayName(model.name!).then((value){
             getUserData(userModel!.uid);
           });
         });
       }).catchError((onError)
       {
         print('Error While Updating : $onError');
         emit(UpdateUserErrorState(onError.toString()));
       });
    }
    else
    {
     await FirebaseStorage.instance.ref('users/images/${Uri.file(image)
          .pathSegments.last}').putFile(myImage!).then((value)
      {
         value.ref.getDownloadURL().then((value)
        {
            path = value;
            model = UserModel(
                image: path,
                email: email??userModel!.email,
                name: name??userModel!.name,
                uid: userModel!.uid
            );
            FirebaseFirestore.instance.collection('users').doc(userModel!.uid).update(model.toMap())
                .then((value) async
            {
              emit(UpdateUserSuccessState());
             await FirebaseAuth.instance.currentUser!.updateEmail(model.email!).then((value)
              {
                  FirebaseAuth.instance.currentUser!.updateDisplayName(model.name!).then((value){
                    getUserData(userModel!.uid);
                });
              });
            }).catchError((onError)
            {
              print('Error While Updating : $onError');
              emit(UpdateUserErrorState(onError.toString()));
            });
        }).catchError((onError)
         {
           print('Error While getting url : $onError');
         });
      }).catchError((onError)
      {
        print('Error while Uploading image : $onError');
      });

    }

  }

}

/*

 */