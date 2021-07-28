import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/model/tableres_model.dart';
import 'package:flutter_rrs_app/utility/my_constant.dart';
import 'package:flutter_rrs_app/utility/normal_dialog.dart';
import 'package:image_picker/image_picker.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: saveButton(),
        appBar: AppBar(
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
                    //saveButton(),
                  ],
                ),
              )),
        ));
  }

  FloatingActionButton saveButton() => FloatingActionButton(
        onPressed: (){
          editValueOnMySQL();
        },
        child: Icon(Icons.save),
      );

   

  Future<Null> editValueOnMySQL() async {
     String? url = '${Myconstant().domain}/res_reserve/editTableWhereId.php?isAdd=true&tableId=${tableResModel!.tableId}&tableResId=$tableResId&tableName=$tableName&tableNumseat=$tableNumseat&tableDescrip=$tableDescrip&tablePicOne=$tablePicOne';
     await Dio().get(url).then((value){
       if (value.toString() == 'true') {
         Navigator.pop(context);
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
            tableName = value;
          });
        },
        initialValue: tableResModel?.tableName,
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
              : Image.file(file!),
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
