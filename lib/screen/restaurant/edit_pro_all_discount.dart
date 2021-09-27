import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rrs_app/model/promotion_model.dart';
import 'package:flutter_rrs_app/utility/my_constant.dart';
import 'package:flutter_rrs_app/utility/my_font.dart';
import 'package:flutter_rrs_app/utility/normal_dialog.dart';
import 'dart:math' as math;

import 'package:intl/intl.dart';

class EditProAllDiscount extends StatefulWidget {
  final PromotionModel? promotionModel;
  EditProAllDiscount({Key? key, this.promotionModel}) : super(key: key);

  @override
  _EditProAllDiscountState createState() => _EditProAllDiscountState();
}

class _EditProAllDiscountState extends State<EditProAllDiscount> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController _controller = TextEditingController();
  PromotionModel? promotionModel;
  DateTimeRange? dateRange;
  String? timeFormat;
  TextEditingController dateCtl = TextEditingController();
  TextEditingController dateFinishCtl = TextEditingController();
  TextEditingController timeCtl = TextEditingController();
  TextEditingController timeFinishCtl = TextEditingController();
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

  @override
  void initState() {
    super.initState();
    promotionModel = widget.promotionModel;
    promotionId = promotionModel!.promotionId;
    promotionType = promotionModel!.promotionType;
    promotionStartDate = promotionModel!.promotionStartDate.toString();
    promotionStartTime = promotionModel!.promotionStartTime;
    promotionFinishDate = promotionModel!.promotionFinishDate.toString();
    promotionFinishTime = promotionModel!.promotionFinishTime;
    foodMenuIdDiscount = promotionModel!.foodMenuIdDiscount;
    promotionDiscount = int.parse(promotionModel!.promotionDiscount.toString());
    promotionOldPrice = promotionModel!.promotionOldPrice;
    promotionNewPrice = promotionModel!.promotionNewPrice;
    promotionBuyOne = promotionModel!.promotionBuyOne;
    foodMenuIdBuyOne = promotionModel!.foodMenuIdBuyOne;
    promotionGetOne = promotionModel!.promotionGetOne;
    foodMenuIdGetOne = promotionModel!.foodMenuIdGetOne;
    _controller.text = promotionDiscount.toString();
    // dateRange = DateTimeRange(
    //   start:  promotionStartDate!,
    //   end: promotionFinishDate!
    // );
    startDate = DateTime.parse(promotionStartDate.toString());
    endDate = DateTime.parse(promotionFinishDate.toString());
    dateCtl.text = DateFormat('dd/MM/yyyy').format(startDate!);
    dateFinishCtl.text = DateFormat('dd/MM/yyyy').format(endDate!);
    timeCtl.text = promotionStartTime.toString();
    timeFinishCtl.text = promotionFinishTime.toString();

    // dateCtl.text = DateFormat('dd/MM/yyyy').format(promotionStartDate);
  }

  // DateTime checkStartDate(DateTime sDate){

  //   if () {

  //   }

  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffF1B739),
        title: Text('Edit promotion ${promotionModel!.promotionType}'),
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
      ),
    );
  }

  Widget typeFieldWidget() {
    const orderTypes = ["Reserve a table", "Order food"];
    return FormField<String>(
      initialValue: promotionType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'cant be empty';
        }
      },
      onSaved: (value) {
        promotionType = value;
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
              //   validator: (value) => promotionType == null ? 'Please select promotion type' : null,
              hint: Text("Select promotion type"),
              value: promotionType,
              isDense: true,
              onChanged: (newValue) {
                state.didChange(newValue);
                setState(() {
                  promotionType = newValue;
                });
                print('type = $promotionType');
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
      // initialValue: promotionDiscount.toString(),
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
      // onSaved: (value) => promotionDiscount = value,
      // onChanged: (value) {
      //   setState(() {
      //     promotionDiscount = value;
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
                promotionDiscount = int.parse(_controller.text);
                print('discount value = $promotionDiscount');
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
                  promotionDiscount = int.parse(_controller.text);
                  print('discount value = $promotionDiscount');
                });
              },
            ),
          )),
    );
  }

  Widget formStartDate() {
    return TextFormField(
      // initialValue: 'HI',
      readOnly: true,
      controller: dateCtl,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(10), border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.date_range),

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
        contentPadding: EdgeInsets.all(10),
        border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.date_range),
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
            if (_formkey.currentState!.validate()) {
              editValueOnMySQL();
            }
          },
        ),
      );

  Future<Null> editValueOnMySQL() async {
    String url =
        '${Myconstant().domain}/res_reserve/edit_pro_all_discount.php?isAdd=true&promotion_id=$promotionId&promotion_start_date=$promotionStartDate&promotion_start_time=$promotionStartTime&promotion_finish_date=$promotionFinishDate&promotion_finish_time=$promotionFinishTime&promotion_discount=$promotionDiscount&promotion_type=$promotionType';

    await Dio().get(url).then((value) {
      if (value.toString() == 'true') {
        Navigator.pop(context);
        normalDialog(context, 'Edit complete');
      } else {
        normalDialog(context, 'failed try again');
      }
    });
  }
}
