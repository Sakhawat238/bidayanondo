import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import './home_page.dart';


class ScanPage extends StatelessWidget {
  const ScanPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      // fit: BoxFit.contain,
      onDetect: (capture) {
        final List<Barcode> barcodes = capture.barcodes;
        final Uint8List? image = capture.image;
        // for (final barcode in barcodes) {
          debugPrint('Barcode found! ${barcodes[0].rawValue}');
        // }
        // Navigator.of(context).pushReplacement(
        //   MaterialPageRoute(
        //     builder: (BuildContext context) {
        //       return const HomePage();
        //     },
        //   ),
        // );
      },
    );
  }
}
