import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:seivom/brain/constants.dart';
import 'package:seivom/brain/secret.dart';

import 'model/personresponse.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    PlaceholderWidget("Movies"),
    PlaceholderWidget("Tv"),
    PlaceholderWidget("People")
  ];

  void onNavigationTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: onNavigationTapped,
          items: [
            BottomNavigationBarItem(
                icon: new Icon(Icons.movie), title: new Text("Movies")),
            BottomNavigationBarItem(
                icon: new Icon(Icons.satellite), title: new Text("TV Shows")),
            BottomNavigationBarItem(
                icon: new Icon(Icons.person), title: new Text("People"))
          ]),
    );
  }
}

class PlaceholderWidget extends StatelessWidget {
  final String tag;

  PlaceholderWidget(this.tag);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tag),
      ),
      body: FutureBuilder(
        builder: (context, AsyncSnapshot<PersonResponse> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text('Press button to start.');
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Text('Awaiting result...');
            case ConnectionState.done:
              if (snapshot.hasError) return Text('Error: ${snapshot.error}');
              List<PersonResult> listOfPersons = snapshot.data.persons;
              return ListView.builder(
                itemCount: listOfPersons.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: <Widget>[Text(listOfPersons[index].name)],
                  );
                },
              );
          }
          return null; // unreachable
        },
        future: getPopularPersons(),
      ),
    );
  }

  Future<PersonResponse> getPopularPersons() async {
    var result = await get(
        API_BASE_URL + API_POPULAR_PERSONS + API_KEY_KEY + API_KEY_VALUE);

    if (result.statusCode == 200) {
      return PersonResponse.fromJson(json.decode(result.body));
    }
    throw Exception('Failed to load data');
  }
}
