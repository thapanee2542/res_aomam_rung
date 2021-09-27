import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/model/bank_account_model.dart';
import 'package:flutter_rrs_app/screen/restaurant/add_bank_account.dart';
import 'package:flutter_rrs_app/utility/my_constant.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowBankAccount extends StatefulWidget {
  ShowBankAccount({Key? key}) : super(key: key);

  @override
  _ShowBankAccountState createState() => _ShowBankAccountState();
}

class _ShowBankAccountState extends State<ShowBankAccount> {
  List<BankAccountModel> bankAccountModels = [];
  bool loadStatus = true;
  @override
  void initState() {
    super.initState();
    readBankAccount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: addAccountutton(context),
      appBar: AppBar(
        title: Text('Bank account'),
        backgroundColor: Color(0xffF1B739),
      ),
      body: loadStatus
          ? showProgress()
          : Container(
              child: ListView.builder(
                  itemCount: bankAccountModels.length,
                  itemBuilder: (context, index) {
                    return Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      secondaryActions: [
                        IconSlideAction(
                          caption: 'Delete',
                          color: Colors.red,
                          icon: Icons.delete,
                          onTap: () {
                            deleteBankAccount(bankAccountModels[index]);
                          },
                        )
                      ],
                      child: Container(
                        margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10.0,
                                offset: new Offset(0.0, 10.0),
                              ),
                            ],
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0))),
                        child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 35,
                                      backgroundImage: NetworkImage(
                                          '${Myconstant().domain}/res_reserve${bankAccountModels[index].accountPicture}'),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      height: 60,
                                     
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                            Text(
                                            '${bankAccountModels[index].nameBank}',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            '${bankAccountModels[index].accountName}',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            '${bankAccountModels[index].accountNumber.toString()}',
                                            style: TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            )),
                      ),
                    );
                  }),
            ),
    );
  }

  Widget addAccountutton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
                backgroundColor: Color(0xff1CA7EA),
                child: Icon(Icons.add),
                onPressed: () {
                  //ถ้ากลับมาจะสั่งให้บิ้วใหม่
                  Navigator.push(context,
                          MaterialPageRoute(builder: (context) => AddAccount()))
                      .then((value) {
                        setState(() {
                          loadStatus = true;
                        });
                        readBankAccount();
                      });
                }),
          ],
        ),
      ],
    );
  }

  Future<Null> deleteBankAccount(BankAccountModel bankAccountModel) async {
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              title: Text(
                'Do You want to delete this account ?',
                style: TextStyle(color: Colors.red),
              ),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'cancel',
                          style: TextStyle(color: Colors.blue, fontSize: 17),
                        )),
                    TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          setState(() {
                            loadStatus = true;
                          });
                          String? url =
                              '${Myconstant().domain}/res_reserve/delete_bank_account_where_id.php?isAdd=true&paymentmethodId=${bankAccountModel.paymentmethodId}';
                          await Dio().get(url).then((value) {
                            if (value.toString() == 'true') {
                              readBankAccount();
                            }
                          });
                        },
                        child: Text(
                          'confirm',
                          style: TextStyle(color: Colors.blue, fontSize: 17),
                        )),
                  ],
                )
              ],
            ));
  }

  Center showProgress() => Center(
        child: CircularProgressIndicator(),
      );

  Future<Null> readBankAccount() async {
    if (bankAccountModels.length != 0) {
      bankAccountModels.clear();
    }
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? restaurantId = preferences.getString('restaurantId');

    String url =
        '${Myconstant().domain}/res_reserve/get_bank_account_where_restaurantId.php?isAdd=true&restaurantId=$restaurantId';

    try {
      await Dio().get(url).then((value) {
        if (value.toString() != 'null') {
          setState(() {
            loadStatus = false;
          });
          var result = json.decode(value.data);
          for (var map in result) {
            BankAccountModel bankAccountModel = BankAccountModel.fromJson(map);
            setState(() {
              bankAccountModels.add(bankAccountModel);
            });
          }
        }
      });
    } catch (e) {}
  }
}
