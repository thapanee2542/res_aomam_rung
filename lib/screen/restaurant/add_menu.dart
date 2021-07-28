import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';




class AddMenu extends StatefulWidget {
  AddMenu({Key? key}) : super(key: key);

  @override
  _AddMenuState createState() => _AddMenuState();
}

class _AddMenuState extends State<AddMenu> {
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
              ],
            ),
          )),
        )
    );
  }


Container formFoodDescription() {
    return Container(
                height: 40,
                child: TextFormField(
                  //minLines: 1,
                 // maxLines: null,
                //  expands: true,
                  //keyboardType: TextInputType.multiline,
                 // textInputAction: TextInputAction.newline,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      border: OutlineInputBorder()),
                ),
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
      var object = await picker.getImage(
        source: imageSource,
        maxHeight: 800.0,
        maxWidth: 800.0,
      );
      setState(() {
        file = File(object!.path);
      });
    } catch (e) {}
  }

  

  //ช่องกรอกราคาอาหาร
  Container formFoodPrice() {
    return Container(
      height: 40,
      child: TextFormField(
        textAlignVertical: TextAlignVertical.center,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(10), border: OutlineInputBorder()),
      ),
    );
  }

  //ช่องกรอกชื่ออาหาร
  Container formFoodName() {
    return Container(
      height: 40,
      child: TextFormField(
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(10), border: OutlineInputBorder()),
      ),
    );
  }
}
