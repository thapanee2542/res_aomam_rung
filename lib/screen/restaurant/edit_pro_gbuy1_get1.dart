import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/model/foodmenu_mode.dart';
import 'package:flutter_rrs_app/model/promotion_model.dart';
import 'package:flutter_rrs_app/utility/my_constant.dart';
import 'package:flutter_rrs_app/utility/normal_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class EditProBuyOneGetOneFree extends StatefulWidget {
  final PromotionModel? promotionModel;
  EditProBuyOneGetOneFree({Key? key, this.promotionModel}) : super(key: key);

  @override
  _EditProBuyOneGetOneFreeState createState() =>
      _EditProBuyOneGetOneFreeState();
}

class _EditProBuyOneGetOneFreeState extends State<EditProBuyOneGetOneFree> {
  bool status = false; //มีข้อมูลอาหาร
  bool nextState = false;
  bool loadStatus = true;
  bool? statusFood;
  String? foodMenuStatus;
  final _formkey = GlobalKey<FormState>();
  FoodMenuModel? _foodChoose;
  DateTimeRange? dateRange;
  String? foodMenuId_discount, promotion_old_price, promotion_new_price;
  var txt_oldprice = TextEditingController();
  TextEditingController _oldPrice = TextEditingController();
  TextEditingController _newPrice = TextEditingController();
  TextEditingController dateCtl = TextEditingController();
  TextEditingController dateFinishCtl = TextEditingController();
  TextEditingController timeCtl = TextEditingController();
  TextEditingController timeFinishCtl = TextEditingController();
  String? timeFormat;
  String? dateFormat;
  PromotionModel? promotionModel;
  String? promotionId,
      restaurantId,
      promotionType,
      promotionStartTime,
      promotionFinishTime,
      foodMenuIdDiscount,
      promotionOldPrice,
      promotionNewPrice,
      promotionBuyOne,
      foodMenuIdBuyOne,
      promotionGetOne,
      foodMenuIdGetOne;
  int? promotionDiscount;
  String? promotionStartDate, promotionFinishDate;
  DateTime? startDate, endDate;
  FToast? fToast;

  var selectFood;

  List<FoodMenuModel> foodMenuModels = [];
  List<FoodMenuModel> foodMenuModels2 = [];
  FoodMenuModel? initDropdown;
  bool _statusFoodMenu = true;
  var foodDataSelectBuyOne;
  var foodDataSelectgetOne;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    // readFoodMenu();
    fToast = FToast();
    fToast!.init(context);

    promotionModel = widget.promotionModel;
    promotionId = promotionModel!.promotionId;
    promotionType = promotionModel!.promotionType;
    promotionStartDate = promotionModel!.promotionStartDate.toString();
    promotionStartTime = promotionModel!.promotionStartTime;
    promotionFinishDate = promotionModel!.promotionFinishDate.toString();
    promotionFinishTime = promotionModel!.promotionFinishTime;
    //foodMenuIdDiscount = promotionModel!.foodMenuIdDiscount;
    // promotionDiscount = int.parse(promotionModel!.promotionDiscount.toString());
    promotionOldPrice = promotionModel!.promotionOldPrice.toString();
    promotionNewPrice = promotionModel!.promotionNewPrice.toString();
    // promotionBuyOne = promotionModel!.promotionBuyOne;
    foodMenuIdBuyOne = promotionModel!.foodMenuIdBuyOne;
    // promotionGetOne = promotionModel!.promotionGetOne;
    foodMenuIdGetOne = promotionModel!.foodMenuIdGetOne;
    readFoodMenuBuyOne();
    // readFoodMenuWhereMenuId();
    //_foodChoose = foodMenuModels2;
    //  print('food chose ========$_foodChoose');
    _oldPrice.text = promotionOldPrice.toString();
    _newPrice.text = promotionNewPrice.toString();
    startDate = DateTime.parse(promotionStartDate.toString());
    endDate = DateTime.parse(promotionFinishDate.toString());
    dateCtl.text = DateFormat('dd/MM/yyyy').format(startDate!);
    dateFinishCtl.text = DateFormat('dd/MM/yyyy').format(endDate!);
    timeCtl.text = promotionStartTime.toString();
    timeFinishCtl.text = promotionFinishTime.toString();
  }

  Future<Null> readFoodMenuBuyOne() async {
    var foodMenuId = foodMenuIdBuyOne;
    var url =
        '${Myconstant().domain}/res_reserve/getFoodMenuWhereFoodMenuId.php?isAdd=true&foodMenuId=$foodMenuId';
    await Dio().get(url).then((value) {
      if (value.toString() != 'null') {
        foodDataSelectBuyOne = json.decode(value.data);
        readFoodMenuGetOne();
      }
    });
  }

  Future<Null> readFoodMenuGetOne() async {
    var foodMenuId = foodMenuIdGetOne;
    var url =
        '${Myconstant().domain}/res_reserve/getFoodMenuWhereFoodMenuId.php?isAdd=true&foodMenuId=$foodMenuId';
    await Dio().get(url).then((value) {
      if (value.toString() != 'null') {
        foodDataSelectgetOne = json.decode(value.data);
        setState(() {
          loadStatus = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit promotion'),
          backgroundColor: Color(0xffF1B739),
        ),
        body: loadStatus?showProgress():  Container(
          padding: EdgeInsets.all(30),
          child: Form(
              child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                Text(
                  "Food menu buy 1",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 5,
                ),
                dropdownSelectMenuBuyOne(),
                SizedBox(
                  height: 25,
                ),
                Text(
                  "Food menu get 1 free",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 5,
                ),
                dropdownSelectMenuGetOne(),
                SizedBox(
                  height: 25,
                ),
                Text(
                  "Promotion price",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 5,
                ),
                formNewPrice(),
                SizedBox(
                  height: 25,
                ),
                Text(
                  "Old price",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 5,
                ),
                formOldPrice(),
                SizedBox(
                  height: 25,
                ),
                Text(
                  "Start date",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 5,
                ),
                formStartDate(),
                SizedBox(
                  height: 25,
                ),
                Text(
                  "Start time",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 5,
                ),
                formStartTime(),
                SizedBox(
                  height: 25,
                ),
                Text(
                  "Finish date",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 5,
                ),
                formFinishDate(),
                SizedBox(
                  height: 25,
                ),
                Text(
                  "Finish time",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 5,
                ),
                formFinishTime(),
                SizedBox(
                  height: 25,
                ),
                saveButton(),
              ]))),
        ));
  }

  Center showProgress() => Center(
        child: CircularProgressIndicator(),
      );

  Widget formOldPrice() {
    return TextFormField(
      controller: _oldPrice,
      readOnly: true,
      decoration: InputDecoration(
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.black12)),
          // focusedBorder กำหนดสีของกรอบเมื่อมีการกด
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black12),
          ),
          focusColor: Colors.black12,
          contentPadding: EdgeInsets.all(10),
          border: OutlineInputBorder()),
    );
  }

  Widget formNewPrice() {
    return TextFormField(
      controller: _newPrice,
      readOnly: true,
      decoration: InputDecoration(
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.black12)),
          // focusedBorder กำหนดสีของกรอบเมื่อมีการกด
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black12),
          ),
          focusColor: Colors.black12,
          contentPadding: EdgeInsets.all(10),
          border: OutlineInputBorder()),
    );
  }

  Future pickDateRange(BuildContext context) async {
    final initialDateRange = DateTimeRange(
        start:
            startDate!.isBefore(DateTime.now()) ? DateTime.now() : startDate!,
        end: endDate!);
    final newDateRange = await showDateRangePicker(
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            primarySwatch: Colors.grey,
            splashColor: Colors.black,
            textTheme: TextTheme(
              subtitle1: TextStyle(color: Colors.black),
              button: TextStyle(color: Colors.black),
              overline: TextStyle(fontSize: 16),
            ),
            accentColor: Colors.black,
            colorScheme: ColorScheme.light(
                primary: Color(0xffF1B739),
                primaryVariant: Colors.black,
                secondaryVariant: Colors.black,
                onSecondary: Colors.black,
                onPrimary: Colors.white,
                surface: Colors.black,
                onSurface: Colors.black,
                secondary: Colors.black),
            dialogBackgroundColor: Colors.white,
          ),
          child: child ?? Text(""),
        );
      },
      helpText: 'Select Date-Range',
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),

      //กำหนดวันเริ่มต้น : ถ้า dateRange == null ให้ใช้ initialDateRange
      initialDateRange: dateRange ?? initialDateRange,
    );
    if (newDateRange == null) return;
    setState(() {
      dateRange = newDateRange;
      dateCtl.text = DateFormat('dd/MM/yyyy').format(dateRange!.start);
      dateFinishCtl.text = DateFormat('dd/MM/yyyy').format(dateRange!.end);
      print('============new date==========');

      promotionStartDate = DateFormat('yyyy-MM-dd').format(dateRange!.start);
      print('promotionStartDate = $promotionStartDate');
      promotionFinishDate = DateFormat('yyyy-MM-dd').format(dateRange!.end);
      print('promotionFinishDate = $promotionFinishDate');
    });
  }

  Widget formStartDate() {
    return TextFormField(
      readOnly: true,
      controller: dateCtl,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueAccent, width: 2),
        ),
        contentPadding: EdgeInsets.all(10), border: OutlineInputBorder(),
        suffixIcon: Icon(
          Icons.date_range,
        ),

        // hintText: promotionStartDate,
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value!.isEmpty) {
          return 'cant be empty';
        }
        return null;
      },
      onTap: () => pickDateRange(context),
    );
  }

  Widget formFinishDate() {
    return TextFormField(
      readOnly: true,
      controller: dateFinishCtl,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueAccent, width: 2),
        ),
        contentPadding: EdgeInsets.all(10),
        border: OutlineInputBorder(),
        suffixIcon: Icon(
          Icons.date_range,
        ),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value!.isEmpty) {
          return 'cant be empty';
        }
        return null;
      },
      onTap: () => pickDateRange(context),
    );
  }

  Widget formStartTime() {
    return TextFormField(
        controller: timeCtl,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent, width: 2),
          ),
          contentPadding: EdgeInsets.all(10),
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.access_time_outlined),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value!.isEmpty) {
            return 'cant be empty';
          }
          return null;
        },
        onTap: () async {
          TimeOfDay time = TimeOfDay(
              hour: int.parse(promotionStartTime!.split(":")[0]),
              minute: int.parse(promotionStartTime!.split(":")[1]));
          FocusScope.of(context).requestFocus(new FocusNode());

          TimeOfDay? picked = await showTimePicker(
            context: context,
            initialTime: time,
            builder: (BuildContext context, Widget? child) {
              return Theme(
                data: ThemeData(
                  primarySwatch: Colors.grey,
                  splashColor: Colors.black,
                  textTheme: TextTheme(
                    subtitle1: TextStyle(color: Colors.black),
                    button: TextStyle(color: Colors.black),
                    overline: TextStyle(fontSize: 16),
                  ),
                  accentColor: Colors.red,
                  colorScheme: ColorScheme.light(
                      primary: Color(0xffF1B739),
                      primaryVariant: Colors.black,
                      secondaryVariant: Colors.black,
                      onSecondary: Colors.black,
                      onPrimary: Colors.white,
                      surface: Colors.white,
                      onSurface: Colors.black,
                      secondary: Colors.black),
                  dialogBackgroundColor: Colors.white,
                ),
                child: child ?? Text(""),
              );
            },
          );
          if (picked != null && picked != time) {
            timeCtl.text = picked.format(context);

            // print(object);
            setState(() {
              time = picked;
            });
          }
          setState(() {
            timeFormat = time.toString().substring(10, 15).trim();
            promotionStartTime = timeFormat;
          });
        });
  }

  Widget formFinishTime() {
    return TextFormField(
        controller: timeFinishCtl,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10),
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.access_time_outlined),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value!.isEmpty) {
            return 'cant be empty';
          }
          return null;
        },
        onTap: () async {
          TimeOfDay time = TimeOfDay(
              hour: int.parse(promotionStartTime!.split(":")[0]),
              minute: int.parse(promotionFinishTime!.split(":")[1]));
          FocusScope.of(context).requestFocus(new FocusNode());

          TimeOfDay? picked = await showTimePicker(
            context: context,
            initialTime: time,
            builder: (BuildContext context, Widget? child) {
              return Theme(
                data: ThemeData(
                  primarySwatch: Colors.grey,
                  splashColor: Colors.black,
                  textTheme: TextTheme(
                    subtitle1: TextStyle(color: Colors.black),
                    button: TextStyle(color: Colors.black),
                    overline: TextStyle(fontSize: 16),
                  ),
                  accentColor: Colors.red,
                  colorScheme: ColorScheme.light(
                      primary: Color(0xffF1B739),
                      primaryVariant: Colors.black,
                      secondaryVariant: Colors.black,
                      onSecondary: Colors.black,
                      onPrimary: Colors.white,
                      surface: Colors.white,
                      onSurface: Colors.black,
                      secondary: Colors.black),
                  dialogBackgroundColor: Colors.white,
                ),
                child: child ?? Text(""),
              );
            },
          );
          if (picked != null && picked != time) {
            timeFinishCtl.text = picked.format(context);

            // print(object);
            setState(() {
              time = picked;
            });
          }
          setState(() {
            timeFormat = time.toString().substring(10, 15).trim();
            promotionFinishTime = timeFormat;
          });
        });
  }

  Widget saveButton() => Container(
        width: MediaQuery.of(context).size.width,
        height: 40,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Color(0xffF1B739),
          ),
          child: Text(
            'Save',
            style: TextStyle(fontSize: 16),
          ),
          onPressed: () {
            print('========= Food Discount==========\n');
            print('Promotion id = $promotionId');
            print('Start date = $promotionStartDate');
            print('Start time = $promotionStartTime');
            print('Finish date = $promotionFinishDate');
            print('Finish time = $promotionFinishTime');
            editValueOnMySQL();
          },
        ),
      );

  Future<Null> editValueOnMySQL() async {
    String url =
        '${Myconstant().domain}/res_reserve/edit_pro_buy1_get1.php?isAdd=true&promotion_id=$promotionId&promotion_start_date=$promotionStartDate&promotion_start_time=$promotionStartTime&promotion_finish_date=$promotionFinishDate&promotion_finish_time=$promotionFinishTime';

    await Dio().get(url).then((value) {
      if (value.toString() == 'true') {
        fToast!.showToast(
          gravity: ToastGravity.BOTTOM,
          toastDuration: Duration(milliseconds: 2000),
          child: Container(
            height: 40,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
            child: Material(
              elevation: 10,
              borderRadius: BorderRadius.circular(50),
              color: Colors.green,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.done_all_rounded,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Sucessfully edited promotion',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
        Navigator.pop(context);
      } else {
        normalDialog(context, 'failed try again');
      }
    });
  }

  Widget dropdownSelectMenuBuyOne() {
    return Container(
        child: FormField<String>(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'cant be empty';
        }
      },
      // onSaved: (value) {
      //   _foodChoose1 = value as FoodMenuModel?;
      // },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: InputDecoration(
            enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.black12)),
          // focusedBorder กำหนดสีของกรอบเมื่อมีการกด
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black12),
          ),
          focusColor: Colors.black12,
              errorText: state.errorText,
              contentPadding: EdgeInsets.fromLTRB(12, 10, 20, 20),
              border: OutlineInputBorder()),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        '${Myconstant().domain}${foodDataSelectBuyOne[0]['foodMenuPicture']}'),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    '${foodDataSelectBuyOne[0]['foodMenuName']}',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ],
              ),

              SizedBox(
                width: 15,
              ),
              Text(
                '${foodDataSelectBuyOne[0]['foodMenuPrice']}',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              // SizedBox(width: 20,),
            ],
          ),
        );
      },
    ));
  }

  Widget dropdownSelectMenuGetOne() {
    return Container(
        child: FormField<String>(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'cant be empty';
        }
      },
      // onSaved: (value) {
      //   _foodChoose2 = value as FoodMenuModel?;
      // },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: InputDecoration(
            enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.black12)),
          // focusedBorder กำหนดสีของกรอบเมื่อมีการกด
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black12),
          ),
          focusColor: Colors.black12,
              errorText: state.errorText,
              contentPadding: EdgeInsets.fromLTRB(12, 10, 20, 20),
              border: OutlineInputBorder()),
          child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                                '${Myconstant().domain}${foodDataSelectgetOne[0]['foodMenuPicture']}'),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            '${foodDataSelectgetOne[0]['foodMenuName']}',
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ],
                      ),

                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        '${foodDataSelectgetOne[0]['foodMenuPrice']}',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      // SizedBox(width: 20,),
                    ],
                  ),
        );
      },
    ));
  }
}
