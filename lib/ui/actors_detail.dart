import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:http/http.dart';
import 'package:seivom/brain/constants.dart';
import 'package:seivom/model/personresponse.dart';

class ActorsScreen extends StatelessWidget {
  String imageUrl;
  String name;
  int id;

  ActorsScreen(this.imageUrl, this.name, this.id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomPadding: true,
      body: ActorsDetails(imageUrl, name, id),
    );
  }
}

class ActorsDetails extends StatelessWidget {
  String imageUrl;
  String name;
  int id;
  StreamController<String> _biographyEvent = StreamController<String>();

  ActorsDetails(this.imageUrl, this.name, this.id);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          backgroundColor: Colors.black,
          pinned: true,
          expandedHeight: 620,
          flexibleSpace: FlexibleSpaceBar(
              background: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 72.0),
                child: Hero(
                  tag: imageUrl + name,
                  child: CircleAvatar(
                    radius: 100,
                    backgroundImage: NetworkImage(imageUrl),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: FutureBuilder(
                  future: getActorsDetail(),
                  builder: (context, AsyncSnapshot<PersonDetail> snapshot) {
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
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        );
                      case ConnectionState.done:
                        if (snapshot.hasError)
                          return Center(
                              child: Text(
                            'Error in connection',
                            style: TextStyle(color: Colors.white),
                          ));
                        _biographyEvent.add(snapshot.data.biography);
                        return Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: 50,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: snapshot.data.alsoKnownAs.length,
                                    itemBuilder: (context, int index) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: Chip(
                                          label: Text(
                                              snapshot.data.alsoKnownAs[index]),
                                        ),
                                      );
                                    }),
                              ),
                            ),
                            SizedBox(
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Table(
                                    children: <TableRow>[
                                      TableRow(children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text(
                                            "Birthday",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text(
                                            snapshot.data.birthday == null
                                                ? 'N/A'
                                                : snapshot.data.birthday,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        )
                                      ]),
                                      TableRow(children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text(
                                            "Birthplace",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text(
                                            snapshot.data.placeOfBirth == null
                                                ? 'N/A'
                                                : snapshot.data.placeOfBirth,
                                            style:
                                                TextStyle(color: Colors.white),
                                            maxLines: 2,
                                          ),
                                        )
                                      ]),
                                      TableRow(children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text(
                                            "Death Day",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text(
                                            snapshot.data.deathDay == null
                                                ? 'N/A'
                                                : snapshot.data.deathDay,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        )
                                      ]),
                                      TableRow(children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 4.0,
                                              right: 4.0,
                                              top: 48.0,
                                              left: 4.0),
                                          child: Text(
                                            "Popularity",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 20,
                                              bottom: 4.0,
                                              left: 4.0,
                                              right: 80),
                                          child: RadialPieChart(
                                              snapshot.data.popularity),
                                        )
                                      ])
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0,
                                  bottom: 8.0, left: 72.0, right: 8.0),
                              child: Center(
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      name,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.arrow_drop_up,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        );
                    }
                    return null;
                  },
                ),
              ),
            ],
          )),
        ),
        SliverFillRemaining(
            child: SizedBox(
                child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(48.0),
            child: StreamBuilder<String>(
              stream: _biographyEvent.stream,
              initialData: "Biography N/A",
              builder: (context, snapshot) {
                return Center(
                  child: Text(
                    snapshot.data == null || snapshot.data == ""
                        ? "Biography N/A"
                        : snapshot.data,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                );
              },
            ),
          ),
        )))
      ],
    );
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

class RadialPieChart extends StatelessWidget{
  final double popularity;

  RadialPieChart(this.popularity);

  final GlobalKey<AnimatedCircularChartState> _chartKey =
      new GlobalKey<AnimatedCircularChartState>();

  @override
  Widget build(BuildContext context) {
    return new AnimatedCircularChart(
      key: _chartKey,
      size: const Size(80.0, 80.0),
      initialChartData: <CircularStackEntry>[
        new CircularStackEntry(
          <CircularSegmentEntry>[
            new CircularSegmentEntry(popularity, Colors.white,
                rankKey: 'Current'),
            new CircularSegmentEntry(100 - popularity, Colors.grey,
                rankKey: 'Total'),
          ],
          rankKey: 'Quarterly Profits',
        ),
      ],
      chartType: CircularChartType.Radial,
      holeLabel: '${popularity.toInt()} / 100',
      labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      duration: Duration(seconds: 2),
    );
  }
}
