import 'package:flutter/material.dart';

class SignupRes extends StatefulWidget {
  SignupRes({Key? key}) : super(key: key);

  @override
  _LoginMenuState createState() => _LoginMenuState();
}

class _LoginMenuState extends State<SignupRes> {
  final _formKey = GlobalKey<FormState>();
  var username, password, confirm_password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sign up',
          style: TextStyle(fontSize: 30),
        ),
        toolbarHeight: 200,
        flexibleSpace: Image(
          image: AssetImage('images/pic_login.jpg'),
          fit: BoxFit.cover,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded),
        ),
        //centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InputUsername(),
                SizedBox(
                  height: 20,
                ),
                InputPassword(),
                SizedBox(
                  height: 20,
                ),
                InputConfirmPassword(),
                SizedBox(
                  height: 20,
                ),
                SignupButton(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget InputUsername() {
    return  TextFormField(
        onChanged: (value) => username = value
            .trim(), //ถ้ากรอก Username ค่าที่กรอกจะอยู่ใน value โดยให้ตัวแปร Username = value.trim คือตัดช่องว่างข้างหน้าและหลังข้อความออก
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter username';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: "Username",
          
          prefixIcon: Icon(Icons.account_circle_rounded),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 5.0),
            borderRadius: BorderRadius.circular(36),
          ),
        )
      );
    
  }

  Widget InputPassword() {
    return TextFormField(
        onChanged: (value) => password = value
            .trim(), //ถ้ากรอก Password ค่าที่กรอกจะอยู่ใน value โดยให้ตัวแปร password = value.trim คือตัดช่องว่างข้างหน้าและหลังข้อความออก
         validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter password';
          }
          else if(value.length < 8){
            return 'Password must be at least 8 characters long.';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: "Password",
          prefixIcon: Icon(Icons.lock),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 5.0),
            borderRadius: BorderRadius.circular(36),
          ),
        ),
      );
  }

  Widget InputConfirmPassword() {
    return  TextFormField(
        onChanged: (value) => confirm_password = value
            .trim(), //ถ้ากรอก Confirm Password ค่าที่กรอกจะอยู่ใน value โดยให้ตัวแปร confirm_password = value.trim คือตัดช่องว่างข้างหน้าและหลังข้อความออก
        validator: (value){
          if(value == null || value.isEmpty){
            return 'Please enter confirm password';
          }
          else if(confirm_password != password){
            return 'Passwords do not match';
          }
        },
        
        decoration: InputDecoration(
          labelText: "Confirm Password",
          prefixIcon: Icon(Icons.lock),
           border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 5.0),
            borderRadius: BorderRadius.circular(36),
          ),
        ),
      );
  }

  Container SignupButton(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 40,
        child: ElevatedButton(
          child: Text(
            'Sign up',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
              primary: Color(0xffF1B739),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              )),
          onPressed: () {
            print(
                'Username = $username,Password = $password,Confirm password = $confirm_password');
            if (_formKey.currentState!.validate()) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('Processing Data')));
            }
          },
        ));
  }
}
