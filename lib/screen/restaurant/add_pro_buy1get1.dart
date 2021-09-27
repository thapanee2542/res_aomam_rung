import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/model/foodmenu_mode.dart';
import 'package:flutter_rrs_app/screen/promotion.dart';
import 'package:flutter_rrs_app/utility/my_constant.dart';
import 'package:flutter_rrs_app/utility/normal_dialog.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddProBuyOneGetOne extends StatefulWidget {
  AddProBuyOneGetOne({Key? key}) : super(key: key);

  @override
  _AddProBuyOneGetOneState createState() => _AddProBuyOneGetOneState();
}

class _AddProBuyOneGetOneState extends State<AddProBuyOneGetOne> {
  bool status = false; //มีข้อมูลอาหาร
  bool nextState = false;
  bool loadStatus = true;
  bool? statusFood;
  DateTimeRange? dateRange;
  String? foodMenuStatus;
  final _formkey = GlobalKey<FormState>();
  FoodMenuModel? _foodChoose1;
  FoodMenuModel? _foodChoose2;

  String? foodMenuId_discount, promotion_new_price;
  var promotionOldPrice, old_price2;
  var old_price1;

  var txt_oldprice = TextEditingController();

  TextEditingController _oldPrice = TextEditingController();
  TextEditingController _newPrice = TextEditingController();

  TextEditingController dateCtl = TextEditingController();
  TextEditingController dateFinishCtl = TextEditingController();
  TextEditingController timeCtl = TextEditingController();
  TextEditingController timeFinishCtl = TextEditingController();
  String? timeFormat;
  String? dateFormat;

  String? promotion_start_date,
      promotion_start_time,
      promotion_finish_date,
      promotion_finish_time,
      foodMenuId_buy_one,
      foodMenuId_get_one;

  var selectFood;

  List<FoodMenuModel> foodMenuModels = [];
  bool _statusFoodMenu = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readFoodMenu();
  }

  void _foodOldPrice(var _oldFoodPrice) {
    setState(() {
      old_price1 = int.parse(_oldFoodPrice);
      print('setstate old price1 = $old_price1');
    });
  }

  void _foodOldPrice2(var _oldFoodPrice) {
    setState(() {
      old_price2 = int.parse(_oldFoodPrice);
      print('setstate old price2 = $old_price2');
    });
  }

  void _onDropDownItemSelected1(FoodMenuModel newSelectedFood) {
    setState(() {
      _foodChoose1 = newSelectedFood;
    });
  }

  void _onDropDownItemSelected2(FoodMenuModel newSelectedFood) {
    setState(() {
      _foodChoose2 = newSelectedFood;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xffF1B739),
          title: Text('Buy 1 get 1 free'),
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
                      "Select food menu buy 1",
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
                      "Select food menu get 1 free",
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

  Widget formStartDate() {
    return TextFormField(
        readOnly: true,
        controller: dateCtl,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10),
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.date_range),
          hintText: 'Select start date',
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value!.isEmpty) {
            return 'cant be empty';
          }
          return null;
        },
        onTap: () => pickDateRange(context));
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
      dateCtl.text = DateFormat('dd/MM/yyyy').format(dateRange!.start);
      dateFinishCtl.text = DateFormat('dd/MM/yyyy').format(dateRange!.end);
      promotion_start_date = DateFormat('yyyy-MM-dd').format(dateRange!.start);
      print('promotion_start_date = $promotion_start_date');
      promotion_finish_date = DateFormat('yyyy-MM-dd').format(dateRange!.end);
      print('promotion_start_date = $promotion_finish_date');
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
        onTap: () => pickDateRange(context));
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

  Widget formNewPrice() {
    if (old_price1 != null) {
      promotion_new_price = old_price1.toString();
      setState(() {
        _newPrice.text = promotion_new_price.toString();
      });
    } else {
      promotion_new_price == null;
    }

    return TextFormField(
      controller: _newPrice,
      readOnly: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'cant be empty';
        } else {
          return null;
        }
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onSaved: (value) => promotion_new_price = value,
      onChanged: (value) {
        setState(() {
          promotion_new_price = value;
        });
      },
      decoration: InputDecoration(
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.black12)),
          contentPadding: EdgeInsets.all(10),
          border: OutlineInputBorder()),
    );
  }

  Widget formOldPrice() {
    print('old_price1 == $old_price1');
    print('old_price2 == $old_price2');

    if (old_price1 != null && old_price2 != null) {
      promotionOldPrice = old_price1 + old_price2;
      setState(() {
        _oldPrice.text = promotionOldPrice.toString();
      });
    } else {
      promotionOldPrice == null;
    }

    print('promotionOldPrice = $promotionOldPrice');
    return TextFormField(
      controller: _oldPrice,
      textAlignVertical: TextAlignVertical.center,
      validator: (value) {
        if (value == null || value.isEmpty) return 'cant br empty';
        return null;
      },

      readOnly: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      // onSaved: (value) => tableResId = value,
      // onChanged: (value) {
      //   txt_oldprice.value = TextEditingValue(
      //       text: promotionOldPrice.toString(),
      //       selection: TextSelection.fromPosition(
      //           TextPosition(offset: promotionOldPrice!.length)));
      // },
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.black12)),
          contentPadding: EdgeInsets.all(10),
          border: OutlineInputBorder()),
    );
  }

  Widget dropdownSelectMenuBuyOne() {
    return Container(
        child: FormField<String>(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'cant be empty';
        }
      },
      onSaved: (value) {
        _foodChoose1 = value as FoodMenuModel?;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: InputDecoration(
              errorText: state.errorText,
              contentPadding: EdgeInsets.fromLTRB(12, 10, 20, 20),
              border: OutlineInputBorder()),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<FoodMenuModel>(
              style: TextStyle(
                fontSize: 16,
              ),
              hint: Text(
                'Select food menu',
                style: TextStyle(fontSize: 16),
              ),
              items: foodMenuModels.map<DropdownMenuItem<FoodMenuModel>>(
                  (FoodMenuModel valueItem) {
                return DropdownMenuItem(
                  value: valueItem,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                            '${Myconstant().domain}${valueItem.foodMenuPicture}'),
                      ),
                      //  SizedBox(width: 15,),
                      Text(
                        '${valueItem.foodMenuName.toString()}',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      // SizedBox(width: 20,),
                      Text(
                        '${valueItem.foodMenuPrice.toString()}',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ],
                  ),
                );
              }).toList(),
              value: _foodChoose1,
              isExpanded: true,
              isDense: true,
              onChanged: (newSelectedFood) {
                state.didChange(newSelectedFood.toString());
                _onDropDownItemSelected1(newSelectedFood!);
                foodMenuId_discount = _foodChoose1!.foodMenuId;
                old_price1 = _foodChoose1!.foodMenuPrice;
                foodMenuId_buy_one = _foodChoose1!.foodMenuId;
                _foodOldPrice(old_price1!);

                print(foodMenuId_discount.toString());
                print(promotionOldPrice.toString()); // print(foodMenuModels.);
              },
            ),
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
      onSaved: (value) {
        _foodChoose2 = value as FoodMenuModel?;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: InputDecoration(
              errorText: state.errorText,
              contentPadding: EdgeInsets.fromLTRB(12, 10, 20, 20),
              border: OutlineInputBorder()),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<FoodMenuModel>(
              style: TextStyle(
                fontSize: 16,
              ),
              hint: Text(
                'Select food menu',
                style: TextStyle(fontSize: 16),
              ),
              items: foodMenuModels.map<DropdownMenuItem<FoodMenuModel>>(
                  (FoodMenuModel valueItem) {
                return DropdownMenuItem(
                  value: valueItem,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                            '${Myconstant().domain}${valueItem.foodMenuPicture}'),
                      ),
                      //  SizedBox(width: 15,),
                      Text(
                        '${valueItem.foodMenuName.toString()}',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      // SizedBox(width: 20,),
                      Text(
                        '${valueItem.foodMenuPrice.toString()}',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ],
                  ),
                );
              }).toList(),
              value: _foodChoose2,
              isExpanded: true,
              isDense: true,
              onChanged: (newSelectedFood) {
                state.didChange(newSelectedFood.toString());
                _onDropDownItemSelected2(newSelectedFood!);
                foodMenuId_discount = _foodChoose2!.foodMenuId;
                old_price2 = _foodChoose2!.foodMenuPrice;
                foodMenuId_get_one = _foodChoose2!.foodMenuId;
                _foodOldPrice2(old_price2!);

                print(foodMenuId_discount.toString());
                print(promotionOldPrice.toString()); // print(foodMenuModels.);
              },
            ),
          ),
        );
      },
    ));
  }

  Future<Null> addProFoodDiscount() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? restaurantId = preferences.getString('restaurantId');
    // String foodDiscountOldPrice = promotionOldPrice!;
    String promotion_old_price = promotionOldPrice.toString();
    // String foodDiscountNewPrice = promotion_new_price!;
    String promotionType = 'Buy 1 get 1 free';
    promotion_new_price = old_price1.toString();
    String promotion_status ='true';

    print('========= Food Discount==========\n');
    print('ResId = $restaurantId');
    print('Old price = $promotion_old_price');
    print('New price = $promotion_new_price');
    print('Start date = $promotion_start_date');
    print('Start time = $promotion_start_time');
    print('Finish date = $promotion_finish_date');
    print('Finish time = $promotion_finish_time');
    print('Food menu Id buy 1 = $foodMenuId_buy_one');
    print('Food menu Id get 1 = $foodMenuId_get_one');

    String url =
        '${Myconstant().domain}/res_reserve/add_pro_discount_for_buy1get1.php?isAdd=true&restaurantId=$restaurantId&promotion_type=$promotionType&promotion_start_date=$promotion_start_date&promotion_start_time=$promotion_start_time&promotion_finish_date=$promotion_finish_date&promotion_finish_time=$promotion_finish_time&promotion_old_price=$promotion_old_price&promotion_new_price=$promotion_new_price&foodMenuId_buy_one=$foodMenuId_buy_one&foodMenuId_get_one=$foodMenuId_get_one&promotion_status=$promotion_status';
    try {
      await Dio().get(url).then((value) {
        if (value.toString() == 'true') {
          Navigator.pop(context);
        } else {
          normalDialog(context, 'try again');
        }
      });
    } catch (e) {}
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
              addProFoodDiscount();
            }
          },
        ),
      );

  Widget formFoodMenu() {
    return TextFormField(
      readOnly: true,
      //  controller: dateCtl,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(10), border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.arrow_drop_down_outlined),
        //labelText: "Date of birth",
        // hintText: "Ex. Insert your dob",
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value!.isEmpty) {
          return 'cant be empty';
        }
        return null;
      },
      onTap: () {
        AlertDialog(
          title: Text('Select food menu'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              // textColor: Theme.of(context).accentColor,
              onPressed: () {
                // widget.onCancel();
              },
            ),
            TextButton(
              child: const Text('OK'),
              //  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              //  textColor: Theme.of(context).accentColor,
              onPressed: () {
                //  widget.onOk();
              },
            ),
          ],
        );
      },
    );
  }

  Future<Null> readFoodMenu() async {
    if (foodMenuModels.length != 0) {
      foodMenuModels.clear();
    }

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? restaurantId = preferences.getString('restaurantId');

    String url =
        '${Myconstant().domain}/res_reserve/getFoodmenuWhereRestaurantId.php?isAdd=true&restaurantId=$restaurantId';
    await Dio().get(url).then((value) {
      setState(() {
        loadStatus = false;
      });
      if (value.toString() != 'null') {
        var result = json.decode(value.data);
        print('result all discount promotion ==> $result');
        for (var map in result) {
          FoodMenuModel foodMenuModel = FoodMenuModel.fromJson(map);
          setState(() {
            foodMenuModels.add(foodMenuModel);
          });
        }
      } else {
        setState(() {
          status = false;
        });
      }
    });
  }

  Center showProgress() => Center(
        child: CircularProgressIndicator(),
      );

  Widget showListFoodMenu() => ListView.separated(
        separatorBuilder: (context, index) {
          return Divider(
            height: 0.1,
            thickness: 5,
          );
        },
        itemCount: foodMenuModels.length,
        itemBuilder: (context, index) {
          return Padding(
            // padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
            padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.15,
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: Image.network(
                      '${Myconstant().domain}${foodMenuModels[index].foodMenuPicture}',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${foodMenuModels[index].foodMenuName}',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            '${foodMenuModels[index].foodMenuPrice}',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
}
