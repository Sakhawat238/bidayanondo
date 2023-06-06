import 'dart:core';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth/login_page.dart';
import './scan_page.dart';


class Reward {
  int id;
  String text;

  Reward(this.id, this.text);
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, this.barcodeData=""}) : super(key: key);

  final String barcodeData;

  @override
  HomePageState createState() => HomePageState();
}


class HomePageState extends State<HomePage> {

  String _code = "";
  String _timestamp = "";
  int _quantity = 0;
  final List<Reward> _rewards = List.empty(growable: true);
  List<bool> checkList = List.empty(growable: true);

  //Dummy data
  List<Reward> tempList = [
    Reward(100, "1 kg Rice"),
    Reward(101, "2 kg Potato"),
    Reward(102, "250 ml Soyabin Oil"),
    Reward(103, "500 gm Sugar"),
    Reward(104 , "1 kg Salt")
  ];
  //End

  void _parseData(String data) {
    if(data != "") {
      List<String> items = data.split("\n");
      _code = items[0];
      _timestamp = items[1];
      _quantity = int.parse(items[2]);
    }
  }

  void _processData() {
    // To do api call
    // Dummy response process
    if(widget.barcodeData != "") {
      for(Reward el in tempList) {
        _rewards.add(el);
        checkList.add(false);
      }
    }
  }

  void _parseAndProcessBarcodeData(String data){
    _parseData(data);
    _processData();
  }

  @override
  void initState() {
    _parseAndProcessBarcodeData(widget.barcodeData);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        backgroundColor: Colors.cyan,
        actions : [
          ElevatedButton(
            onPressed: () async {
              SharedPreferences sp = await SharedPreferences.getInstance();
              sp.setString('auth', "");
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const LoginPage();
                    },
                  ), (Route<dynamic> route) => false,
                );
              }
            },
            child: const Icon(Icons.logout),
          ),
        ]
      ),
      body: Column(
        children: <Widget>[
          Center(
            child: ,
          ),
          for(int i=0;i<_rewards.length;i++)
            Column(
              children: [
                CheckboxListTile(
                  title: Text(_rewards[i].text),
                  value: checkList[i],
                  onChanged: (bool? value) {
                    setState(() {
                      checkList[i] = value!;
                    });
                  },
                ),
                const Divider(height: 1),
              ]
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.qr_code),
        onPressed: (){
          if (context.mounted) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return const ScanPage();
                },
              ),
            );
          }
        },
      ),
    );
  }
}
