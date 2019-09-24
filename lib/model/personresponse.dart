import 'dart:ffi';

class PersonResponse {
  int page;
  List<PersonResult> persons;

  PersonResponse({this.page, this.persons});

  factory PersonResponse.fromJson(Map<String, dynamic> json) {
    return PersonResponse(
        page: json['page'],
        persons: List<PersonResult>.from(
            json["results"].map((x) => PersonResult.fromJson(x))));
  }
}

class PersonResult {
  int actorId;
  String profilePath;
  String name;

  PersonResult({this.actorId, this.profilePath, this.name});

  factory PersonResult.fromJson(Map<String, dynamic> json) {
    return PersonResult(
        actorId: json['id'],
        profilePath: json['profile_path'],
        name: json['name']);
  }
}

class PersonDetail {
  String birthday;
  String deathDay;
  List<String> alsoKnownAs;
  String biography;
  double popularity;
  String placeOfBirth;

  PersonDetail(
      {this.birthday,
      this.deathDay,
      this.alsoKnownAs,
      this.biography,
      this.popularity,
      this.placeOfBirth});

  factory PersonDetail.fromJson(Map<String, dynamic> json) {
    return PersonDetail(
        birthday: json['birthday'],
        deathDay: json['deathday'],
        alsoKnownAs: List<String>.from(json["also_known_as"].map((x) => x)),
        biography: json['biography'],
        popularity: json['popularity'],
        placeOfBirth: json['place_of_birth']);
  }
}
