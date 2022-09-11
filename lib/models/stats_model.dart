

class StatsModel
{
  List<Statistics> response = [];
  StatsModel(this.response);
  StatsModel.fromJson(Map<String , dynamic> json)
  {
    json['response'].forEach((element)
    {
      response.add(Statistics.fromJson(element));
    });
  }
}

class Statistics
{
  Team? team;
  List<StatsKind>? statistics = [];
  Statistics({this.team , this.statistics});
  Statistics.fromJson(Map<String , dynamic> json)
  {
    team = Team.fromJson(json['team']);
    json['statistics'].forEach((element)
    {
      statistics?.add(StatsKind.fromJson(element));
    });
  }
}
class Team
{
  int? id;
  String? name;
  String? logo;
  Team({this.id , this.name , this.logo});
  Team.fromJson(Map<String , dynamic> json)
  {
    id = json['id'];
    name = json['name'];
    logo = json['logo'];
  }
}
class StatsKind
{
  String? type;
  String? value;
  StatsKind({this.type , this.value});
  StatsKind.fromJson(Map<String , dynamic> json)
  {
     type = json['type'];
     json['value'] != null ? value = json['value'].toString() : value = '0';
  }
}