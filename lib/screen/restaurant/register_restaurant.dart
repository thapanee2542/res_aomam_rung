import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/model/restaurant_model.dart';
import 'package:flutter_rrs_app/utility/my_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterRestaurant extends StatefulWidget {
  RegisterRestaurant({Key? key}) : super(key: key);

  @override
  _RegisterRestaurantState createState() => _RegisterRestaurantState();
}

class _RegisterRestaurantState extends State<RegisterRestaurant> {
  final _formkey = GlobalKey<FormState>();
  List<RestaurantModel> restaurantModels = [];

  var name;
  //String? ownerName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readRestaurant();
  }

  Future<Null> readRestaurant() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      name = preferences.getString('name');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffF1B739),
        title: Text('Register your restaurant'),
      ),
      body: Container(
        padding: EdgeInsets.all(30),
        child: Form(
          key: _formkey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Shop owner name',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 5,
                ),
                formShopOwnerName(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget formShopOwnerName() {
   

    return TextFormField(
      initialValue: name!,
      readOnly: true,

      decoration: InputDecoration(
        enabled: false,
        border: OutlineInputBorder(),
      ),
    );
  }
}
