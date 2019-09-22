class PersonResponse {
  int page;
  List<PersonResult> persons;

  PersonResponse({this.page, this.persons});

  factory PersonResponse.fromJson(Map<String, dynamic> json) {
    return PersonResponse(page: json['page'], persons: json['results']);
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
