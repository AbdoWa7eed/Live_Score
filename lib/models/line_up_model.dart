
import 'dart:convert';

import 'package:football_scores/models/events_model.dart';

class LineUpModel
{
  List<LineUpResponse> response = [];
  LineUpModel.fromJson(Map<String , dynamic> json)
  {
    json['response'].forEach((element)
    {
      response.add(LineUpResponse.fromJson(element));
    });
  }
}
class LineUpResponse
{
  Team? team;
  Coach? coach;
  String? formation;
  List<Player> startXI = [];
  List<Player> substitutes = [];
  LineUpResponse.fromJson(Map<String, dynamic> json)
  {
    team = Team.fromJson(json['team']);
    coach = Coach.fromJson(json['coach']);
    formation = json['formation'];
    json['startXI'].forEach((element)
    {
      startXI.add(Player.fromJson(element['player']));
    });
    json['substitutes'].forEach((element)
    {
      substitutes.add(Player.fromJson(element['player']));
    });
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
class Coach
{
  int? id;
  String? name;
  Coach({this.id, this.name});
  Coach.fromJson(Map<String, dynamic> json)
  {
    id = json['id'];
    name = json['name'];
  }
}
class Player
{
  int? id;
  String? name;
  int? number;
  Player({this.id, this.name , this.number});
  Player.fromJson(Map<String, dynamic> json)
  {
    id = json['id'];
    name = json['name'];
    number = json['number'];
  }
}