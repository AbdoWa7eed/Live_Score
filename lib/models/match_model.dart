

class MatchModel
{
  List<Response> response = [];
  MatchModel(this.response);
  MatchModel.fromJson(Map<String , dynamic> json)
  {
    json['response'].forEach((element)
    {
        response.add(Response.fromJson(element));
    });
  }
}
class Response
{
  Fixtures? fixture;
  League? league;
  Teams? teams;
  Goals? goals;
  Response({this.fixture , this.league, this.teams , this.goals});
   Response.fromJson(Map<String , dynamic> json)
  {
  fixture = json['fixture'] != null ? Fixtures.fromJson(json['fixture']) : null;
  league = json['league'] != null ? League.fromJson(json['league']) : null;
  teams = json['teams'] != null ? Teams.fromJson(json['teams']) : null;
  goals = json['goals'] != null ? Goals.fromJson(json['goals']) : null;
  }
}
class Fixtures
{
  int? id;
  String? referee;
  String? date;
  String? time;
  Venue? venue;
  Status? status;
  Fixtures({this.id , this.referee, this.date, this.venue , this.status});
  Fixtures.fromJson(Map<String , dynamic> json)
  {
    id = json['id'];
    referee = json['referee'];
    date = json['date'];
    venue = json['venue'] != null ? Venue.fromJson(json['venue']) : null;
    status = json['status'] != null ? Status.fromJson(json['status']) : null;
  }
}
class Venue
{
  int? id;
  String? name;
  String? city;
  Venue({this.id , this.name , this.city});
  Venue.fromJson(Map<String , dynamic> json)
  {
    id = json['id'];
    name = json['name'];
    city = json['city'];
  }
}
class Status
{
    String? short;
    int? elapsed;
    Status({this.short , this.elapsed});
    Status.fromJson(Map<String , dynamic> json)
    {
      short = json['short'];
      elapsed = json['elapsed'];
    }
}
class League
{
  int? id;
  String? name;
  String? logo;
  String? round;
  League({this.id , this.name , this.logo , this.round});
  League.fromJson(Map<String , dynamic> json)
  {
    id = json['id'];
    name = json['name'];
    logo = json['logo'];
    round = json['round'];
  }
}
class Teams
{
  Home? home;
  Away? away;
  Teams({this.home , this.away});
  Teams.fromJson(Map<String , dynamic> json)
  {
    home = json['home'] != null ?  Home.fromJson(json['home']) : null;
    away = json['away'] != null ?  Away.fromJson(json['away']) : null;
  }

}
class Home
{
  int? id;
  String? name;
  String? logo;
  Home({this.id , this.name , this.logo});
  Home.fromJson(Map<String , dynamic> json)
  {
    id = json['id'];
    name = json['name'];
    logo = json['logo'];
  }
}
class Away
{
  int? id;
  String? name;
  String? logo;
  Away({this.id , this.name , this.logo});
  Away.fromJson(Map<String , dynamic> json)
  {
    id = json['id'];
    name = json['name'];
    logo = json['logo'];
  }
}
class Goals
{
  int? home;
  int? away;
  Goals({this.home , this.away});
  Goals.fromJson(Map<String , dynamic> json)
  {
    home  = json['home'];
    away = json['away'];
  }
}

