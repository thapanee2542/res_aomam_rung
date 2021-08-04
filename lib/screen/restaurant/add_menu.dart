import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/utility/my_constant.dart';
import 'package:flutter_rrs_app/utility/normal_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddMenu extends StatefulWidget {
  AddMenu({Key? key}) : super(key: key);

  @override
  _AddMenuState createState() => _AddMenuState();
}

class _AddMenuState extends State<AddMenu> {
  String? foodMenuName, foodMenuPrice, foodMenuPicture, foodMenuDescrip;
  String? foodMenuStatus = 'true';
  final _formkey = GlobalKey<FormState>();

  File? file;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xffF1B739),
          title: Text('Add menu'),
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
                  "Food name",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 5,
                ),
                formFoodName(),
                SizedBox(
                  height: 25,
                ),
                Text(
                  "Price",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 5,
                ),
                formFoodPrice(),
                SizedBox(
                  height: 25,
                ),
                Text(
                  "Add images",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 5,
                ),
                addImages(context),
                SizedBox(
                  height: 25,
                ),
                Text(
                  "Food description",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 5,
                ),
                formFoodDescription(),
                SizedBox(
                  height: 25,
                ),
                saveButton(),
              ],
            ),
          )),
        ));
  }

  Widget formFoodDescription() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) return 'Food description is required.';
        return null;
      },
      keyboardType: TextInputType.number,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onSaved: (value) => foodMenuDescrip = value,
      onChanged: (value) {
        setState(() {
          foodMenuDescrip = value;
        });
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10), border: OutlineInputBorder()),
    );
  }

  Column addImages(BuildContext context) {
    return Column(
      children: [
        Container(
          child: file == null
              ? addIcon(context)
              : Stack(children: [
                  Image.file(
                    file!,
                    fit: BoxFit.cover,
                    width: 150,
                    height: 150,
                  ),
                  Positioned(
                    right: 5,
                    top: 5,
                    child: InkWell(
                      child: Icon(
                        Icons.change_circle,
                        size: 20,
                        color: Colors.red,
                      ),
                      onTap: () {
                        show_ModalBottomSheet(context);
                      },
                    ),
                  )
                ]),
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            //borderRadius: BorderRadius.all(Radius.circular(20)),
            border: Border.all(color: Colors.grey),
          ),
        ),
      ],
    );
  }

  IconButton addIcon(BuildContext context) {
    return IconButton(
        onPressed: () {
          show_ModalBottomSheet(context);
        },
        icon: Icon(
          Icons.add,
          color: Colors.grey,
          size: 40,
        ));
  }

  Future<dynamic> show_ModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.camera),
                  title: Text("Camera"),
                  onTap: () => chooseImage(ImageSource.camera),
                ),
                ListTile(
                  leading: Icon(Icons.image),
                  title: Text("Gallery"),
                  onTap: () => chooseImage(ImageSource.gallery),
                ),
              ],
            ),
          );
        });
  }

  Future<Null> chooseImage(ImageSource imageSource) async {
    try {
      ImagePicker picker = ImagePicker();
      var object = await picker.pickImage(
        source: imageSource,
        maxHeight: 800.0,
        maxWidth: 800.0,
      );
      setState(() {
        file = File(object!.path);
      });
    } catch (e) {}
  }

  Future<Null> uploadImage() async {
    Random random = Random();
    int i = random.nextInt(1000000);
    String nameImage = 'foodMenuPicture_$i.jpg';
    String url = '${Myconstant().domain}/res_reserve/upload_foodmenu_picture.php';
    try {
      Map<String, dynamic> map = Map();
      map['file'] =
          await MultipartFile.fromFile(file!.path, filename: nameImage);

      FormData formData = FormData.fromMap(map);
      await Dio().post(url, data: formData).then((value) {
        print('Response ==> $value');
        foodMenuPicture =
            '/res_reserve/foodMenuPicture/$nameImage';
        print('urltablePic = $foodMenuPicture');
       addFoodMenuThread();
      });
    } catch (e) {}
  }

  Future<Null> addFoodMenuThread() async {

   //ดึงค่าของ restaurantId ออกมา 
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? restaurantId = preferences.getString('restaurantId');

    String? url = '${Myconstant().domain}/res_reserve/add_foodmenu_info.php?isAdd=true&restaurantId=$restaurantId&foodMenuName=$foodMenuName&foodMenuPrice=$foodMenuPrice&foodMenuPicture=$foodMenuPicture&foodMenuDescrip=$foodMenuDescrip&foodMenuStatus=$foodMenuStatus';

    try {
      Response response = await Dio().get(url);
      print('res = $response');
      if(response.toString()== 'true'){
        Navigator.pop(context);
      }else{
        normalDialog(context, 'Try again');
      }
    } catch (e) {
    }

  }

  //ช่องกรอกราคาอาหาร
  Widget formFoodPrice() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) return 'Food price is required.';
        return null;
      },
      keyboardType: TextInputType.number,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onSaved: (value) => foodMenuPrice = value,
      onChanged: (value) {
        setState(() {
          foodMenuPrice = value;
        });
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10), border: OutlineInputBorder()),
    );
  }

  //ช่องกรอกชื่ออาหาร
  Widget formFoodName() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) return 'Food name is required.';
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onSaved: (value) => foodMenuName = value,
      onChanged: (value) {
        setState(() {
          foodMenuName = value;
        });
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10), border: OutlineInputBorder()),
    );
  }

  
  Widget saveButton() => Container(
        width: MediaQuery.of(context).size.width,
  
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Color(0xffF1B739),
          ),
          child: Text('save',style: TextStyle(fontSize: 16),),
          onPressed: () {
            if (_formkey.currentState!.validate()) {
              uploadImage();
              // print(
              //     'tableId =$tableResId,tableName =$tableName,tableNumseat=$tableNumseat,tabledes=$tableDescrip,tablePicOne=$tablePicOne');
            }
          },
        ),
      );
}
