import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/screen/restaurant/signup_res.dart';


class LoginMenu extends StatefulWidget {
  LoginMenu({Key? key}) : super(key: key);

  @override
  _LoginMenuState createState() => _LoginMenuState();
}

class _LoginMenuState extends State<LoginMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 200,
        flexibleSpace: Image(
          image: AssetImage('images/pic_login.jpg'),
          fit: BoxFit.cover,
        ),
        //centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextLogin(),
              SizedBox(height: 20,),
              InputUsername(),
              SizedBox(height: 20,),
              InputPassword(),
              SizedBox(height: 50,),
              LoginButton(context),
              SizedBox(height: 20,),
              Text("Don't have an account?",style: TextStyle(fontSize: 15),),
              SizedBox(height: 20,),
              SignupButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Container InputPassword() {
    return Container(
          height: 55,
          decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(36)),
          child: TextFormField(
              decoration: InputDecoration(
                labelText: "Password",
                prefixIcon: Icon(Icons.lock),
                border: InputBorder.none,
              ),
            ),
        );
  }

  Container InputUsername() {
    return Container(
            height: 55,
            decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(36)),
            child: TextFormField(
                decoration: InputDecoration(
                  labelText: "Username",
                  prefixIcon: Icon(Icons.account_circle_rounded),
                  border: InputBorder.none,
                ),
              ),
          );
  }

  Row TextLogin() {
    return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Login to your account',style: TextStyle(fontSize: 25),),
            ],
          );
  }

  Container SignupButton(BuildContext context) {
    return Container(
            width: MediaQuery.of(context).size.width,
            height: 40,
            child: ElevatedButton(
              child: Text('Sign up',style: TextStyle(fontSize: 20,color:Color(0xffF1B739) ),),
              style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  )),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>SignupRes()));
              },
              
            ));
  }

  Container LoginButton(BuildContext context) {
    return Container(
            width: MediaQuery.of(context).size.width,
            height: 40,
            
            child: ElevatedButton(
              child: Text('Login',style: TextStyle(fontSize: 20),),
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  primary: Color(0xffF1B739),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  )),
            ));
  }
}
