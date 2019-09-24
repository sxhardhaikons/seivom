import 'package:flutter/material.dart';

import 'actors.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    Center(
      child: Text("Movies Comming Soon"),
    ),
    Center(
      child: Text("Tv shows Comming Soon"),
    ),
    Actors(),
    Center(
      child: Text("Favorites Comming Soon"),
    )
  ];

  void onNavigationTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        body: _children[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.black,
            unselectedItemColor: Colors.grey,
            selectedItemColor: Colors.white,
            currentIndex: _currentIndex,
            onTap: onNavigationTapped,
            items: [
              BottomNavigationBarItem(
                  icon: new Icon(Icons.movie), title: new Text("Movies")),
              BottomNavigationBarItem(
                  icon: new Icon(Icons.satellite), title: new Text("TV Shows")),
              BottomNavigationBarItem(
                  icon: new Icon(Icons.person), title: new Text("People")),
              BottomNavigationBarItem(
                  icon: new Icon(Icons.favorite), title: new Text("Favorites"))
            ]));
  }
}
