import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/model/foodmenu_mode.dart';
import 'package:flutter_rrs_app/utility/my_constant.dart';
import 'package:flutter_rrs_app/utility/normal_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditFoodMenu extends StatefulWidget {
  final FoodMenuModel? foodMenuModel;
  EditFoodMenu({Key? key, this.foodMenuModel}) : super(key: key);

  @override
  _EditFoodMenuState createState() => _EditFoodMenuState();
}

class _EditFoodMenuState extends State<EditFoodMenu> {
  FoodMenuModel? foodMenuModel;
  String? foodMenuName, foodMenuPrice, foodMenuPicture, foodMenuDescrip;
  String? foodMenuStatus = 'true';
  final _formkey = GlobalKey<FormState>();
  File? file;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    foodMenuModel = widget.foodMenuModel;
    foodMenuName = foodMenuModel!.foodMenuName;
    foodMenuPrice = foodMenuModel!.foodMenuPrice;
    foodMenuPicture = foodMenuModel!.foodMenuPicture;
    foodMenuDescrip = foodMenuModel!.foodMenuDescrip;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: saveButton(),
        appBar: AppBar(
          backgroundColor: Color(0xffF1B739),
          title: Text('Edit menu ${foodMenuModel?.foodMenuName}'),
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
                  ],
                ),
              )),
        ));
  }

  Widget formFoodName() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) return 'Food name is required.';
        return null;
      },
      initialValue: foodMenuModel!.foodMenuName,
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

  Future<Null> uploadImage() async {
    Random random = Random();
    int i = random.nextInt(1000000);
    String nameImage = 'foodMenuPicture_$i.jpg';
    String url =
        '${Myconstant().domain}/res_reserve/upload_foodmenu_picture.php';
    try {
      Map<String, dynamic> map = Map();
      map['file'] =
          await MultipartFile.fromFile(file!.path, filename: nameImage);

      FormData formData = FormData.fromMap(map);
      await Dio().post(url, data: formData).then((value) {
        print('Response ==> $value');
        foodMenuPicture = '/res_reserve/foodMenuPicture/$nameImage';
        print('urltablePic = $foodMenuPicture');
        editValueOnMySQL();
      });
    } catch (e) {}
  }

  Widget formFoodPrice() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) return 'Food price is required.';
        return null;
      },
      initialValue: foodMenuModel!.foodMenuPrice,
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

  Widget formFoodDescription() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty)
          return 'Food description is required.';
        return null;
      },
      initialValue: foodMenuModel!.foodMenuDescrip,
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
              ? Stack(children: [
                  Image.network(
                    '${Myconstant().domain}${foodMenuModel?.foodMenuPicture}',
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
                        size: 30,
                        color: Colors.red,
                      ),
                      onTap: () {
                        show_ModalBottomSheet(context);
                      },
                    ),
                  )
                ])
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
                        size: 30,
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

  Future<Null> editValueOnMySQL() async {
    String? foodMenuId = foodMenuModel!.foodMenuId;
    String? url =
        '${Myconstant().domain}/res_reserve/editFoodWhereId.php?isAdd=true&foodMenuId=$foodMenuId&foodMenuName=$foodMenuName&foodMenuPrice=$foodMenuPrice&foodMenuPicture=$foodMenuPicture&foodMenuDescrip=$foodMenuDescrip';
    await Dio().get(url).then((value) {
      if (value.toString() == 'true') {
        Navigator.pop(context);
      } else {
        normalDialog(context, 'failed try again');
      }
    });
  }

  FloatingActionButton saveButton() => FloatingActionButton(
        onPressed: () {
         file != null ? uploadImage() : editValueOnMySQL();
        },
        child: Icon(Icons.save),
      );
}
