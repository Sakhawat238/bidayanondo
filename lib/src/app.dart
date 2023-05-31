import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home/home_page.dart';
import 'screens/auth/login_page.dart';

class App extends StatelessWidget {

  const App({super.key});

   Future<bool?> loadAuthData() async {
     SharedPreferences sp = await SharedPreferences.getInstance();
     return sp.getBool('auth');
   }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bidyanondo',
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: loadAuthData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              return const HomePage();
            } else {
              return const LoginPage();
            }
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}
