import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:seivom/brain/constants.dart';
import 'package:seivom/model/personresponse.dart';

class ActorsDetails extends StatelessWidget {
  String imageUrl;
  String name;
  int id;

  ActorsDetails(this.imageUrl, this.name, this.id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.black,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Colors.black,
              pinned: true,
              expandedHeight: 500,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  name,
                  style: TextStyle(
                      letterSpacing: 1,
                      backgroundColor: Colors.black.withOpacity(0.7)),
                ),
                background: Hero(
                  tag: imageUrl + name,
                  child: FadeInImage(
                    image: NetworkImage(imageUrl),
                    placeholder:
                        AssetImage("lib/assets/images/offline_placeholder.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SliverFillRemaining(
                child: FutureBuilder(
              future: getActorsDetail(),
              builder: (context, AsyncSnapshot<PersonDetail> snapShot) {
                switch (snapShot.connectionState) {
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
                    ));
                  case ConnectionState.done:
                    if (snapShot.hasError)
                      return Center(
                          child: Text(
                        'Error in connection',
                        style: TextStyle(color: Colors.white),
                      ));
                    return Column(
                      children: <Widget>[
                        SizedBox(
                          height: 50,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: snapShot.data.alsoKnownAs.length,
                              itemBuilder: (context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Chip(
                                    label:
                                        Text(snapShot.data.alsoKnownAs[index]),
                                  ),
                                );
                              }),
                        ),
                        SizedBox(
                          height: 100,
                          child: Table(
                            children: <TableRow>[
                              TableRow(children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    "Birthday",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    snapShot.data.birthday.toString(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              ]),
                              TableRow(children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    "Birthplace",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    snapShot.data.placeOfBirth.toString(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              ]),
                              TableRow(children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    "Birthday",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    snapShot.data.birthday,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              ]),
                            ],
                          ),
                        ),
                        Expanded(
                            child: SizedBox(
                          height: 100,
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                snapShot.data.biography.toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ))
                      ],
                    );
                }
                return null;
              },
            ))
          ],
        ));
  }

  Future<PersonDetail> getActorsDetail() async {
    var result = await get(API_BASE_URL +
        API_SINGLE_PERSON +
        id.toString() +
        API_KEY_KEY +
        "f4efd829c18aaff93d6db6c3ea88bde7");

    if (result.statusCode == 200) {
      PersonDetail personDetail =
          PersonDetail.fromJson(json.decode(result.body));
      return personDetail;
    } else {
      throw Exception("Failed to load data");
    }
  }
}

//Future<List<PersonResult>> getPopularPersons() async {
//  if (page < 500) {
//    var result = await get(API_BASE_URL +
//        API_POPULAR_PERSONS +
//        API_KEY_KEY +
//        "f4efd829c18aaff93d6db6c3ea88bde7&page=" +
//        "&page=" +
//        page.toString());
//
//    if (result.statusCode == 200) {
//      PersonResponse response =
//      PersonResponse.fromJson(json.decode(result.body));
//      List<PersonResult> listOfPersons = response.persons;
//      return listOfPersons;
//    }
//    throw Exception('Failed to load data');
//  } else {
//    return null;
//  }
//}
