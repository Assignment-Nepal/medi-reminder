import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import '../../components/navBar.dart';
import '../../widgets/app_default.dart';

class About extends StatefulWidget {
  const About({Key key}) : super(key: key);

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    //packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  Widget _infoTile(String title, String subtitle) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle.isNotEmpty ? subtitle : 'Not set'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ROROAppBar(),
      drawer: AppDrawer(),
      body: Container(
      padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: ListView(
        children: [
          Text(
            "About",
            style: TextStyle(fontFamily: "Mulish", fontSize: 25, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 40,
          ),
          _infoTile('App name', _packageInfo.appName),
          //_infoTile('Package name', _packageInfo.packageName),
          _infoTile('App version', _packageInfo.version),
          _infoTile('Build number', _packageInfo.buildNumber),
        ],
      )),
      bottomNavigationBar: MyBottomNavBar(),
    );
  }
}
