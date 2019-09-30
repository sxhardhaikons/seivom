class PopularMoviesResponse {
  int page;
  List<MovieResult> movies;

  PopularMoviesResponse({this.page, this.movies});

  factory PopularMoviesResponse.fromJson(Map<String, dynamic> json) {
    return PopularMoviesResponse(
        page: json['page'],
        movies: List<MovieResult>.from(
            json['results'].map((x) => MovieResult.fromJson(x))));
  }
}

class MovieResult {
  String posterPath;
  int id;
  String originalLanguage;
  String title;
  dynamic voteAverage;
  String overView;
  String releaseDate;

  MovieResult({this.posterPath, this.id, this.title,
    this.voteAverage, this.overView, this.releaseDate, this.originalLanguage});

  factory MovieResult.fromJson(Map<String, dynamic> json){
    return MovieResult(
        posterPath: json['poster_path'],
        id: json['id'],
        originalLanguage: json['original_language'],
        title: json['title'],
        voteAverage: json['vote_average'],
        overView: json['overview'],
        releaseDate: json['release_date']
    );
  }
}
