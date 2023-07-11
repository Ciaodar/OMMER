import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_dart_scan/qr_code_dart_scan.dart';

import '../Objects/User.dart';

class LiveDecodePage extends StatefulWidget {
  const LiveDecodePage({super.key});

  @override
  _LiveDecodePageState createState() => _LiveDecodePageState();
}

class _LiveDecodePageState extends State<LiveDecodePage> {
  Result? currentResult;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(1, 1, 1, 0.01),
      ),
      body: QRCodeDartScanView(
        widthPreview: MediaQuery.of(context).size.width,
        heightPreview: MediaQuery.of(context).size.height,
        scanInvertedQRCode: true,
        onCapture: (Result result) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              Navigator.of(context).pop();
              return AlertDialog(
                title: const Text('Success'),
                content: const Text('User Found.'),
                actions: <Widget>[
                  ElevatedButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
          setState(() {
            currentResult = result;
            context.read<User>().updateUserInfo(qrUid: result.text);
          });
        },
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Text: ${currentResult?.text ?? 'Not found'}'),
                Text('Format: ${currentResult?.barcodeFormat ?? 'Not found'}'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}