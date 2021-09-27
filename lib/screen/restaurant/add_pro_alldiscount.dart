import 'dart:io';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rrs_app/screen/restaurant/show_promotion.dart';
import 'package:flutter_rrs_app/utility/my_constant.dart';
import 'package:flutter_rrs_app/utility/my_font.dart';
import 'package:flutter_rrs_app/utility/normal_dialog.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:math' as math;
import 'package:fluttertoast/fluttertoast.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AddProAllDiscount extends StatefulWidget {
  AddProAllDiscount({Key? key}) : super(key: key);

  @override
  _AddMenuState createState() => _AddMenuState();
}

class _AddMenuState extends State<AddProAllDiscount> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController dateCtl = TextEditingController();
  TextEditingController dateFinishCtl = TextEditingController();
  TextEditingController timeCtl = TextEditingController();
  TextEditingController timeFinishCtl = TextEditingController();
  String? timeFormat;
  String? dateFormat;
  DateTime date1 = DateTime(1900);
  DateTime date2 = DateTime(1900);
  DateTimeRange? dateRange;

  TextEditingController _controller = TextEditingController();
  String? _selectedTime;

  String? promotion_type,
      promotion_start_date,
      promotion_start_time,
      promotion_finish_date,
      promotion_finish_time;
  var promotion_discount;

  FToast? fToast;

  var currentSelectedValue;
  @override
  void initState() {
    super.initState();
    _controller.text = "0"; // Setting the initial value for the field.

    fToast = FToast();
    fToast!.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xffF1B739),
          title: Text('Add promotion all discount'),
        ),
        body: Container(
          padding: EdgeInsets.all(30),
          child: Form(
              key: _formkey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyFont().textBeforeTextfield('Promotion type'),
                    SizedBox(
                      height: 5,
                    ),
                    typeFieldWidget(),
                    SizedBox(
                      height: 25,
                    ),
                    MyFont().textBeforeTextfield('Discount (%)'),
                    SizedBox(
                      height: 5,
                    ),
                    formDiscount(),
                    SizedBox(
                      height: 25,
                    ),
                    MyFont().textBeforeTextfield('Start date'),
                    SizedBox(
                      height: 5,
                    ),
                    formStartDate(),
                    SizedBox(
                      height: 25,
                    ),
                    MyFont().textBeforeTextfield('Start time'),
                    SizedBox(
                      height: 5,
                    ),
                    formStartTime(),
                    SizedBox(
                      height: 25,
                    ),
                    MyFont().textBeforeTextfield('Finish date'),
                    SizedBox(
                      height: 5,
                    ),
                    formFinishDate(),
                    SizedBox(
                      height: 25,
                    ),
                    MyFont().textBeforeTextfield('Finish time'),
                    SizedBox(
                      height: 5,
                    ),
                    formFinishTime(),
                    SizedBox(
                      height: 25,
                    ),
                    saveButton(),
                  ],
                ),
              )),
        ));
  }

  Widget typeFieldWidget() {
    const orderTypes = ["Reserve a table", "Order food"];
    return FormField<String>(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'cant be empty';
        }
      },
      onSaved: (value) {
        promotion_type = value;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: InputDecoration(
              errorText: state.errorText,
              contentPadding: EdgeInsets.all(10),
              border: OutlineInputBorder()),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              //   validator: (value) => promotion_type == null ? 'Please select promotion type' : null,
              hint: Text("Select promotion type"),
              value: promotion_type,
              isDense: true,
              onChanged: (newValue) {
                state.didChange(newValue);
                setState(() {
                  promotion_type = newValue;
                });
                print('type = $promotion_type');
              },
              items: orderTypes.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget formDiscount() {
    return TextFormField(
      readOnly: true,
      // initialValue: _controller.text,
      controller: _controller,
      validator: (value) {
        if (value == '0') {
          return 'cant be zero number';
        }
        return null;
      },
      inputFormatters: [
        FilteringTextInputFormatter.deny(
          (RegExp(r'[/\\]')),
        )
      ],
      textAlign: TextAlign.center,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      // onSaved: (value) => promotion_discount = value,
      // onChanged: (value) {
      //   setState(() {
      //     promotion_discount = value;
      //   });
      // },
      keyboardType:
          TextInputType.numberWithOptions(decimal: false, signed: false),
      decoration: InputDecoration(
          suffixText: '%',
          contentPadding: EdgeInsets.all(10),
          border: OutlineInputBorder(),
          prefixIcon: IconButton(
            icon: Icon(
              Icons.arrow_drop_down_circle_rounded,
              size: 30,
            ),
            onPressed: () {
              int currentValue = int.parse(_controller.text);
              setState(() {
                currentValue--;
                _controller.text =
                    (currentValue > 0 ? currentValue : 0).toString();
                promotion_discount = int.parse(_controller.text);
                print('discount value = $promotion_discount');
              });
            },
          ),
          suffixIcon: Transform.rotate(
            angle: 180 * math.pi / 180,
            child: IconButton(
              icon: Icon(
                Icons.arrow_drop_down_circle_rounded,
                size: 30,
              ),
              onPressed: () {
                int currentValue = int.parse(_controller.text);
                setState(() {
                  currentValue++;
                  _controller.text = (currentValue).toString();
                  promotion_discount = int.parse(_controller.text);
                  print('discount value = $promotion_discount');
                });
              },
            ),
          )),
    );
  }

  Future pickDateRange(BuildContext context) async {
    final initialDateRange = DateTimeRange(
      start: DateTime.now(),
      end: DateTime.now().add(Duration(hours: 24 * 3)),
    );
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
      print('date rang = $dateRange');
      dateCtl.text = DateFormat('dd/MM/yyyy').format(dateRange!.start);
      dateFinishCtl.text = DateFormat('dd/MM/yyyy').format(dateRange!.end);
      promotion_start_date = DateFormat('yyyy-MM-dd').format(dateRange!.start);
      print('promotion_start_date = $promotion_start_date');
      promotion_finish_date = DateFormat('yyyy-MM-dd').format(dateRange!.end);
      print('promotion_finish_date = $promotion_finish_date');
    });
  }

  Widget formStartDate() {
    return TextFormField(
      readOnly: true,
      controller: dateCtl,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(10), border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.date_range),
        //labelText: "Date of birth",
        // hintStyle:  promotion_start_date==null?null: TextStyle(color: Colors.black),
        hintText: 'Select start date',
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
        contentPadding: EdgeInsets.all(10),
        border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.date_range),
        hintText: 'Select finish date',
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
          TimeOfDay time = TimeOfDay.now();
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
            promotion_start_time = timeFormat;
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
          TimeOfDay time = TimeOfDay.now();
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
            promotion_finish_time = timeFormat;
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
            if (_formkey.currentState!.validate()) {
              print('============== SAVE All Discount ================\n');
              //   print('RestaurantId ==> $restaurantId');
              print('Promotion type ==> $promotion_type');
              print('discount ==> $promotion_discount');
              print('Start date ==> $promotion_start_date');
              print('Start time ==> $promotion_start_time');
              print('Finish Date ==> $promotion_finish_date');
              print('Finish time ==>  $promotion_finish_time');

              addProAllDiscount();

              // if (file == null) {
              //   normalDialog(context, 'please insert a picture');
              // } else {
              //   checkTableNumber();
              // }
              // print(
              //     'tableId =$tableResId,tableName =$tableName,tableNumseat=$tableNumseat,tabledes=$tableDescrip,tablePicOne=$tablePicOne');
            }
          },
        ),
      );

  Future<Null> addProAllDiscount() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? restaurantId = preferences.getString('restaurantId');
    String promotion_status = 'true';

    String url =
        '${Myconstant().domain}/res_reserve/add_pro_discount_for_all.php?isAdd=true&restaurantId=$restaurantId&promotion_type=$promotion_type&promotion_start_date=$promotion_start_date&promotion_start_time=$promotion_start_time&promotion_finish_date=$promotion_finish_date&promotion_finish_time=$promotion_finish_time&promotion_discount=$promotion_discount&promotion_status=$promotion_status';
    try {
      await Dio().get(url).then((value) {
        if (value.toString() == 'true') {
          fToast!.showToast(
            gravity: ToastGravity.BOTTOM,
            toastDuration: Duration(milliseconds: 2000),
            child: Container(
              height: 40,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(50)),
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
                        'Sucessfully added promotion',
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
          normalDialog(context, 'try again');
        }
      });
    } catch (e) {}
  }
}
