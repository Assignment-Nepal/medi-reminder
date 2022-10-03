import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:roro_medicine_reminder/screens/authenticate/forgotPwd.dart';
import 'package:roro_medicine_reminder/screens/authenticate/new_auth.dart';
import 'package:roro_medicine_reminder/screens/authenticate/register.dart';
import 'package:roro_medicine_reminder/services/auth.dart';

import '../main/home/homePage.dart';
import 'PhoneAuth.dart';

class SignInPage extends StatefulWidget {
  static const routeName = '/SignInPage';

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();
  bool circular = false;
  AuthClass authClass = AuthClass();
  String verificationIdFinal = "";
  String smsCode = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Color(0xffe3f1f4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "SIGN IN",
                style: TextStyle(
                  fontFamily: "Mulish",
                  fontSize: 35,
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              buttonItem("assets/images/google.svg", "Continue with Google", 25,
                  () {
                authClass.googleSignIn(context);
              }),
              SizedBox(
                height: 15,
              ),
              buttonItem("assets/images/phone.svg", "Continue with Mobile", 30,
                  () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (builder) => PhoneAuthPage()));
              }),
              SizedBox(
                height: 18,
              ),
              Text(
                "OR",
                style: TextStyle(
                    fontFamily: "Mulish", color: Colors.blueGrey, fontSize: 18),
              ),
              SizedBox(
                height: 18,
              ),
              textItem("Your Email", _emailController, false),
              SizedBox(
                height: 15,
              ),
              textItem("Your Password", _pwdController, true),
              SizedBox(
                height: 40,
              ),
              colorButton(),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have account? ",
                    style: TextStyle(
                      fontFamily: "Mulish",
                      color: Colors.blueGrey,
                      fontSize: 18,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (builder) => SignUpPage()),
                          (route) => false);
                    },
                    child: Text(
                      "SignUp",
                      style: TextStyle(
                        fontFamily: "Mulish",
                        color: Colors.blueGrey,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (builder) => forgotPwd()),
                      (route) => false);
                },
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(
                    fontFamily: "Mulish",
                    color: Colors.blueGrey,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget colorButton() {
    return InkWell(
      onTap: () async {
        // try {
        //   firebase_auth.UserCredential userCredential =
        //   await firebaseAuth.signInWithEmailAndPassword(
        //       email: _emailController.text, password: _pwdController.text);
        //   print(userCredential.user.email);
        //   setState(() {
        //     circular = false;
        //   });
        //   Navigator.pushAndRemoveUntil(
        //       context,
        //       MaterialPageRoute(builder: (builder) => HomePage()),
        //           (route) => false);
        // } catch (e) {
        //   final snackbar = SnackBar(content: Text(e.toString()));
        //   ScaffoldMessenger.of(context).showSnackBar(snackbar);
        //   setState(() {
        //     circular = false;
        //   });
        // }
        try {
          AuthClass().signIn(_emailController.text, _pwdController.text);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (builder) => HomePage()),
              (route) => false);
        } catch (e) {
          final snackbar = SnackBar(content: Text(e.toString()));
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
          setState(() {
            circular = false;
          });
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width - 100,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Color(0xffff9987),
        ),
        child: Center(
          child: circular
              ? CircularProgressIndicator()
              : Text(
                  "SIGN IN",
                  style: TextStyle(
                    fontFamily: "Mulish",
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
        ),
      ),
    );
  }

  Widget buttonItem(
      String imagepath, String buttonName, double size, Function onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width - 60,
        height: 60,
        child: Card(
          color: Colors.black,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                imagepath,
                height: size,
                width: size,
              ),
              SizedBox(
                width: 15,
              ),
              Text(
                buttonName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget textItem(
      String labeltext, TextEditingController controller, bool obscureText) {
    return Container(
      width: MediaQuery.of(context).size.width - 70,
      height: 55,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(
          fontSize: 17,
          color: Colors.blueGrey[900],
        ),
        decoration: InputDecoration(
          labelText: labeltext,
          labelStyle: TextStyle(
            fontSize: 17,
            color: Colors.blueGrey[900],
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              width: 1.5,
              color: Colors.amber,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              width: 1,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
