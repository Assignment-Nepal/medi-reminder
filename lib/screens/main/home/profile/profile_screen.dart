import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:roro_medicine_reminder/models/user.dart';
import 'package:roro_medicine_reminder/screens/main/home/homePage.dart';
import 'package:roro_medicine_reminder/screens/main/home/profile/ProfileTextBox.dart';
import 'package:roro_medicine_reminder/widgets/app_default.dart';

import '../../../../components/navBar.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = 'Dependent_Profile_Screen';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<String> addProfile() async {
    CollectionReference profile =
        FirebaseFirestore.instance.collection('profile');
    var profiles = await profile.add({});
    return 'Created';
  }

  String userId, imageUrl = '';
  User loggedInUser;
  File imageFile;

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  getCurrentUser() async {
    User user = await FirebaseAuth.instance.currentUser;
    setState(() {
      userId = user.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'RORO',
              style: TextStyle(color: Colors.white),
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
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('profile')
              .doc(userId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot != null && snapshot.hasData) {
              UserProfile userProfile = UserProfile(userId);
              userProfile.setData(snapshot.data.data());
              return ListView(
                children: <Widget>[
                  SizedBox(
                    height: 8,
                  ),
                  Center(
                    child: Stack(
                      children: <Widget>[
                        Container(
                            width: 170,
                            height: 170,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 5, color: Colors.white),
                                borderRadius: BorderRadius.circular(2000),
                                shape: BoxShape.rectangle,
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: AssetImage(
                                        "assets/images/image1.png")))),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () async {
                              await getImage();
                            },
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.add_photo_alternate,
                                size: 40,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ProfileTextBox(
                    name: 'userName',
                    value: userProfile.userName,
                    title: 'name',
                  ),
                  ProfileTextBox(
                    name: 'age',
                    value: userProfile.age,
                    title: 'age',
                  ),
                  ProfileTextBox(
                    name: 'gender',
                    value: userProfile.gender,
                    title: 'gender',
                  ),
                  ProfileTextBox(
                    name: 'height',
                    value: userProfile.height,
                    title: 'height',
                  ),
                  ProfileTextBox(
                    name: 'weight',
                    value: userProfile.weight,
                    title: 'weight',
                  ),
                  ProfileTextBox(
                    name: 'bloodGroup',
                    value: userProfile.bloodGroup,
                    title: 'blood group',
                  ),
                  ProfileTextBox(
                    name: 'bloodPressure',
                    value: userProfile.bloodPressure,
                    title: 'blood pressure',
                  ),
                  ProfileTextBox(
                    name: 'bloodSugar',
                    value: userProfile.bloodSugar,
                    title: 'blood sugar',
                  ),
                  ProfileTextBox(
                    name: 'allergies',
                    value: userProfile.allergies,
                    title: 'allergies',
                  ),
                  ProfileTextBox(
                    name: 'email',
                    value: userProfile.email,
                    title: 'email address',
                  ),
                  ProfileTextBox(
                    name: 'phoneNumber',
                    value: userProfile.phoneNumber,
                    title: 'phone number',
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () async {
                            await updateData;
                            Navigator.pushNamed(
                                context, ProfileScreen.routeName);
                            print('Changed');
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 2,
                            primary: Color(0xffff9987),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                  color: Colors.redAccent[100],
                                )),
                            padding: EdgeInsets.symmetric(
                                horizontal: 40, vertical: 10),
                          ),
                          child: Text("Update Data",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Mulish',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ),
                        SizedBox(
                          width: 25,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()),
                            );
                          },
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Mulish',
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            elevation: 2,
                            primary: Color(0xffff9987),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                  color: Colors.redAccent[100],
                                )),
                            padding: EdgeInsets.symmetric(
                                horizontal: 40, vertical: 10),
                          ),
                        )
                      ]),
                ],
              );
            } else {
              return Container(
                child: SpinKitWanderingCubes(
                  color: Colors.blueGrey,
                  size: 100.0,
                ),
              );
            }
          }),
      bottomNavigationBar: MyBottomNavBar(),
    );
  }

  updateData(String name, String value) async {
    await FirebaseFirestore.instance
        .collection('profile')
        .doc(userId)
        .update({name: value});
  }

  Future getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = File(pickedFile.path);
    });
    if (imageFile != null) {
      setState(() {
//        isLoading = true;
      });
      await uploadFile(userId);
    }
  }

  Future uploadFile(String name) async {
    String fileName = name;
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = reference.putFile(imageFile);
    TaskSnapshot storageTaskSnapshot = await uploadTask;
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      imageUrl = downloadUrl;

      setState(() {
//        isLoading = false;
      });
      updateData('picture', imageUrl);
    }, onError: (err) {
      setState(() {
//        isLoading = false;
      });
      showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: Text('Not an Image.'),
            );
          });
    });
  }
}
