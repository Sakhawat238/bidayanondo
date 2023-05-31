import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../home/home_page.dart';

class LoginPage extends StatefulWidget {

  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  String email = "";
  String password = "";

  final loginFormKey = GlobalKey<FormState>();
  bool _autoValidateLoginForm = false;
  bool _shouldObscureText = true;

  void toggleObscureFlag() {
    setState(() {
      _shouldObscureText = !_shouldObscureText;
    });
  }

  saveAuthData(bool value) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool('auth', value);
  }

  void login() {
    if (email == 'ab@xy.com' && password == '1234') {
      saveAuthData(true);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) {
            return const HomePage();
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Form(
                key: loginFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    emailField(),
                    const SizedBox(
                      height: 10.0,
                    ),
                    passwordField(),
                    const SizedBox(
                      height: 25.0,
                    ),
                    loginButton(),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget emailField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Shop ID',
        hintText: 'Enter your shop id here',
        icon: Icon(
          Icons.storefront,
          color: Colors.black87,
        ),
        labelStyle: TextStyle(
          color: Colors.black87,
        ),
        contentPadding: EdgeInsets.only(bottom: 10.0),
      ),
      keyboardType: TextInputType.emailAddress,
      autovalidateMode: AutovalidateMode.disabled,
      validator: (String? value) {
        if (value!.length < 6 ) {
          return null;
        } else {
          return 'Shop ID is invalid';
        }
      },
      onSaved: (String? value) {
        email = value!;
      },
    );
  }

  Widget passwordField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Pin',
        labelStyle: const TextStyle(
          color: Colors.black87,
        ),
        icon: const Icon(
          Icons.lock,
          color: Colors.black87,
        ),
        suffix: GestureDetector(
          onTap: toggleObscureFlag,
          child: _shouldObscureText
              ? const Icon(FontAwesomeIcons.solidEye)
              : const Icon(FontAwesomeIcons.solidEyeSlash),
        ),
        contentPadding: const EdgeInsets.only(
          bottom: 10.0,
        ),
      ),
      obscureText: _shouldObscureText,
      validator: (String? value) {},
      onSaved: (String? value) {
        password = value!;
      },
    );
  }

  Widget loginButton() {
    return ListTile(
      title: ElevatedButton(
        onPressed: () {
          if (loginFormKey.currentState!.validate()) {
            loginFormKey.currentState!.save();
            login();
          } else {
            setState(() {
              _autoValidateLoginForm = true;
            });
          }
        },
        style: const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll<Color>(Colors.cyan),
          foregroundColor: MaterialStatePropertyAll<Color>(Colors.white),
        ),
        child: const Text('Login'),
      ),
    );
  }

}
