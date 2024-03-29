import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:http/http.dart';
import 'package:seivom/brain/constants.dart';
import 'package:seivom/ui/actors_detail.dart';

import '../model/personresponse.dart';

class Actors extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Actors();
  }
}

class _Actors extends State<Actors> {
  int nextPage;
  Future<List<PersonResult>> actorsFuture;

  @override
  void initState() {
    nextPage = 1;
    actorsFuture = getPopularPersons(nextPage);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, AsyncSnapshot<List<PersonResult>> snapshot) {
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
            if (snapshot.hasError) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                      child: Text(
                    'It appears you are offline',
                    style: TextStyle(color: Colors.white),
                  )),
                  Center(
                    child: RaisedButton(
                      child: Text('Refresh'),
                      onPressed: refreshData,
                    ),
                  )
                ],
              );
            }
            return PagewiseGridView.count(
              retryBuilder: (context, callback) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                        child: Text(
                      'It appears you are offline',
                      style: TextStyle(color: Colors.white),
                    )),
                    Center(
                      child: RaisedButton(
                        child: Text('Retry to load more'),
                        onPressed: callback,
                      ),
                    ),
                    Center(
                      child: RaisedButton(
                        child: Text('Full refresh'),
                        onPressed: refreshData,
                      ),
                    )
                  ],
                );
              },
              loadingBuilder: (BuildContext context) {
                return Center(
                  child: Container(),
                );
              },
              crossAxisCount: 2,
              pageSize: 20,
              itemBuilder: (context, PersonResult personResult, _) {
                String imageUrl;
                if (personResult.profilePath != null) {
                  imageUrl = API_IMAGE_BASE_URL + personResult.profilePath;
                } else {
                  imageUrl =
                      "https://www.pm10inc.com/wp-content/themes/micron/images/placeholders/placeholder_large_dark.jpg";
                }
                // String imageUrl = API_IMAGE_BASE_URL + personResult.profilePath;
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => new ActorsScreen(imageUrl,
                                personResult.name, personResult.actorId)));
                  },
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                          top: 0,
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Hero(
                              tag: imageUrl + personResult.name,
                              child: FadeInImage(
                                image: NetworkImage(imageUrl),
                                placeholder: AssetImage(
                                    "lib/assets/images/offline_placeholder.jpg"),
                                fit: BoxFit.cover,
                              ))),
                      Positioned(
                          bottom: 5,
                          left: 10,
                          right: 10,
                          child: Container(
                            height: 30,
                            width: double.infinity,
                            alignment: Alignment.topCenter,
                            color: Colors.black.withOpacity(0.7),
                            child: Center(
                              child: Text(
                                personResult.name,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ))
                    ],
                  ),
                );
              },
              pageFuture: (nextPage) => getPopularPersons(nextPage + 1),
            );
        }
        return null;
      },
      future: actorsFuture,
    );
  }

  Future<List<PersonResult>> getPopularPersons(int page) async {
    if (page < 500) {
      var result = await get(API_BASE_URL +
          API_POPULAR_PERSONS +
          API_KEY_KEY +
          "f4efd829c18aaff93d6db6c3ea88bde7" +
          "&page=" +
          page.toString());

      if (result.statusCode == 200) {
        PersonResponse response =
            PersonResponse.fromJson(json.decode(result.body));
        List<PersonResult> listOfPersons = response.persons;
        return listOfPersons;
      }
      throw Exception('Failed to load data');
    } else {
      return null;
    }
  }

  void refreshData() {
    nextPage = 1;
    setState(() {
      actorsFuture = getPopularPersons(nextPage);
    });
  }
}
