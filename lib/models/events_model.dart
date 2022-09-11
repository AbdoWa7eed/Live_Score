class EventResponse
{
  List<EventModel>? response = [];
  EventResponse({this.response});
  EventResponse.fromJson(Map<String , dynamic> json)
  {
    json['response'].forEach((element)
    {
      response!.add(EventModel.fromJson(element));
    });
  }
}
class EventModel
{
  Time? time;
  Team? team;
  Player? player;
  Player? assist;
  String? type;
  String? detail;
  EventModel({this.time , this.type , this.player , this.assist , this.team , this.detail});
  EventModel.fromJson(Map<String , dynamic> json)
  {
    time = Time.fromJson(json['time']);
    team = Team.fromJson(json['team']);
    player = Player.fromJson(json['player']);
    assist = Player.fromJson(json['assist']);
    type = json['type'];
    detail = json['detail'];
  }
}
class Team
{
  int? id;
  String? name;
  Team({this.id , this.name});
  Team.fromJson(Map<String , dynamic> json)
  {
    id = json['id'];
    name = json['name'];
  }
}
class Time
{
  int? elapsed;
  int? extra;
  Time({this.elapsed , this.extra});
  Time.fromJson(Map<String , dynamic> json)
  {
    elapsed = json['elapsed'];
    extra = json['extra'];
  }
}
class Player
{
  int? id;
  String? name;
  Player({this.id , this.name});
  Player.fromJson(Map<String , dynamic> json)
  {
    id = json['id'];
    name = json['name'];
  }
}