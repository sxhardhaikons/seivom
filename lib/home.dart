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
    Text("Movies"),
    Text("Tv"),
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
              return GridView.builder(
                  itemCount: listOfPersons.length,
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: Hero(
                        tag: listOfPersons[index].actorId,
                        child: Material(
                          child: InkWell(
                            child: GridTile(
                              child: Image.network(
                                API_IMAGE_BASE_URL +
                                    listOfPersons[index].profilePath,
                                fit: BoxFit.cover,
                              ),
                              footer: Container(
                                color: Colors.yellow,
                                child: ListTile(
                                  leading: Text(listOfPersons[index].name),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  });
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
