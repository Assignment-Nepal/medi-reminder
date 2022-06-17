import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:roro_medicine_reminder/screens/more/notes/notes.dart';
import 'package:roro_medicine_reminder/screens/more/notes/view_note.dart';

import '../../../components/navBar.dart';
import '../../../widgets/app_default.dart';
import '../../../widgets/home_screen_widgets.dart';

class NotePage extends StatefulWidget {
  static const String routeName = 'Note_screen';
  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  CollectionReference ref = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection('notes');

  List<Color> myColors = [
    Colors.yellow[200],
    Colors.red[200],
    Colors.green[200],
    Colors.deepPurple[200],
    Colors.purple[200],
    Colors.cyan[200],
    Colors.teal[200],
    Colors.tealAccent[200],
    Colors.pink[200],
  ];

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: ROROAppBar(),
      drawer: AppDrawer(),
      body: FutureBuilder<QuerySnapshot>(
        future: ref.get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.docs.length == 0) {
              return Column(

                children: <Widget>[
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                          splashColor: Colors.teal,
                          child: CardButton(
                            height: height * 0.2,
                            width: width * (35 / 100),
                            icon: FontAwesomeIcons.noteSticky,
                            size: width * (25 / 100),
                            color: Colors.teal[200],
                            borderColor: Colors.teal.withOpacity(0.75),
                          ),
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                                  return AddNote();
                                  //return ReminderDetail();
                                }));
                          },
                        ),
                        Center(
                            //margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                            child: Text('You have no saved notes! \nClick to add one.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Mulish',
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                        ),

                      ],
                    ),
                  ),
                ],
              );
            }

            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                Random random = new Random();
                Color bg = myColors[random.nextInt(4)];
                Map data = snapshot.data.docs[index].data();
                DateTime mydateTime = data['created'].toDate();
                String formattedTime =
                    DateFormat.yMMMd().add_jm().format(mydateTime);

                return InkWell(
                  onTap: () {
                    Navigator.of(context)
                        .push(
                      MaterialPageRoute(
                        builder: (context) =>
                            ViewNote(
                              data,
                              formattedTime,
                              snapshot.data.docs[index].reference,
                            ),
                      ),
                    )
                        .then((value) {
                      setState(() {});
                    });
                  },
                  child: Card(
                    color: bg,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${data['title']}",
                            style: TextStyle(
                              fontSize: 24.0,
                              fontFamily: "Mulish",
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          //
                          Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              formattedTime,
                              style: TextStyle(
                                fontSize: 20.0,
                                fontFamily: "Mulish",
                                color: Colors.black87,
                              ),
                            ),

                          ),

                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Text("Loading..."),
            );
          }
        },
      ),
      bottomNavigationBar: MyBottomNavBar(),
    );
  }
}
