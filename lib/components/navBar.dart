import 'package:flutter/material.dart';
import '../screens/main/home/homePage.dart';
import '../screens/main/more.dart';
import '../screens/main/progress.dart';
import '../screens/main/treatment.dart';
import '../shared/constants.dart';

class MyBottomNavBar extends StatelessWidget {
  const MyBottomNavBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: kDefaultPadding * 2,
        right: kDefaultPadding * 2,
      ),
      height: 60,
      decoration: BoxDecoration(
        color: Colors.blueGrey[50],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.home_sharp, color: Colors.blueGrey),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HomePage()),
              );
            },
          ),
          /*IconButton(
            icon: const Icon(Icons.bar_chart, color: Colors.blueGrey),
            color: Colors.blueGrey[800],
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Progress()),
              );
            },
          ),*/
          IconButton(
            icon: const Icon(Icons.medical_services_sharp, color: Colors.blueGrey),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Treatment()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.blueGrey),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => More()),
              );
            },
          ),
        ],
      ),
    );
  }
}