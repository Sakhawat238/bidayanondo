import 'dart:core';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth/login_page.dart';
import './scan_page.dart';
import '../../services/http.dart';
import '../../model.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key, this.barcodeData=""}) : super(key: key);

  final String barcodeData;

  @override
  HomePageState createState() => HomePageState();
}


class HomePageState extends State<HomePage> {

  final HttpService _httpService = HttpService();

  String _code = "";
  String _timestamp = "";
  int _quantity = 0;
  String _rewardStatus = "P"; // P = pending, N = None, A = Available
  String _noRewardMessage = "No reward available";
  final List<Reward> _rewards = List.empty(growable: true);
  List<bool> checkList = List.empty(growable: true);
  Set<int> selectedRewards = {};


  void _parseData(String data) {
    if(data != "") {
      List<String> items = data.split("\n");
      _code = items[0];
      _timestamp = items[1];
      _quantity = int.parse(items[2]);
    }
  }

  void _processData() async {
    if(widget.barcodeData != "") {
      Response resObj = await _httpService.getQrData(_code, _timestamp, _quantity);
      var res = jsonDecode(resObj.body);
      if (res["status"] == 400) {
        _noRewardMessage = res["message"];
        setState(() {
          _rewardStatus = "N";
        });
      }

      var data = res["data"];
      for (var el in data) {
        Reward rew = Reward(el["item_id"], el["item__description"]);
        _rewards.add(rew);
        checkList.add(false);
      }

      setState(() {
        _rewardStatus = "A";
      });
    }
  }

  void _parseAndProcessBarcodeData(String data) {
    _parseData(data);
    _processData();
  }

  void _updateSelectedRewards(int id, bool value, int index) {
    if(value) {
      selectedRewards.add(id);
    } else {
      selectedRewards.remove(id);
    }
    setState(() {
      checkList[index] = value!;
    });
  }

  void _submitSelectedRewards() {
    for (int element in selectedRewards) {
      String el = element.toString();
      debugPrint(el);
    }
  }


  @override
  void initState(){
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
      body: _rewardStatus == "P" ?
          defaultHomeWidget() :
          _rewardStatus == "N" ?
            noRewardWidget() :
            rewardAvailableWidget(),
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

  Widget defaultHomeWidget() {
    return const Center(
      widthFactor: 2,
      heightFactor: 30,
      child: Text(
        "Please scan a QR code to continue..",
        style: TextStyle(
          color: Colors.black45,
          fontSize: 20,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }


  Widget noRewardWidget() {
    return Center(
      widthFactor: 2,
      heightFactor: 30,
      child: Text(
        _noRewardMessage,
        style: const TextStyle(
          color: Colors.black45,
          fontSize: 20,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }


  Widget rewardAvailableWidget() {
    return Column(
      children: <Widget>[
        const Center(
          child: Padding(
            padding: EdgeInsets.fromLTRB(2, 10, 2, 5),
            child: Text(
              "Here are the available rewards :",
              style: TextStyle(
                  color: Colors.deepOrange,
                  fontSize: 20
              ),
            ),
          ),
        ),
        for(int i=0;i<_rewards.length;i++)
          Column(
            children: [
              CheckboxListTile(
                title: Text(_rewards[i].text),
                value: checkList[i],
                onChanged: (bool? value) {
                  _updateSelectedRewards(_rewards[i].id, value!, i);
                },
              ),
              const Divider(height: 1),
            ],
          ),
        Center(
          child: ElevatedButton(
            onPressed: _submitSelectedRewards,
            child: const Text(
              "Continue"
            ),
          ),
        ),
      ],
    );
  }
}
