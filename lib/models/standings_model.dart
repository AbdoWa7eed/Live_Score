class StandingsResponse {
  List<StandingsLeague> response = [];
  StandingsResponse.fromJson(Map<String, dynamic> json) {
    json['response'].forEach((element) {
      response.add(StandingsLeague.fromJson(element['league']));
    });
  }
}

class StandingsLeague {
  int? id;
  String? name;
  String? country;
  String? logo;
  String? flag;
  int? season;
  List<List<RankInfo>>? standings = [];
  List<RankInfo> list2 = [];
  StandingsLeague(
      {this.id,
      this.name,
      this.country,
      this.logo,
      this.flag,
      this.season,
      this.standings});
  StandingsLeague.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    country = json['country'];
    logo = json['logo'];
    flag = json['flag'];
    season = json['season'];
    json['standings'].forEach((element) {
      list2 = [];
      element.forEach((e) {
        list2.add(RankInfo.fromJson(e));
      });
      standings!.add(list2);
    });
  }
}

class RankInfo {
  int? rank;
  Team? team;
  int? points;
  int? goalsDiff;
  String? group;
  All? all;
  RankInfo(
      {this.team,
      this.all,
      this.goalsDiff,
      this.group,
      this.points,
      this.rank});
  RankInfo.fromJson(Map<String, dynamic> json) {
    rank = json['rank'];
    team = Team.fromJson(json['team']);
    points = json['points'];
    goalsDiff = json['goalsDiff'];
    group = json['group'];
    all = All.fromJson(json['all']);
  }
}

class Team {
  int? id;
  String? name;
  String? logo;
  Team({this.id, this.name, this.logo});
  Team.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    logo = json['logo'];
  }
}

class All {
  int? played;
  int? win;
  int? draw;
  int? lose;
  Goals? goals;
  All({this.goals, this.draw, this.lose, this.played, this.win});
  All.fromJson(Map<String, dynamic> json) {
    played = json['played'];
    win = json['win'];
    draw = json['draw'];
    lose = json['lose'];
    goals = Goals.fromJson(json['goals']);
  }
}

class Goals {
  int? goalFor;
  int? goalAgainst;
  Goals({this.goalFor, this.goalAgainst});
  Goals.fromJson(Map<String, dynamic> json) {
    goalFor = json['for'];
    goalAgainst = json['against'];
  }
}
