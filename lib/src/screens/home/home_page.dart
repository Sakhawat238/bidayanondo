import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth/login_page.dart';

class HomePage extends StatelessWidget {

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        backgroundColor: Colors.cyan,
      ),
      body: Container(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.close),
        onPressed: () async {
          SharedPreferences sp = await SharedPreferences.getInstance();
          sp.setBool('auth', false);
          if (context.mounted) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return const LoginPage();
                },
              ),
                  (Route<dynamic> route) => false,
            );
          }
        },
      ),
    );
  }
}
