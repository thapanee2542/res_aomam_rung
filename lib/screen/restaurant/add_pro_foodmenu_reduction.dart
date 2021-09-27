import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/model/foodmenu_mode.dart';
import 'package:flutter_rrs_app/utility/my_constant.dart';
import 'package:flutter_rrs_app/utility/normal_dialog.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddProFoodMenuReduction extends StatefulWidget {
  AddProFoodMenuReduction({Key? key}) : super(key: key);

  @override
  _AddProFoodMenuReductionState createState() =>
      _AddProFoodMenuReductionState();
}

class _AddProFoodMenuReductionState extends State<AddProFoodMenuReduction> {
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
  TextEditingController dateCtl = TextEditingController();
  TextEditingController dateFinishCtl = TextEditingController();
  TextEditingController timeCtl = TextEditingController();
  TextEditingController timeFinishCtl = TextEditingController();
  String? timeFormat;
  String? dateFormat;

  String? promotion_start_date,
      promotion_start_time,
      promotion_finish_date,
      promotion_finish_time;

  var selectFood;

  List<FoodMenuModel> foodMenuModels = [];
  bool _statusFoodMenu = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readFoodMenu();
  }

  void _foodOldPrice(String _oldFoodPrice) {
    setState(() {
      promotion_old_price = _oldFoodPrice;
      print('setstate old price = $promotion_old_price');
    });
  }

  void _onDropDownItemSelected(FoodMenuModel newSelectedFood) {
    setState(() {
      _foodChoose = newSelectedFood;
      print('foodchoose ==== $_foodChoose');
      String foodchoose = jsonEncode(_foodChoose);
      print('foodchoose Sring == $foodchoose');
      var foodChoose2 = jsonDecode(foodchoose);
      print('food choose json decode = $foodChoose2');
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xffF1B739),
          title: Text('Add promotion food price reduction'),
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
                      "Select food menu",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    dropdownSelectMenu(),
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
        contentPadding: EdgeInsets.all(10), border: OutlineInputBorder(),
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
      onTap: () => pickDateRange(context)
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

          TimeOfDay? picked =
              await showTimePicker(context: context, initialTime: time,builder: (BuildContext context, Widget ?child) {
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
      
        child: child ??Text(""),
      );
    },);
              
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
        contentPadding: EdgeInsets.all(10), border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.date_range),
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
      onTap: () => pickDateRange(context)
    );
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

          TimeOfDay? picked =
              await showTimePicker(context: context, initialTime: time,builder: (BuildContext context, Widget ?child) {
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
      
        child: child ??Text(""),
      );
    },);
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
    return TextFormField(
      textAlignVertical: TextAlignVertical.center,
      validator: (value) {
        if (value == null || value.isEmpty) return 'cant be empty';
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onSaved: (value) => promotion_new_price = value,
      onChanged: (value) {
        setState(() {
          promotion_new_price = value;
        });
      },
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10), border: OutlineInputBorder()),
    );
  }

  Widget formOldPrice() {
    print('fc = $promotion_old_price'.toString());
    return TextFormField(
      controller: _oldPrice,
      textAlignVertical: TextAlignVertical.center,
      validator: (value) {
        if (value == null || value.isEmpty) {return 'cant be empty';}
        else{return null;   }
        
      },
    
      readOnly: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onSaved: (value) => promotion_old_price = value,
    
      

      decoration: InputDecoration(
         enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black12)),
      
          contentPadding: EdgeInsets.all(10),
          border: OutlineInputBorder()),
    );
  }

  Future pickDateRange(BuildContext context) async {
    final initialDateRange = DateTimeRange(
      start: DateTime.now(),
      end: DateTime.now().add(Duration(hours: 24 * 3)),
    );
    final newDateRange = await showDateRangePicker(
       builder: (BuildContext context, Widget ?child) {
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
      
        child: child ??Text(""),
      );
    },
       helpText: 'Select Date-Range',
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime(DateTime.now().year + 5),

        //กำหนดวันเริ่มต้น : ถ้า dateRange == null ให้ใช้ initialDateRange
        initialDateRange: dateRange ?? initialDateRange,
        
     
        
        );
    if(newDateRange == null) return;
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

  Widget dropdownSelectMenu() {
    return Container(child: FormField<String>(
 validator: (value) {
        if (value == null || value.isEmpty) {
          return 'cant be empty';
        }
      },
      onSaved: (value){
        _foodChoose = value as FoodMenuModel?;
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
              menuMaxHeight: 300,
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                                '${Myconstant().domain}${valueItem.foodMenuPicture}'),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            '${valueItem.foodMenuName.toString()}',
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ],
                      ),

                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        '${valueItem.foodMenuPrice.toString()}',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      // SizedBox(width: 20,),
                    ],
                  ),
                );
              }).toList(),
              value: _foodChoose,
              isExpanded: true,
              isDense: true,
              onChanged: (newSelectedFood) {
                state.didChange(newSelectedFood.toString());
                _onDropDownItemSelected(newSelectedFood!);
                foodMenuId_discount = _foodChoose!.foodMenuId;
                promotion_old_price = _foodChoose!.foodMenuPrice;
                _oldPrice.text = _foodChoose!.foodMenuPrice.toString();
                _foodOldPrice(promotion_old_price!);

                print(foodMenuId_discount.toString());
                print(
                    promotion_old_price.toString()); // print(foodMenuModels.);
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
    String food_discount_old_price = promotion_old_price!;
    String food_discount_new_price = promotion_new_price!;
    String promotion_type = 'Food discount';
    String promotion_status = 'true';


    print('========= Food Discount==========\n');
    print('ResId = $restaurantId');
    print('foodMenuId_discount = $foodMenuId_discount');
    print('Old price = $food_discount_old_price');
    print('New price = $food_discount_new_price');
    print('Start date = $promotion_start_date');
    print('Start time = $promotion_start_time');
    print('Finish date = $promotion_finish_date');
    print('Finish time = $promotion_finish_time');

    String url =
        '${Myconstant().domain}/res_reserve/add_pro_discount_for_food.php?isAdd=true&restaurantId=$restaurantId&promotion_type=$promotion_type&promotion_start_date=$promotion_start_date&promotion_start_time=$promotion_start_time&promotion_finish_date=$promotion_finish_date&promotion_finish_time=$promotion_finish_time&foodMenuId_discount=$foodMenuId_discount&promotion_old_price=$promotion_old_price&promotion_new_price=$promotion_new_price&promotion_status=$promotion_status';
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
