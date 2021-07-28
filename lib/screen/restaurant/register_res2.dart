import 'package:flutter/material.dart';
import 'package:card_settings/card_settings.dart';
import 'package:flutter/services.dart';

import 'package:dio/dio.dart';
import 'package:flutter_rrs_app/screen/restaurant/home_page.dart';
import 'package:flutter_rrs_app/utility/my_constant.dart';
import 'package:flutter_rrs_app/utility/normal_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'menu_bottom.dart';


class RegisterRes2 extends StatefulWidget {
  RegisterRes2({Key? key}) : super(key: key);

  @override
  _SignupRes2State createState() => _SignupRes2State();
}

class _SignupRes2State extends State<RegisterRes2> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _typeFoodKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _nameKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _idKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _restaurantBranchKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _phoneNumKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _restaurantAddressKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _dayKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _openKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _closeKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _nameResKey = GlobalKey<FormState>();

  String? name, restaurantIdNumber, restaurantNameshop, restaurantBranch, phoneNumber, restaurantAddress;
  String? restaurantPicture = null;
  DateTime showDateTimeOpen = DateTime(2010, 10, 10, 20, 30);
  DateTime showDateTimeClose = DateTime(2010, 10, 10, 20, 30);
  DateTime updateJustTime(TimeOfDay? newTime, DateTime originalDateTime) {
    return DateTime(
      originalDateTime.year, // year
      originalDateTime.month, // month
      originalDateTime.day, // day
      newTime!.hour, // hour
      newTime.minute, // minute
      0, // second
      0, // millisecond
      0, // microsecond
    );
  }

  List<String> alltypeDay = <String>[
    'all day',
    'Monday - Friday',
    'Saturday - Sunday',
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];
  String? typeDay,typeOfFood;
  List<String>? litemsDay = [];
  List<DateTime>? litemsTimeOpen = [];
  List<DateTime>? litemsTimeClose = [];

  //List<String>? typeOfFood = <String>[];

  List<String> allTypeOfFood = <String>[
    'Asian Fusin',
    'Bagels',
    'Bakery',
    'Breakfast',
    'British',
    'Brunch',
    'Buffets',
    'Burgers',
    'Cajun/Creole',
    'Chinese',
    'Coffee/Espresso',
    'Ice Cream',
    'Indian',
    'Iris',
    'Italian',
    'Japanese',
    'Latin American',
    'Mediterranean',
    'Pizza',
    'Fast Food',
    'Fine Dining',
    'French',
    'German',
    'Lao',
    'Seafood',
    'Spanish',
    'Steaks',
    'Thai',  
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register your restaurant'),
        centerTitle: true,
        backgroundColor: Color(0xffF1B739),
      ),
      body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                CardSettings(children: <CardSettingsSection>[
                  CardSettingsSection(
                      header: CardSettingsHeader(
                        color: Color(0xffFFF5DD),
                        label: 'Information shop owner',
                      ),
                      children: <CardSettingsWidget>[
                        nameField(),
                        idField(),
                      ]),
                  CardSettingsSection(
                      header: CardSettingsHeader(
                        color: Color(0xffFFF5DD),
                        label: 'Information restaurant',
                      ),
                      children: <CardSettingsWidget>[
                        nameResField(),
                        nameBranchField(),
                        typeFood(),
                        phoneField(),
                        restaurantAddressField()
                      ]),
                  CardSettingsSection(
                    header: CardSettingsHeader(
                      color: Color(0xffFFF5DD),
                      label: 'Opening-closing time',
                    ),
                    children: [],
                  ),
                  CardSettingsSection(
                    header: CardSettingsHeader(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.width * 0.95,
                              height: 100,
                              // color: Colors.red,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                                  child: ListView.builder(
                                      itemCount: litemsDay!.length,
                                      itemBuilder: (context, index) {
                                        return Row(
                                          children: [
                                            Text(
                                              litemsDay![index],
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              litemsTimeOpen![index]
                                                      .toString()
                                                      .substring(11, 16) +
                                                  " - " +
                                                  litemsTimeClose![index]
                                                      .toString()
                                                      .substring(11, 16),
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            IconButton(onPressed: (){
                                              litemsDay!.removeAt(index);
                                              setState(() {
                                              }); 
                                              
                                            }, icon: Icon(Icons.remove_circle_outlined,color: Colors.red,))
                                          ],
                                        );
                                      }),
                                
                              )),
                        ],
                      ),
                    ),
                  ),
                  CardSettingsSection(
                    header: CardSettingsHeader(
                      child: TextButton(
                        child: Text('add',style: TextStyle(fontSize: 18),),
                        onPressed: () {
                          showModalBottomSheet(
                            isScrollControlled: true,
                              context: context,
                              builder: (BuildContext bc) {
                                return FractionallySizedBox(
                                  heightFactor: 0.4,
                                  child: SingleChildScrollView(
                                    child: Container(
                                      height: MediaQuery.of(context).size.height
                                ,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    primary: Color(0xffF1B739),
                                                  ),
                                                  child: Text("add"),
                                                  onPressed: () {
                                                            
                                                    litemsDay!.add(typeDay!);
                                                    litemsTimeOpen!
                                                        .add(showDateTimeOpen);
                                                    litemsTimeClose!
                                                        .add(showDateTimeClose);
                                                    Navigator.pop(context);
                                                    setState(() {});
                                                  },
                                                ),
                                              ],
                                            ),
                                            CardSettingsSection(
                                              header: CardSettingsHeader(
                                                color: Color(0xffFFF5DD),
                                                label:
                                                    'Select opening-closing time',
                                              ),
                                              children: [
                                                day(),
                                                timeOpen(),
                                                timeClose(),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              });
                        },
                      ),
                    ),
                  ),
                ]),
                Container(
                  width: MediaQuery.of(context).size.width*0.95,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xffF1B739),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate())  {
                      //  _formKey.currentState!.save();
                        print('name = $name,id = $restaurantIdNumber,name res = $restaurantNameshop,branch = $restaurantBranch,phone = $phoneNumber,restaurantAddress=$restaurantAddress');
                        UpdateRegisterThread();
                        }
                        else{Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeRes2()));
                        }
                      
                    },
                    child: Text('Save'),
                  ),
                )
              ],
            ),
          )),
    );
  }

  CardSettingsListPicker day() {
    return CardSettingsListPicker(
      key: _dayKey,
      icon: Icon(Icons.settings_display_outlined),
      label: 'Day',
      initialValue: " ",
      //    initialItem: _ponyModel.type,
      hintText: 'Select One',
      //   autovalidateMode: _autoValidateMode,
      options: alltypeDay,
      validator: (value) {
        if (value == " " || value.toString().isEmpty)
          return 'You must pick a day.';
        return null;
      },
      onSaved: (value) => typeDay = value,
      onChanged: (value) {
        setState(() {
          typeDay = value;
        });
        // widget.onValueChanged('Type', value);
      },
    );
  }

  CardSettingsTimePicker timeOpen() {
    return CardSettingsTimePicker(
      key: _openKey,
      icon: Icon(Icons.access_time),
      label: 'Time opening',
      initialValue: TimeOfDay(
          hour: showDateTimeOpen.hour, minute: showDateTimeOpen.minute),
      onSaved: (value) =>
          showDateTimeOpen = updateJustTime(value, showDateTimeOpen),
      onChanged: (value) {
        setState(() {
          showDateTimeOpen = updateJustTime(value, showDateTimeOpen);
        });
        // widget.onValueChanged('Show Time', value);
      },
    );
  }

  CardSettingsTimePicker timeClose() {
    return CardSettingsTimePicker(
      key: _closeKey,
      icon: Icon(Icons.access_time),
      label: 'Time closing',
      initialValue: TimeOfDay(
          hour: showDateTimeClose.hour, minute: showDateTimeClose.minute),
      onSaved: (value) =>
          showDateTimeClose = updateJustTime(value, showDateTimeClose),
      onChanged: (value) {
        setState(() {
          showDateTimeClose = updateJustTime(value, showDateTimeClose);
        });
        // widget.onValueChanged('Show Time', value);
      },
    );
  }

  CardSettingsParagraph restaurantAddressField() {
    return CardSettingsParagraph(
      key: _restaurantAddressKey,
      label: 'restaurantAddress',
      autovalidateMode: AutovalidateMode.onUserInteraction,
      requiredIndicator: Text('*', style: TextStyle(color: Colors.red)),
      initialValue: "",
      numberOfLines: 5,
      validator: (value) {
        if (value == null || value.isEmpty) return 'restaurantAddress is required.';
        return null;
      },
      onSaved: (value) => restaurantAddress = value,
      onChanged: (value) {
        setState(() {
          restaurantAddress = value;
        });
      },
    );
  }

  CardSettingsText phoneField() {
    return CardSettingsText(
      key: _phoneNumKey,
      label: "Phone number",
      initialValue: "",
      inputFormatters: <TextInputFormatter>[
        LengthLimitingTextInputFormatter(10),
      ],
      inputMask: '0000000000',
      keyboardType: TextInputType.number,
      requiredIndicator: Text('*', style: TextStyle(color: Colors.red)),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.isEmpty)
          return 'Phone number is required.';
        else if (value.length != 10)
          return 'must be at least 10 characters long.';
        else
          return null;
      },
      onSaved: (value) => phoneNumber = value,
      onChanged: (value) {
        setState(() {
          phoneNumber = value;
        });
      },
    );
  }

  // CardSettingsCheckboxPicker typeCheckBox() {
  //   return CardSettingsCheckboxPicker(
  //     key: _typeFoodKey,
  //     label: 'Type of food',
  //     initialValues: typeOfFood,
  //     options: allTypeOfFood,
  //     requiredIndicator: Text('*', style: TextStyle(color: Colors.red)),
  //     contentAlign: TextAlign.end,
  //     autovalidateMode: AutovalidateMode.onUserInteraction,
  //     validator: (value) {
  //       if (value == null || value.isEmpty)
  //         return 'You must pick at least one type of food.';

  //       return null;
  //     },
  //     onSaved: (value) => typeOfFood = value,
  //     onChanged: (value) {
  //       setState(() {
  //         typeOfFood = value;
  //       });
  //     },
  //   );
  // }

  CardSettingsListPicker typeFood() {
    return CardSettingsListPicker(
      key: _typeFoodKey,
      label: 'Type of food',
      requiredIndicator: Text('*', style: TextStyle(color: Colors.red)),
      initialValue: '',
      //    initialItem: _ponyModel.type,
      hintText: 'Select One',
      //   autovalidateMode: _autoValidateMode,
      options: allTypeOfFood,
      validator: (value) {
        if (value == " " || value.toString().isEmpty)
          return 'You must pick a type of food.';
        return null;
      },
      onSaved: (value) => typeOfFood = value,
      onChanged: (value) {
        setState(() {
          typeOfFood = value;
        });
        // widget.onValueChanged('Type', value);
      },
    );
  }

  CardSettingsText idField() {
    return CardSettingsText(
      key: _idKey,
      label: "Identification number",
      initialValue: "",
      inputFormatters: <TextInputFormatter>[
        LengthLimitingTextInputFormatter(13),
      ],
      inputMask: '0000000000000',
      keyboardType: TextInputType.number,
      requiredIndicator: Text('*', style: TextStyle(color: Colors.red)),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.isEmpty)
          return 'Identification number is required.';
        else if (value.length != 13)
          return 'must be at least 13 characters long.';
        else
          return null;
      },
      onSaved: (value) => restaurantIdNumber = value,
      onChanged: (value) {
        setState(() {
          restaurantIdNumber = value;
        });
      },
    );
  }

  CardSettingsText nameField() {
    return CardSettingsText(
      key: _nameKey,
      label: "Name",
      initialValue: "",
      requiredIndicator: Text('*', style: TextStyle(color: Colors.red)),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Name is required.';
        return null;
      },
      onSaved: (value) => name = value,
      onChanged: (value) {
        setState(() {
          name = value;
        });
      },
    );
  }

    CardSettingsText nameResField() {
    return CardSettingsText(
      key: _nameResKey,
      label: "Name restaurant",
      initialValue: "",
      requiredIndicator: Text('*', style: TextStyle(color: Colors.red)),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Name restaurant is required.';
        return null;
      },
      onSaved: (value) => restaurantNameshop= value,
      onChanged: (value) {
        setState(() {
          restaurantNameshop = value;
        });
      },
    );
  }
  CardSettingsText nameBranchField() {
    return CardSettingsText(
      key: _restaurantBranchKey,
      label: "Branch name",
      initialValue: "",
      requiredIndicator: Text('*', style: TextStyle(color: Colors.red)),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Branch name is required.';
        return null;
      },
      onSaved: (value) => restaurantBranch= value,
      onChanged: (value) {
        setState(() {
          restaurantBranch = value;
        });
      },
    );
  }

  //แก้ไขค่าใน table restaurant
  Future<Null> UpdateRegisterThread() async {

     //1.หาค่า restaurantId ของผู้ที่ login
     SharedPreferences preferences = await SharedPreferences.getInstance();
     String? restaurantId = preferences.getString('restaurantId');

     String url = '${Myconstant().domain}/res_reserve/updateRegisterRestaurant.php?isAdd=true&restaurantId=$restaurantId&restaurantPicture=$restaurantPicture&restaurantIdNumber=$restaurantIdNumber&restaurantNameshop=$restaurantNameshop&restaurantBranch=$restaurantBranch&restaurantAddress=$restaurantAddress&typeOfFood=$typeOfFood';
     await Dio().get(url).then((value){
       if(value.toString()=='true'){
         Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeRes2()));
       } else{
         normalDialog(context, 'try again');
       }
     });

     
  }
//   Future<Null> insetTypeFood() async {
//    String url = '';

//       for(var i = 0; i < typeOfFood!.length; i++){
//               print(typeOfFood![i]);
//               var typeOfFood_ = typeOfFood![i];
            
// }
//   }

  

}
