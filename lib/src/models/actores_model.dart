
class Cast{
  List<Actor> actores = new List();

  Cast.fromJsonList( List<dynamic> jsonList){
    if(jsonList == null) return;

    jsonList.forEach((item){
      final  actor = Actor.fromJson(item);
      actores.add(actor);
    });
  }

}

class Actor{
  String character;
  String creditId;
  String name;
  String profilePath;
  int castId;
  int gender;
  int id;
  int order;

  Actor({this.character, this.creditId, this.name, this.profilePath, this.castId, this.gender, this.id, this.order});

  Actor.fromJson(Map<String, dynamic> json) {
    this.character = json['character'];
    this.creditId = json['credit_id'];
    this.name = json['name'];
    this.profilePath = json['profile_path'];
    this.castId = json['cast_id'];
    this.gender = json['gender'];
    this.id = json['id'];
    this.order = json['order'];
  }


  getFoto(){
    if(profilePath==null) {
      return 'https://apexturbine.com/wp-content/uploads/2019/07/default_user_icon16-09-201474352760.png';
    }else{
      return 'https://image.tmdb.org/t/p/w500/$profilePath';
    }
  }

}
