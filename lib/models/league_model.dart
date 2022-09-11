class LeagueModel
{
  List<LeagueResponse> response = [];
  LeagueModel(this.response);
  LeagueModel.fromJson(Map<String , dynamic> json)
  {
    json['response'].forEach((element)
    {
      response.add(LeagueResponse.fromJson(element['league']));
    });
  }
}
class LeagueResponse
{
  int? id;
  String? name;
  String? logo;
  String? country;
  LeagueResponse({this.id , this.name , this.logo , this.country});
  LeagueResponse.fromJson(Map<String , dynamic> json)
  {
    id = json['id'];
    name = json['name'];
    logo = json['logo'];
    country = json['country'];
  }
}