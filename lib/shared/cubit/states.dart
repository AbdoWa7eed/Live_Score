abstract class AppStates {}

class AppIntialState extends AppStates {}
class AppChangeTabItemState extends AppStates {}
class AppChangeMatchIndexState extends AppStates {}
class AppChangeMatchDetailsState extends AppStates {}
class AppGetMatchesLoadingState  extends AppStates {}
class AppGetMatchesSuccessState  extends AppStates {}
class AppGetMatchesErrorState  extends AppStates {}
class AppGetMultiMatchesSuccessState  extends AppStates {}
class AppGetMultiMatchesErrorState  extends AppStates {}
class AppGetLeaguesLoadingState  extends AppStates {}
class AppGetLeaguesSuccessState  extends AppStates {}
class AppGetLeaguesErrorState  extends AppStates {}
class AppGetEventsLoadingState  extends AppStates {}
class AppGetEventsSuccessState  extends AppStates {}
class AppGetEventsErrorState  extends AppStates {}
class AppGetStatsLoadingState  extends AppStates {}
class AppGetStatsSuccessState  extends AppStates {}
class AppGetStatsErrorState  extends AppStates {}
class AppGetLineUpLoadingState  extends AppStates {}
class AppGetLineUpSuccessState  extends AppStates {}
class AppGetLineUpErrorState  extends AppStates {}
class AppGetStandingsLoadingState  extends AppStates {}
class AppGetStandingsSuccessState  extends AppStates {}
class AppGetStandingsErrorState  extends AppStates {}
class GetUserLoadingState extends AppStates {}
class GetUserSuccessState extends AppStates {}
class GetUserErrorState extends AppStates {
  String? error;
  GetUserErrorState(this.error);
}
class UpdateUserLoadingState extends AppStates {}
class UpdateUserSuccessState extends AppStates {}
class UpdateUserErrorState extends AppStates {
  String? error;

  UpdateUserErrorState(this.error);
}
class GetImageState  extends AppStates {}
