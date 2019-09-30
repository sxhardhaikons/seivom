import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart';
import 'package:seivom/brain/constants.dart';
import 'package:seivom/model/movie_response.dart';

class Movies extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Movies();
  }
}

class _Movies extends State<Movies> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            MovieCell(
                API_BASE_URL +
                    API_POPULAR_MOVIES +
                    API_KEY_KEY +
                    "f4efd829c18aaff93d6db6c3ea88bde7",
                "Popular Movies"),
            MovieCell(
                API_BASE_URL +
                    API_TOP_RATED_MOVIES +
                    API_KEY_KEY +
                    "f4efd829c18aaff93d6db6c3ea88bde7",
                "Top rated"),
            MovieCell(
                API_BASE_URL +
                    API_UPCOMING_MOVIES +
                    API_KEY_KEY +
                    "f4efd829c18aaff93d6db6c3ea88bde7",
                "Upcoming"),
            MovieCell(
                API_BASE_URL +
                    API_NOW_PLAYING_MOVIES +
                    API_KEY_KEY +
                    "f4efd829c18aaff93d6db6c3ea88bde7",
                "Now playing")
          ],
        ),
      ),
    );
  }
}

class MovieCell extends StatelessWidget {
  String url;
  String categoryName;
  int currentPage = 1;

  MovieCell(this.url, this.categoryName);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getMovies(currentPage),
      builder: (context, AsyncSnapshot<List<MovieResult>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 280,
                child: ListView.builder(
                    itemCount: 10,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FadeInImage(
                          width: 100,
                          height: 200,
                          placeholder: AssetImage(
                              "lib/assets/images/movie_dark_placeholder.jpg"),
                          fit: BoxFit.cover,
                          image: AssetImage(
                              "lib/assets/images/movie_dark_placeholder.jpg"),
                        ),
                      );
                    }),
              ),
            );
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 280,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 10,
                    itemBuilder: (context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FadeInImage(
                          width: 100,
                          height: 200,
                          placeholder: AssetImage(
                              "lib/assets/images/movie_dark_placeholder.jpg"),
                          fit: BoxFit.cover,
                          image: AssetImage(
                              "lib/assets/images/movie_dark_placeholder.jpg"),
                        ),
                      );
                    }),
              ),
            );
          case ConnectionState.done:
            if (snapshot.hasError)
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 280,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 10,
                      itemBuilder: (context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FadeInImage(
                            width: 100,
                            height: 200,
                            placeholder: AssetImage(
                                "lib/assets/images/movie_dark_placeholder.jpg"),
                            fit: BoxFit.cover,
                            image: AssetImage(
                                "lib/assets/images/movie_dark_placeholder.jpg"),
                          ),
                        );
                      }),
                ),
              );
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, top: 16.0, bottom: 8.0, right: 8.0),
                  child: Text(
                    categoryName,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                SizedBox(
                  height: 280,
                  child: ListView.builder(
                    itemCount: snapshot.data.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, int index) {
                      String imageUrl;
                      if (snapshot.data[index].posterPath != null) {
                        imageUrl = API_IMAGE_BASE_URL +
                            snapshot.data[index].posterPath;
                      } else {
                        imageUrl =
                            "http://gbaproducts.com/wp-content/uploads/2017/11/img-placeholder-dark-vertical.jpg";
                      }
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Hero(
                                tag: imageUrl + snapshot.data[index].title,
                                child: FadeInImage(
                                  width: 100,
                                  height: 200,
                                  image: NetworkImage(imageUrl),
                                  placeholder: AssetImage(
                                      "lib/assets/images/movie_dark_placeholder.jpg"),
                                  fit: BoxFit.cover,
                                )),
                            Container(
                              width: 100,
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  snapshot.data[index].title,
                                  maxLines: 2,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                )
              ],
            );
        }
        return null;
      },
    );
  }

  Future<List<MovieResult>> getMovies(int page) async {
    if (page < 500) {
      var result = await get(url);
      if (result.statusCode == 200) {
        PopularMoviesResponse response =
            PopularMoviesResponse.fromJson(json.decode(result.body));
        List<MovieResult> listOfMovies = response.movies;
        return listOfMovies;
      }
      throw Exception('Failed to load data');
    } else {
      return null;
    }
  }
}
