import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:roro_medicine_reminder/screens/authenticate/signin.dart';


class privacy extends StatefulWidget {
  const privacy({Key key}) : super(key: key);

  @override
  State<privacy> createState() => _privacyState();
}

class _privacyState extends State<privacy> {
  final _formKey = GlobalKey<FormState>();

  var email = "";

  final emailController = TextEditingController();

  resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'The code for initialization was sent to you.',
          ),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return SignInPage();
          },
        ),
      );
    } on FirebaseAuthException catch (err) {
      if (err.code == 'user-not-found') {
        print('User not found!');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'User not exist!',
            ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();

    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Privacy and security',
        ),
        actions: [],
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 15.0,
            ),
            child: Text(
              'A reset link will be sent to your email.',
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
          ),
          Container(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        setState(() {
                          email = emailController.text;
                        });
                        resetPassword();
                      }
                    },
                    child: Text('Send Email',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ]),
          )
        ],
      ),
    );
  }
}
