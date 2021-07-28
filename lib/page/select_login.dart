import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/page/login.dart';
import 'package:flutter_rrs_app/page/signup.dart';
import 'package:flutter_rrs_app/utility/my_style.dart';

class SelectLogin extends StatefulWidget {
  @override
  _SelectLoginState createState() => _SelectLoginState();
}

class _SelectLoginState extends State<SelectLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        MyStyle().showLogo(),
        MyStyle().mySizebox(),
        selectLogin(),
        MyStyle().mySizebox(),
        selectSignup(),
        MyStyle().mySizebox(),
        MyStyle().mySizebox(),
        MyStyle().showLogotable()
      ],
    ));
  }

  Padding selectLogin() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: kprimary,
            onPrimary: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Login()));
          },
          child: Text(
            'Login',
            style: TextStyle(fontSize: 20),
          )),
    );
  }

  Padding selectSignup() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: kprimary,
            onPrimary: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Signup()));
          },
          child: Text(
            'Sign Up ',
            style: TextStyle(fontSize: 20),
          )),
    );
  }
}
