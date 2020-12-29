import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:undangi/Constant/app_widget.dart';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ZoomAbleSingleWithDownload extends StatefulWidget {
  @override
  _ZoomAbleSingleWithDownloadState createState() =>
      _ZoomAbleSingleWithDownloadState();

  const ZoomAbleSingleWithDownload({Key key, this.imgUrl, this.min, this.max})
      : super(key: key);

  final String imgUrl;
  final double min;
  final double max;
}

class _ZoomAbleSingleWithDownloadState
    extends State<ZoomAbleSingleWithDownload> {
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
        url: widget.imgUrl,
        savedDir: externalDir.path,
        fileName: widget.imgUrl.split('/').last,
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
      appBar: appPolosBackWithAction(context,paddingPhone, () {
        Navigator.pop(context);
      },Icon(
                  Icons.file_download,
                  color: AppTheme.primaryWhite,
                  size: AppTheme.sizeIconMenu+4,
                ),()=>_saveImage()),
      body: Container(
        alignment: Alignment.center,
        color: Colors.white,
        child: InteractiveViewer(
            boundaryMargin: EdgeInsets.all(20.0),
            minScale: widget.min,
            maxScale: widget.max,
            child: imageLoadByWidth(widget.imgUrl, false, 320)),
      ),
    );
  }
}
