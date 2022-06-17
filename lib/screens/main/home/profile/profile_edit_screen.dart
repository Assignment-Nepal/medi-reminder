
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:roro_medicine_reminder/screens/main/home/profile/profile_screen.dart';
import '../../../../components/navBar.dart';
import '../../../../widgets/app_default.dart';


class ProfileEdit extends StatefulWidget {
  static const String routeName = 'profile_edit_screen';
  ProfileEdit({this.userId});
  final userId;
  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  TextEditingController userNameController; // = TextEditingController();
  TextEditingController ageController;
  TextEditingController weightController;
  TextEditingController heightController;
  TextEditingController bloodGroupController;
  TextEditingController emailController;
  String userName, bloodPressure, bloodSugar, bloodGroup, allergies, email;

  int age, genderValue;
  TextEditingController allergiesController;
  TextEditingController bloodSugarController;
  TextEditingController bloodPressureController;
  double weight, height;
  var gender;
  @override
  void dispose() {
    allergiesController.dispose();
    ageController.dispose();
    bloodGroupController.dispose();
    bloodPressureController.dispose();
    bloodSugarController.dispose();
    userNameController.dispose();
    weightController.dispose();
    heightController.dispose();
    emailController.dispose();
    super.dispose();
  }

  bool load = false;
  getCurrentUser() async {
    try {
      final user = await auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
        await getUserDetails();
        await populateData();
      }
    } catch (e) {
      print(e);
    }
  }

  Future populateData() async {
    await fireStoreDatabase
        .collection('profile')
        .doc(widget.userId)
        .get()
        .then((DocumentSnapshot snapshot) {
      print(snapshot.data);
      if (mounted)
        setState(() {
          age = snapshot['age'];
          userName = snapshot['userName'];
          weight = snapshot['weight'];
          height = snapshot['height'];
          bloodGroup = snapshot['bloodGroup'];
          gender = snapshot['gender'];
          email = snapshot['email'];
          bloodPressure = snapshot['bloodPressure'];
          bloodSugar = snapshot['bloodSugar'];
          allergies = snapshot['allergies'];
        });
    });
    setState(() {
      load = true;
    });
  }

  final fireStoreDatabase = FirebaseFirestore.instance;

  Future getUserDetails() async {
    await fireStoreDatabase
        .collection('user')
        .doc(widget.userId.toString())
        .get()
        .then((DocumentSnapshot snapshot) {
      print(snapshot['age']);
      if (mounted)
        setState(() {
          ageController =
              TextEditingController(text: snapshot['age'].toString());
          userNameController =
              TextEditingController(text: snapshot['userName']);
          weightController =
              TextEditingController(text: snapshot['weight'].toString());
          heightController =
              TextEditingController(text: snapshot['height'].toString());
          bloodGroupController =
              TextEditingController(text: snapshot['bloodGroup']);
          allergiesController =
              TextEditingController(text: snapshot['allergies']);
          bloodPressureController =
              TextEditingController(text: snapshot['bloodPressure']);
          bloodSugarController =
              TextEditingController(text: snapshot['bloodSugar']);
          gender = snapshot['gender'];
          if (gender == 'Male')
            genderValue = 0;
          else
            genderValue = 1;
          email = snapshot['email'];
        });
    });
  }

  Future updateData() async {
    try {
      await fireStoreDatabase
          .collection('profile')
          .doc(widget.userId)
          .update({
        'age': age,
        'userName': userName,
        'height': height,
        'weight': weight,
        'allergies': allergies,
        'gender': gender,
        'bloodGroup': bloodGroup,
        'bloodSugar': bloodSugar,
        'bloodPressure': bloodPressure,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  final auth = FirebaseAuth.instance;
  User loggedInUser;

  @override
  void initState() {
    getCurrentUser();
    getUserDetails();
    populateData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      drawer:AppDrawer(),
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              Text(
                'RORO',
                style: TextStyle(fontFamily: 'Mulish', color: Colors.white),
              ),
            ],
          ),
          centerTitle: true,
          elevation: 1,
          actions: <Widget>[
            GestureDetector(
              onTap: () {},
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.blueGrey,
                child: Icon(
                  Icons.perm_identity,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        body: load
            ? ListView(
                children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Center(
                      child: Text(
                        'Edit Details',
                        style: TextStyle(fontFamily:'Mulish', color: Colors.white, fontSize: 40),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                    child: Row(
                      children: <Widget>[
                        Expanded(child: Text('Name : ')),
                        Expanded(
                          flex: 6,
                          child: FormItem(
                            helperText: 'Name of the user',
                            hintText: 'Enter type of User Name',
                            controller: userNameController,
                            onChanged: (value) {
                              print('Name Saved');
                              setState(() {
                                userName = value;
                              });
                            },
                            isNumber: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 0),
                    child: Text(
                      'Gender : ',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Male : '),
                        Radio(
                          onChanged: (value) {
                            setState(() {
                              gender = 'Male';
                              genderValue = value;
                            });
                          },
                          activeColor: Color(0xffE3952D),
                          value: 0,
                          groupValue: genderValue,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Female : '),
                        Radio(
                          onChanged: (value) {
                            setState(() {
                              gender = 'Female';
                              genderValue = value;
                            });
                          },
                          activeColor: Color(0xffE3952D),
                          value: 1,
                          groupValue: genderValue,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 5, 0, 0),
                    child: Row(
                      children: <Widget>[
                        Expanded(child: Text('Age : ')),
                        Expanded(
                          flex: 6,
                          child: FormItem(
                            helperText: 'Age',
                            hintText: 'Enter Age ',
                            controller: ageController,
                            onChanged: (value) {
                              print('Name Saved');
                              setState(() {
                                age = int.parse(value);
                              });
                            },
                            isNumber: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: Row(
                      children: <Widget>[
                        Expanded(child: Text('Weight:')),
                        Expanded(
                          flex: 6,
                          child: FormItem(
                            helperText: 'Weight ',
                            hintText: 'Enter weight',
                            controller: weightController,
                            onChanged: (value) {
                              print('Name Saved');
                              setState(() {
                                weight = double.parse(value);
                              });
                            },
                            isNumber: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: Row(
                      children: <Widget>[
                        Expanded(child: Text('Height:')),
                        Expanded(
                          flex: 6,
                          child: FormItem(
                            helperText: 'Height ',
                            hintText: 'Enter Height',
                            controller: heightController,
                            onChanged: (value) {
                              print('Name Saved');
                              setState(() {
                                height = double.parse(value);
                              });
                            },
                            isNumber: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: Row(
                      children: <Widget>[
                        Expanded(child: Text('Blood Group :')),
                        Expanded(
                          flex: 6,
                          child: FormItem(
                            helperText: 'Weight ',
                            hintText: 'Enter Blood Group',
                            controller: bloodGroupController,
                            onChanged: (value) {
                              print('Name Saved');
                              setState(() {
                                bloodGroup = value;
                              });
                            },
                            isNumber: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: Text(
                          'Blood Pressure :',
                          style: TextStyle(fontSize: 16),
                        )),
                        Expanded(
                          flex: 6,
                          child: FormItem(
                            hintText: 'Enter Blood Pressure',
                            controller: bloodPressureController,
                            onChanged: (value) {
                              print('Name Saved');
                              setState(() {
                                bloodPressure = value;
                              });
                            },
                            isNumber: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: Text(
                          'Blood Sugar :',
                          style: TextStyle(fontSize: 15),
                        )),
                        Expanded(
                          flex: 6,
                          child: FormItem(
                            helperText: 'Weight ',
                            hintText: 'Enter Blood Sugar',
                            controller: bloodSugarController,
                            onChanged: (value) {
                              print('Name Saved');
                              setState(() {
                                bloodSugar = value;
                              });
                            },
                            isNumber: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: Text(
                          'Allergies :',
                          style: TextStyle(fontSize: 15),
                        )),
                        Expanded(
                          flex: 6,
                          child: FormItem(
                            hintText: 'Enter Allergies ',
                            controller: allergiesController,
                            onChanged: (value) {
                              print('Name Saved');
                              setState(() {
                                allergies = value;
                              });
                            },
                            isNumber: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await updateData();
                      Navigator.pushNamed(context, ProfileScreen.routeName);
                      print('Changed');
                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(50, 20, 50, 30),
                      padding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 65.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.redAccent[100],
                        boxShadow: [
                          BoxShadow(
                            color: Colors.redAccent[100],
                            blurRadius: 3.0,
                            offset: Offset(0, 4.0),
                          ),
                        ],
                      ),
                      child: Text(
                        'Save Changes',
                        style: TextStyle(color: Colors.black, fontSize: 20.0),
                      ),
                    ),
                  ),
                ],
              )
            : Container(
                child: SpinKitWanderingCubes(
                  color: Colors.blueGrey,
                  size: 100.0,
                ),
              ),
      bottomNavigationBar: MyBottomNavBar(),
    );

  }
}
