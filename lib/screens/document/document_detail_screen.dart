
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import '../../components/navBar.dart';
import '../../models/image.dart';
import '../../widgets/app_default.dart';

class DocumentDetail extends StatefulWidget {
  final ImageClass image;
  DocumentDetail(this.image);

  @override
  _DocumentDetailState createState() => _DocumentDetailState();
}

class _DocumentDetailState extends State<DocumentDetail> {
  ImageClass image = ImageClass();
  bool isDownloading;

  @override
  void initState() {
    isDownloading = false;
    image = widget.image;
    initializeDownloader();
    super.initState();
  }

  initializeDownloader() async {
    WidgetsFlutterBinding.ensureInitialized();
  }

  downloadDocument(String url) async {
    setState(() {
      isDownloading = true;
    });

    try {
      final taskId = await FlutterDownloader.enqueue(
        url: url,
        savedDir: '/storage/emulated/0/Documents',
        showNotification: true,
        openFileFromNotification: true,
      ).catchError((onError) {
        print(onError);
        setState(() {
          isDownloading = false;
        });
      });
      print(taskId);
    } catch (e) {
      print(e);
    }
  }

  Future<bool> checkPermission() async {
    if (await Permission.storage.request().isGranted) {

      String dir = (await getExternalStorageDirectory()).absolute.path + "/documents";
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: image.name,
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                margin: EdgeInsets.all(8),
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Image.network(
                    image.url,
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height / 1.5,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                image.name,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            !isDownloading
                ? Column(
                    children: <Widget>[
                      InkWell(
                        onTap: () async {
                          await downloadDocument(image.url);
                          setState(() {
                            isDownloading = false;
                          });
                        },
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey,
                          child: Center(
                            child: Icon(
                              Icons.file_download,
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text('Download to Device'),
                      SizedBox(
                        height: 8,
                      )
                    ],
                  )
                : Column(
                    children: <Widget>[
                      CircularProgressIndicator(),
                      SizedBox(
                        height: 8,
                      )
                    ],
                  ),
          ],
        ),
        appBar: ROROAppBar(),
        drawer: AppDrawer(),
        bottomNavigationBar: MyBottomNavBar(),
      ),
    );
  }
}
