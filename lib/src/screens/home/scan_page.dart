import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import './home_page.dart';


class ScanPage extends StatefulWidget {
  const ScanPage({Key? key}) : super(key: key);

  @override
  ScanPageState createState() => ScanPageState();
}

class ScanPageState extends State<ScanPage> with SingleTickerProviderStateMixin {

  BarcodeCapture? capture;

  void _redirectToHome(){
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return HomePage(barcodeData : capture?.barcodes.first.rawValue??"");
        },
      ), (Route<dynamic> route) => false
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Builder(
        builder: (context) {
          return Stack(
            children: [
              MobileScanner(
                fit: BoxFit.contain,
                errorBuilder: (context, error, child) {
                  return Container();
                },
                onDetect: (capture) {
                  setState(() {
                    this.capture = capture;
                  });
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  alignment: Alignment.bottomCenter,
                  height: 200,
                  color: Colors.black.withOpacity(1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 120,
                          height: 100,
                          child: FittedBox(
                            child: Text(
                              capture?.barcodes.first.rawValue ??
                                  'Scan something!',
                              overflow: TextOverflow.fade,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _redirectToHome,
                        child: const Text("Continue"),
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}