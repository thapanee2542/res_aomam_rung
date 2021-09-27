import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/utility/my_constant.dart';
import 'package:flutter_rrs_app/utility/normal_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AddTable extends StatefulWidget {
  AddTable({Key? key}) : super(key: key);

  @override
  _AddTableState createState() => _AddTableState();
}

class _AddTableState extends State<AddTable> {
  File? file;
  final _formkey = GlobalKey<FormState>();
  String? tableName, tableDescrip, tablePicOne;
  String? tableResId, tableNumseat;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xffF1B739),
          title: Text('Add table'),
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
                    saveButton(),
                  ],
                ),
              )),
        ));
  }

  Widget saveButton() => Container(
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Color(0xffF1B739),
          ),
          child: Text('save'),
          onPressed: () {
            if (_formkey.currentState!.validate()) {
              if (file == null) {
                normalDialog(context, 'please insert a picture');
              } else {
                checkTableNumber();
              }
              print(
                  'tableId =$tableResId,tableName =$tableName,tableNumseat=$tableNumseat,tabledes=$tableDescrip,tablePicOne=$tablePicOne');
            }
          },
        ),
      );

Future<Null> checkTableNumber () async{

   //ดึงค่าของ restaurantId ออกมา 
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? restaurantId = preferences.getString('restaurantId');

   String url = '${Myconstant().domain}/res_reserve/getTableNumberWhereRestaurantId.php?isAdd=true&restaurantId=$restaurantId&tableResId=$tableResId';
   try {
     await Dio().get(url).then((value){
       if(value.toString() == 'null'){
           uploadImage();
       }else{
         normalDialog(context, 'This table number already exists. Please change the table number.');
       }
     });
   } catch (e) {
   }
}      

  Widget formTableDescription() {
    return TextFormField(
      onSaved: (value) => tableDescrip = value,
      onChanged: (value) {
        setState(() {
          tableDescrip = value;
        });
      },
      //minLines: 1,
      // maxLines: null,
      //  expands: true,
      //keyboardType: TextInputType.multiline,
      // textInputAction: TextInputAction.newline,
      textAlignVertical: TextAlignVertical.center,
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

  //ช่องกรอกจำนวนที่นั่ง
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
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10), border: OutlineInputBorder()),
    );
  }

  //ช่องกรอกหมายเลขโต๊ะ
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
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10), border: OutlineInputBorder()),
    );
  }

  //ช่องกรอกชื่อโต๊ะ
  Widget formTableName() {
    return TextFormField(
      //  textAlignVertical: TextAlignVertical.center,
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
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10), border: OutlineInputBorder()),
    );
  }

  Future<Null> addTableTread() async {

    //ดึงค่าของ restaurantId ออกมา 
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? restaurantId = preferences.getString('restaurantId');


    String url =
        '${Myconstant().domain}/res_reserve/add_table_info.php?isAdd=true&tableName=$tableName&tableResId=$tableResId&restaurantId=$restaurantId&tableNumseat=$tableNumseat&tableDescrip=$tableDescrip&tablePicOne=$tablePicOne';
    try {
      Response response = await Dio().get(url);
      print('res = $response');
      if (response.toString() == 'true') {
        Navigator.pop(context);
      } else
        print('ERROR');
    } catch (e) {}
  }

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
        tablePicOne =
            '/res_reserve/tablePicOne/$nameImage';
        print('urltablePic = $tablePicOne');
        addTableTread();
      });
    } catch (e) {}
  }
}
