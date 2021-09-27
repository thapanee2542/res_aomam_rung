import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/utility/my_constant.dart';
import 'package:flutter_rrs_app/utility/normal_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddAccount extends StatefulWidget {
  AddAccount({Key? key}) : super(key: key);

  @override
  _AddAccountState createState() => _AddAccountState();
}

class _AddAccountState extends State<AddAccount> {
  final _formkey = GlobalKey<FormState>();
  BankCategories? bankSelect;
  bool loadSaveButton = false;
  String? bankCategoriesId;
String? accountPicture;
  String? accountNumber;
  String? accountName;
  static List<BankCategories> bankList = [
    BankCategories(bankName: 'AGRICULTURAL PROMOTION BANK', logo: 'assets/images/bank_logo_apb.png',id: '1'),
    BankCategories(
        bankName: 'BCEL', logo: 'assets/images/bank_logo_bcel.png',id: '2'),
    BankCategories(
        bankName: 'LAO DEVELOPMENT BANK', logo: 'assets/images/bank_logo_ldb.png',id: '3'),
     BankCategories(
        bankName: 'PHONGSAVANH BANK LTD', logo: 'assets/images/bank_logo_psv.png',id: '4'),
    BankCategories(
        bankName: 'ST BANK LTD', logo: 'assets/images/bank_logo_stb.jfif',id: '5')
    
   
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add account'),
        backgroundColor: Color(0xffF1B739),
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
                    "Select bank name",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  dropdownSelectBank(),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    "Account number",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  formAccountNumber(),
                    SizedBox(
                    height: 25,
                  ),
                  Text(
                    "Account name",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  formAccountName(),
                    SizedBox(
                    height: 25,
                  ),
                saveButton()
                ],
              ),
            )),
      ),
    );
  }

  Widget dropdownSelectBank() {
    return Container(
      child: FormField<String>(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select bank.';
          }
        },
        onSaved: (value) {
          bankSelect = value as BankCategories?;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        builder: (FormFieldState<String> state) {
          return InputDecorator(
            decoration: InputDecoration(
                errorText: state.errorText,
                contentPadding: EdgeInsets.fromLTRB(12, 10, 20, 20),
                border: OutlineInputBorder()),
            child: DropdownButtonHideUnderline(
                child: DropdownButton<BankCategories>(
              menuMaxHeight: 300,
              style: TextStyle(
                fontSize: 16,
              ),
              hint: Text(
                'Select bank',
                style: TextStyle(fontSize: 16),
              ),
              items: bankList.map<DropdownMenuItem<BankCategories>>(
                  (BankCategories valueItem) {
                return DropdownMenuItem(
                  value: valueItem,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: AssetImage('${valueItem.logo}'),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            '${valueItem.bankName.toString()}',
                            style: TextStyle(color: Colors.black, fontSize: 12),
                          ),
                        ],
                      ),

                      // SizedBox(width: 20,),
                    ],
                  ),
                );
              }).toList(),
              value: bankSelect,
              isExpanded: true,
              isDense: true,
              onChanged: (newSelect) {
                state.didChange(newSelect.toString());
                setState(() {
                  bankSelect = newSelect;
                  print(bankSelect);
                });
              bankCategoriesId = bankSelect!.id;
              },
            )),
          );
        },
      ),
    );
  }

  

  Widget formAccountNumber() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty ){ return 'Account number is required.';}
        else if(value.length <10 ||value.length>10){return 'Please enter 10 digits.';}
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onSaved: (value) => accountNumber = value,
      onChanged: (value) {
        setState(() {
          accountNumber = value;
        });
      },
      keyboardType: TextInputType.number,
      
      
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10), border: OutlineInputBorder()),
    );
  }

  Widget formAccountName() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) return 'Account name is required.';
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onSaved: (value) => accountName = value,
      onChanged: (value) {
        setState(() {
          accountName = value;
        });
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10), border: OutlineInputBorder()),
    );
  }

Future insertData() async {
   //ดึงค่าของ restaurantId ออกมา 
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? restaurantId = preferences.getString('restaurantId');
  String url = '${Myconstant().domain}/res_reserve/add_payment_account.php?restaurantId=$restaurantId&accountNumber=$accountNumber&accountName=$accountName&bank_categories_id=$bankCategoriesId&isAdd=true';
  try {
    await Dio().get(url).then((value){
     if(value.toString() == 'true'){
       Navigator.pop(context);
     }else {
       normalDialog(context, 'Try gain');
       setState(() {
         loadSaveButton = false;
       });
       };
    });
  } catch (e) {
  }
}
  

  Widget saveButton() => Container(
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Color(0xffF1B739),
          ),
          child: loadSaveButton ? Container(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(color: Colors.blue,)):
          Text('save',style: TextStyle(fontSize: 17),),
          onPressed: () {
            if (_formkey.currentState!.validate()) {
              setState(() {
                loadSaveButton = true;
              });
              print('account number = $accountNumber');
              print('account name  = $accountName');
              print('categories id = $bankCategoriesId');

              insertData();
            }
          },
        ),
      );
}

class BankCategories {
  final String bankName;
  final String logo;
  final String id;

  BankCategories({
    required this.bankName,
    required this.logo,
    required this.id,
  });
}
