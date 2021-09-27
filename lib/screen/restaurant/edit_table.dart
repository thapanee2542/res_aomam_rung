import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/model/tableres_model.dart';
import 'package:flutter_rrs_app/screen/restaurant/my_shop_page.dart';
import 'package:flutter_rrs_app/utility/my_constant.dart';
import 'package:flutter_rrs_app/utility/normal_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditTable extends StatefulWidget {
  final TableResModel? tableResModel;
  EditTable({Key? key, this.tableResModel}) : super(key: key);

  @override
  _EditTableState createState() => _EditTableState();
}

class _EditTableState extends State<EditTable> {
  final _formkey = GlobalKey<FormState>();
  TableResModel? tableResModel;
  File? file;
  String? tableName, tableDescrip, tablePicOne, tableResId, tableNumseat;

  @override
  void initState() {
    // รับค่าจากตัวแปรเข้ามา
    super.initState();
    tableResModel = widget.tableResModel;
    tableName = tableResModel!.tableName;
    tableResId = tableResModel!.tableResId;
    tableNumseat = tableResModel!.tableNumseat;
    tablePicOne = tableResModel!.tablePicOne;
    tableDescrip = tableResModel!.tableDescrip;
    print('tablename = $tableName');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: saveButton(),
        appBar: AppBar(
          backgroundColor: Color(0xffF1B739),
          title: Text(
              'Edit table ${tableResModel?.tableResId} ${tableResModel?.tableName}'),
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
                      "Table name",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    formTableName(),
                    SizedBox(
                      height: 25,
                    ),
                    Text(
                      "Table number",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    formTableNumber(),
                    SizedBox(
                      height: 25,
                    ),
                    Text(
                      "Number of seats",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    formNumSeat(),
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
                      "Table description",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    formTableDescription(),
                    SizedBox(
                      height: 25,
                    ),
                  ],
                ),
              )),
        ));
  }

  FloatingActionButton saveButton() => FloatingActionButton(
        onPressed: () {
        //  print('pic = $tablePicOne');
          print('tableNameEdit = $tableName');
          //editValueOnMySQL();


          if(tableResId != tableResModel?.tableResId){
            checkTableNumber();
          }
          else{
             file == null ? editValueOnMySQL() : uploadImage();
          }

          // //ถ้าหมายเลขโต๊ะมีเปลี่ยนแปลง และ รูปภาพไม่มีการเปลี่ยนแปลง ให้ทำการตรวจสอบหมายเลขโต๊ะว่าซ้ำหรือไม่
          // if (tableResId != tableResModel?.tableResId && file == null) {
          //   checkTableNumber();

          // //ถ้าหมายเลขโต๊ะไม่มีการเปลี่ยนแปลง และ รูปภาพมีการเปลี่ยนแปลง ให้ทำการอัปดหลดรูปภาพนั้น
          // }else if(tableResId == tableResModel?.tableResId && file != null ){
          //  uploadImage();
          //  editValueOnMySQL();
          // }

          // //ถ้าหมายเลขโต๊ะและรูปภาพมีการเปลี่ยนแปลง ให้อัปโหละรูปภาพ แล้ว แก้ไขค่า
          // else if (tableResId != tableResModel?.tableResId && file != null) {
          //   uploadImage();
          //   editValueOnMySQL();
          // }
          // tableResId != null ? checkTableNumber() : file == null ? editValueOnMySQL() : uploadImage();

          //  file == null ? editValueOnMySQL() : uploadImage();
          // tableResId == null ? editValueOnMySQL()  : checkTableNumber();
        },
        child: Icon(Icons.save),
      );

  Future<Null> uploadImage() async {
    Random random = Random();
    int i = random.nextInt(1000000);
    String nameImage = 'tablePicOne_$i.jpg';
    String url = '${Myconstant().domain}/res_reserve/upload_table_picture.php';
    try {
      Map<String, dynamic> map = Map();
      map['file'] =
          await MultipartFile.fromFile(file!.path, filename: nameImage);

      FormData formData = FormData.fromMap(map);
      await Dio().post(url, data: formData).then((value) {
        print('Response ==> $value');
        tablePicOne = '/res_reserve/tablePicOne/$nameImage';
        print('urltablePic = $tablePicOne');
        editValueOnMySQL();
      });
    } catch (e) {}
  }

  Future<Null> checkTableNumber() async {
    //ดึงค่าของ restaurantId ออกมา
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? restaurantId = preferences.getString('restaurantId');

    String url =
        '${Myconstant().domain}/res_reserve/getTableNumberWhereRestaurantId.php?isAdd=true&restaurantId=$restaurantId&tableResId=$tableResId';
    try {
      await Dio().get(url).then((value) {
        if (value.toString() == 'null') {
          file == null ? editValueOnMySQL() : uploadImage();
        } else {
          normalDialog(context,
              'This table number already exists. Please change the table number.');
        }
      });
    } catch (e) {}
  }

  Future<Null> editValueOnMySQL() async {
    String? url =
        '${Myconstant().domain}/res_reserve/editTableWhereId.php?isAdd=true&tableId=${tableResModel!.tableId}&tableResId=$tableResId&tableName=$tableName&tableNumseat=$tableNumseat&tableDescrip=$tableDescrip&tablePicOne=$tablePicOne';
    await Dio().get(url).then((value) {
      if (value.toString() == 'true') {
        Navigator.pop(context);
        normalDialog(context, 'Edit complete');
       
      } else {
        normalDialog(context, 'failed try again');
      }
    });
  }

  Widget formTableName() => TextFormField(
        textAlignVertical: TextAlignVertical.center,
        validator: (value) {
          if (value == null || value.isEmpty) return 'Table name is required.';
          return null;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onSaved: (value) => tableName = value,
        onChanged: (value) {
          setState(() {
            tableName = value ;
          });
        },
        initialValue: tableName,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(10), border: OutlineInputBorder()),
      );

  Widget formNumSeat() {
    return TextFormField(
      textAlignVertical: TextAlignVertical.center,
      validator: (value) {
        if (value == null || value.isEmpty)
          return 'Number of seats is required.';
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onSaved: (value) => tableNumseat = value,
      onChanged: (value) {
        setState(() {
          tableNumseat = value;
        });
      },
      initialValue: tableResModel?.tableNumseat,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10), border: OutlineInputBorder()),
    );
  }

  Widget formTableNumber() {
    return TextFormField(
      textAlignVertical: TextAlignVertical.center,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Table number is required.';
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onSaved: (value) => tableResId = value,
      onChanged: (value) {
        setState(() {
          tableResId = value;
        });
      },
      initialValue: tableResModel?.tableResId,
      keyboardType: TextInputType.number,
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
                    '${Myconstant().domain}${tableResModel?.tablePicOne}',
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

  Widget formTableDescription() {
    return TextFormField(
      onSaved: (value) => tableDescrip = value,
      onChanged: (value) {
        setState(() {
          tableDescrip = value;
        });
      },
      // minLines: 1,
      // maxLines: null,
      //  expands: true,
      // keyboardType: TextInputType.multiline,
      // textInputAction: TextInputAction.newline,
      initialValue: tableResModel?.tableDescrip,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10), border: OutlineInputBorder()),
    );
  }
}
