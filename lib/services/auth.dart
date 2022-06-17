
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/custom_exceptions.dart';
import '../screens/main/home/homePage.dart';




class AuthClass extends ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer authTimer;
  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  bool get isAuth {
    return token != null;
  }

  String get userID {
    return _userId;
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  final storage = new FlutterSecureStorage();

  Stream<String> get onAuthStateChanged =>
      _auth.authStateChanges().map((User user) => user?.uid);

  Future<void> inputData() async {
    final User user = await _auth.currentUser;
    final uid = user.uid;
  }

  Future<void> googleSignIn(BuildContext context) async {
    try {
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );


      final QuerySnapshot result =
      await FirebaseFirestore.instance.collection('profile').get();
      final List<DocumentSnapshot> documents = result.docs;
      bool userExits = false;
      for (var document in documents) {
        if (document.id == _auth.currentUser.uid) userExits = true;
      }
      SharedPreferences prefs;
      prefs = await SharedPreferences.getInstance();

      if (!userExits) {
        prefs.setBool('first', true);
        try {
          await FirebaseFirestore.instance
              .collection('profile')
              .doc(_auth.currentUser.uid.toString())
              .set({
            'userName': _auth.currentUser.displayName,
            'email': _auth.currentUser.email,
            'phoneNumber': _auth.currentUser.phoneNumber ?? 'Not Set',
            'uid': _auth.currentUser.uid,
            'picture':
            _auth.currentUser.photoURL ?? 'https://www.nicepng.com/ourpic/u2q8i1t4t4t4q8a9_group-of-10-guys-login-user-icon-png/',
            'weight': 'Not Set',
            'height': 'Not Set',
            'bloodPressure': 'Not Set',
            'bloodSugar': 'Not Set',
            'allergies': 'None',
            'bloodGroup': 'Not Set',
            'age': 'Not Set',
            'gender': 'Not Set',
          });
        } catch (e) {
          print(e.toString());
        }
      }
      if (googleSignInAccount != null) {
        UserCredential userCredential =
        await _auth.signInWithCredential(credential);
        storeTokenAndData(userCredential);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (builder) => HomePage()),
                (route) => false);

        final snackBar =
        SnackBar(content: Text(userCredential.user.displayName));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      print("here---->");
      final snackBar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> signOut({BuildContext context}) async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      await storage.delete(key: "token");
    } catch (e) {
      final snackBar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> _authenticate(
      String email, String password, String urlSeg) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/$urlSeg?key=AIzaSyCw-YBHGinNHqpbZW74TpL511-s_p5KJQI';
    try {
      final response = await http.post(Uri.parse(
          url),
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final QuerySnapshot result =
      await FirebaseFirestore.instance.collection('profile').get();
      final List<DocumentSnapshot> documents = result.docs;
      bool userExits = false;
      for (var document in documents) {
        if (document.id == _auth.currentUser.uid) userExits = true;
      }
      SharedPreferences prefs;
      prefs = await SharedPreferences.getInstance();

      if (!userExits) {
        prefs.setBool('first', true);
        try {
          await FirebaseFirestore.instance
              .collection('profile')
              .doc(_auth.currentUser.uid.toString())
              .set({
            'userName': _auth.currentUser.displayName,
            'email': _auth.currentUser.email,
            'phoneNumber': _auth.currentUser.phoneNumber ?? 'Not Set ',
            'uid': _auth.currentUser.uid,
            'picture':
            _auth.currentUser.photoURL ?? 'https://www.nicepng.com/ourpic/u2q8i1t4t4t4q8a9_group-of-10-guys-login-user-icon-png/',
            'weight': 'Not Set',
            'height': 'Not Set',
            'bloodPressure': 'Not Set',
            'bloodSugar': 'Not Set',
            'allergies': 'None',
            'bloodGroup': 'Not Set',
            'age': 'Not Set',
            'gender': 'Not Set',
          });
        } catch (e) {
          print(e.toString());
        }
      }
      var _responseData = json.decode(response.body);
      if (_responseData['error'] != null)
        throw CustomExceptions(_responseData['error']['message']);

      _token = _responseData['idToken'];
      _userId = _responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            _responseData['expiresIn'],
          ),
        ),
      );
      _autoLogout();
      notifyListeners();

      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate.toIso8601String(),
        },
      );
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'accounts:signUp');
  }

  Future<void> signIn(String email, String password) async {
    return _authenticate(email, password, 'accounts:signInWithPassword');
  }

  Future<bool> tryAutoLogIn() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedData =
    json.decode(prefs.getString('userData')) as Map<String, Object>;
    final userExpiryDate = DateTime.parse(extractedData['expiryDate']);
    if (userExpiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedData['token'];
    _userId = extractedData['userId'];
    _expiryDate = DateTime.parse(extractedData['expiryDate']);
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (authTimer != null) {
      authTimer.cancel();
      authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _autoLogout() {
    if (authTimer != null) {
      authTimer.cancel();
    }
    final expiryTime = _expiryDate.difference(DateTime.now()).inSeconds;
    authTimer = Timer(Duration(seconds: expiryTime), logout);


  }

  void storeTokenAndData(UserCredential userCredential) async {
    print("storing token and data");
    await storage.write(
        key: "token", value: userCredential.credential.token.toString());
    await storage.write(
        key: "usercredential", value: userCredential.toString());
  }

  Future<String> getToken() async {
    return await storage.read(key: "token");
  }

  Future<void> verifyPhoneNumber(
      String phoneNumber, BuildContext context, Function setData) async {
    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      showSnackBar(context, "Verification Completed");
    };
    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException exception) {
      showSnackBar(context, exception.toString());
    };
    PhoneCodeSent codeSent =
        (String verificationID, [int forceResendingtoken]) {
      showSnackBar(context, "Verification Code sent on the phone number");
      setData(verificationID);
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationID) {
      showSnackBar(context, "Time out");
    };
    try {
      await _auth.verifyPhoneNumber(
          timeout: Duration(seconds: 60),
          phoneNumber: phoneNumber,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> signInwithPhoneNumber(
      String verificationId, String smsCode, BuildContext context) async {
    try {
      AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);

      UserCredential userCredential =
      await _auth.signInWithCredential(credential);
      storeTokenAndData(userCredential);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (builder) => HomePage()),
              (route) => false);

      showSnackBar(context, "Logged In");
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}