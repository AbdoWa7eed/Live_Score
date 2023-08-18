


class UserModel
{
  String? name;
  String? email;
  String? image;
  String? uid;
  UserModel({
    this.name,
    this.image,
    this.email,
    this.uid,
  });
  UserModel.fromjson(Map<String , dynamic> json)
  {
    email = json['email'];
    image = json['image'];
    name = json['name'];
    uid = json['uid'];
  }
  Map<String , dynamic> toMap()
  {
    return {
      'name' : name,
      'image' : image,
      'email' : email,
      'uid' : uid
    };
  }
}