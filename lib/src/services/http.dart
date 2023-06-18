import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpService {
  final String baseURL = "http://192.168.30.87:8000/api/";

  Future<bool> storeLogin(String code, String password) async {
    final response = await http.post(
      Uri.parse('${baseURL}store-login/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'code': code,
        'password': password
      }),
    );

    if (response.statusCode == 200) {
      if (jsonDecode(response.body)["status"] == 200) {
        return true;
      }
      return false;
    }
    return false;
  }

  Future<http.Response> getQrData(String code, String timestamp, int quantity) async {
    final response = await http.post(
      Uri.parse('${baseURL}qr-search/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'code': code,
        'timestamp': timestamp,
        'quantity': quantity
      }),
    );

    http.Response res = response;
    return res;
  }

  Future<bool> claimReward(String code, String timestamp, int quantity, String store, List<int> rewards) async {
    final response = await http.post(
      Uri.parse('${baseURL}claim-reward/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'code': code,
        'timestamp': timestamp,
        'quantity': quantity,
        'store': store,
        'rewards': rewards
      }),
    );

    if (response.statusCode == 200) {
      if (jsonDecode(response.body)["success"] == true) {
        return true;
      }
      return false;
    }
    return false;
  }


}