import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
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
    return Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: <Widget>[
            MovieCell(
                API_BASE_URL +
                    API_POPULAR_MOVIES +
                    API_KEY_KEY +
                    "f4efd829c18aaff93d6db6c3ea88bde7",
                "Popular Movies"),
          ],
        ),
      )
    ]);
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
            return Center(
                child: Text(
              'No connection',
              style: TextStyle(color: Colors.white),
            ));
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            );
          case ConnectionState.done:
            if (snapshot.hasError)
              return Center(
                  child: Text(
                "${snapshot.error}",
                style: TextStyle(color: Colors.white),
              ));
            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    categoryName,
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Center(
                  child: SizedBox(
                    height: 400,
                    child: PagewiseListView(
                      scrollDirection: Axis.horizontal,
                      pageSize: 20,
                      pageFuture: (pageIndex) => getMovies(pageIndex + 1),
                      itemBuilder: (BuildContext context, MovieResult movieResult,
                          int index) {
                        String imageUrl;
                        if (movieResult.posterPath != null) {
                          imageUrl = API_IMAGE_BASE_URL + movieResult.posterPath;
                        } else {
                          imageUrl =
                              "http://gbaproducts.com/wp-content/uploads/2017/11/img-placeholder-dark-vertical.jpg";
                        }
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              Hero(
                                  tag: imageUrl + movieResult.title,
                                  child: FadeInImage(
                                    width: 150,
                                    height: 300,
                                    image: NetworkImage(imageUrl),
                                    placeholder: AssetImage(
                                        "lib/assets/images/movie_dark_placeholder.jpg"),
                                    fit: BoxFit.cover,
                                  )),
                              Center(
                                child: Container(
                                  width: 150,
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      movieResult.title,
                                      maxLines: 2,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
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
      var result = await get(url + "&page=" + page.toString());
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
