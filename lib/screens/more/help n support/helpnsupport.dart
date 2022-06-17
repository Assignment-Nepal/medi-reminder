import 'package:flutter/material.dart';
import '../../../components/navBar.dart';

import '../../../widgets/app_default.dart';

class helpSupport extends StatefulWidget {
  const helpSupport({Key key}) : super(key: key);

  @override
  State<helpSupport> createState() => _helpSupportState();
}

class _helpSupportState extends State<helpSupport> {

  final List quotes = [
    {
      "answer":
      "A JagaMe is a family member, friend or caregiver that you can sync to your App. In case you forget your medication, "
          "RORO sends push notification to your JagaMe, offering her/him to remind you to take your medication.",
      "question": "What is a JagaMe?"
    },
    {
      "answer":
      "1. Tap Medication card button at Homescreen and you'll be directed to Medicine reminder screen. \n "
          "2. Tap another Medication card button to add dose.\n"
          "3. or Tap on the '+' on the bottom right to add note.",
      "question": "How do I add a medication dose?"
    },
    {
      "answer":
      "1. Tap Appointment card button at Homescreen and you'll be directed to appointment schedule screen. \n"
          "2. Tap on the '+' on the bottom right to add appointment.",
      "question": "How do I add an appointment?"
    },
    {
      "answer": "1. Tap Note card button at Homescreen and you'll be directed to Note screen. \n "
          "2. Tap another Note card button to add dose. \n"
          "3. Or Tap on the '+' on the bottom right to add note.",
      "question": "How do I add a note?"
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ROROAppBar(),
      drawer:AppDrawer(),
      body: ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: quotes.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildExpandableTile(quotes[index]);
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
      bottomNavigationBar: MyBottomNavBar(),
    );
  }
}

Widget _buildExpandableTile(item) {
  return ExpansionTile(
    title: Text(
      item['question'],
      style: TextStyle(fontWeight: FontWeight.w700, fontFamily: 'Mulish', fontSize: 18),
    ),
    children: <Widget>[
      ListTile(
        title: Text(
          item['answer'],
          style: TextStyle(fontFamily: 'Mulish', fontSize: 18),
        ),
      )
    ],
  );
}

