import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:undangi/Constant/app_widget.dart';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ZoomAbleMultiWithDownload extends StatefulWidget {
  @override
  _ZoomAbleMultiWithDownloadState createState() =>
      _ZoomAbleMultiWithDownloadState();

  const ZoomAbleMultiWithDownload(
      {Key key, this.imgList, this.index: 0, this.min, this.max})
      : super(key: key);

  final List imgList;
  final int index;
  final double min;
  final double max;
}

class _ZoomAbleMultiWithDownloadState extends State<ZoomAbleMultiWithDownload> {
  int index = 0;
  List imgList = [];

  //DOWNLOADER
  ReceivePort _receivePort = ReceivePort();
  bool loadDownloadLampiran = false;
  int progress = 0;

  static downloadingCallback(id, status, progress) {
    ///Looking up for a send port
    SendPort sendPort = IsolateNameServer.lookupPortByName("Undangi");

    ///ssending the data
    sendPort.send([id, status, progress]);
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  void _saveImage() async {
    final status = await Permission.storage.request();

    if (status.isGranted) {
      final externalDir = await getExternalStorageDirectory();

      final id = await FlutterDownloader.enqueue(
        url: imgList[index],
        savedDir: externalDir.path,
        fileName: imgList[index].split('/').last,
        showNotification: true,
        openFileFromNotification: true,
      );
    } else {
      print("Permission deined");
    }
  }

  @override
  void dispose() {
    _unbindBackgroundIsolate();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      index = widget.index;
      imgList = widget.imgList;
    });
    super.initState();

    ///register a send port for the other isolates
    IsolateNameServer.registerPortWithName(
        _receivePort.sendPort, "downloading");

    ///Listening for the data is comming other isolataes
    _receivePort.listen((message) {
      setState(() {
        progress = message[2];
      });

      if (!loadDownloadLampiran) {
        setState(() {
          loadDownloadLampiran = true;
        });
        onLoading(context);
      }

      if (progress >= 100) {
        if (loadDownloadLampiran) {
          Navigator.pop(context);
          openAlertSuccessBox(
              context, 'Berhasil!', 'Lampiran Berhasil didownload...', 'OK',
              () {
            setState(() {
              loadDownloadLampiran = false;
            });
            Navigator.pop(context);
          });
          _unbindBackgroundIsolate();
        }
      }

      print(progress);
    });

    FlutterDownloader.registerCallback(downloadingCallback);
  }

  @override
  Widget build(BuildContext context) {
    final sizeu = MediaQuery.of(context).size;
    final paddingPhone = MediaQuery.of(context).padding;
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      appBar: appPolosBackWithAction(context, paddingPhone, () {
        Navigator.pop(context);
      },
          Icon(
            Icons.file_download,
            color: AppTheme.primaryWhite,
            size: AppTheme.sizeIconMenu + 4,
          ),
          () => _saveImage()),
      body: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            color: Colors.white,
            child: InteractiveViewer(
                boundaryMargin: EdgeInsets.all(20.0),
                minScale: widget.min,
                maxScale: widget.max,
                child: imageLoadByWidth(imgList[index], false, 320)),
          ),
          Container(
            width: 30,
            margin: EdgeInsets.only(top: sizeu.height / 2 - 20, left: 5),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: imgList.length<=1  ? Colors.grey :Colors.black,
                size: 30,
              ),
              // color: Colors.white,
              onPressed: () {
                setState(() {
                  if ((index) > 0) {
                    index = index - 1;
                  } else if (imgList.length > 1) {
                    index = imgList.length - 1;
                  }
                });
              },
            ),
          ),
          Container(
            width: 30,
            margin: EdgeInsets.only(
                top: sizeu.height / 2 - 20, left: sizeu.width - 43),
            child: IconButton(
              icon: Icon(
                Icons.arrow_forward_ios,
                color: imgList.length<=1  ? Colors.grey : Colors.black,
                size: 30,
              ),
              // color: Colors.white,
              onPressed: () {
                setState(() {
                  if ((index) < imgList.length - 1) {
                    index = index + 1;
                  } else if (index != 0) {
                    index = 0;
                  }
                });

                // event();
              },
            ),
          ),
          Container(
            width: 90,
            height: 30,
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue,
              borderRadius: BorderRadius.circular(20),
            ),
            alignment: Alignment.center,
            margin: EdgeInsets.only(
                top:
                    sizeu.height - paddingPhone.top - paddingPhone.bottom - 120,
                left: sizeu.width / 2 - 40),
            child: Text(
              '${(index + 1).toString()}/${imgList.length.toString()}',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
