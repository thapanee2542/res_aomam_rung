import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/model/order_food_model.dart';
import 'package:flutter_rrs_app/screen/restaurant/show_info_food_cancel.dart';
import 'package:flutter_rrs_app/screen/restaurant/show_info_food_completed.dart';
import 'package:flutter_rrs_app/screen/restaurant/show_info_food_confirm.dart';
import 'package:flutter_rrs_app/screen/restaurant/show_info_food_unconfirm.dart';
import 'package:flutter_rrs_app/utility/my_constant.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowFoodCompleted extends StatefulWidget {
  ShowFoodCompleted({Key? key}) : super(key: key);

  @override
  _ShowFoodUnconfirmState createState() => _ShowFoodUnconfirmState();
}

class _ShowFoodUnconfirmState extends State<ShowFoodCompleted> {
  bool loadStatus = true; //ยังไม่มีข้อมูล
  bool showIconNoCaceled = false;
  final formatCurrency = new NumberFormat("#,##0.00", "en_US");

  @override
  void initState() {
    super.initState();
    loadOrderFood().then((value) {
      if (orderFoodModels.length == 0) {
        setState(() {
          loadStatus = false;
          showIconNoCaceled = true;
        });
      }
    });
  }
   String getNetPrice(String _netPrice, String _discount, String _promotionId) {
    int discount;
    //แปลง String เป็น List ของราคาอาหารแต่ละอย่าง
    List<String> listPrice = changeArray(_netPrice);
    //แปลง String เป็น Int
    _promotionId == '0' ? discount = 0 : discount = int.parse(_discount);
    //หาราคารวมทั้งหมด
    int totalPrices = totalPrice(listPrice);
    //หาราคาส่วนลด
    double discountAmounts = discountAmount(discount, totalPrices);
    //หาราคารวมทั้งหมดหลังหักส่วนลด
    double totalPriceAfterDiscounts =
        totalPriceAfterDiscount(totalPrices, discount);
    return formatCurrency.format(totalPriceAfterDiscounts);
  }

  //  ฟังก์ชันราคารวมทั้งหมดหลังหักส่วนลด
  double totalPriceAfterDiscount(int totalPrice, int discount) {
    double afterDiscount = totalPrice - (totalPrice * (discount / 100));
    return afterDiscount;
  }

  // ฟังก์ชันหาราคาส่วนลด
  double discountAmount(int discount, int totalPrice) {
    double discountAmount = totalPrice * (discount / 100);
    return discountAmount;
  }

// ฟังก์ชันหาราคารวมของอาหาร ยังไม่หักลบจากส่วนลดต่างๆ
  int totalPrice(List<String> listPrices) {
    int totalPrice = 0;
    for (int index = 0; index < listPrices.length; index++) {
      int price = int.parse(listPrices[index]);
      totalPrice = totalPrice + price;
    }
    return totalPrice;
  }

//function เปลี่ยนarray
  List<String> changeArray(String string) {
    List<String> list = [];
    String myString = string.substring(1, string.length - 1);
    print('myString =$myString');
    list = myString.split(',');
    int index = 0;
    for (String string in list) {
      list[index] = string.trim();
      index++;
    }
    return list;
  }

  List<OrderFoodModel> orderFoodModels = [];
  @override
  Widget build(BuildContext context) {
    return loadStatus==true
        ? showProgress()
        : showIconNoCaceled==true
        ? iconNoCanceled()
        : Scaffold(
            body: ListView.builder(
                itemCount: orderFoodModels.length,
                itemBuilder: (context, index) {
                  return Stack(children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (contxt) => ShowInfoFoodCompleted(
                                      orderFoodModel: orderFoodModels[index],
                                    ))).then((value) {
                          setState(() {
                            loadStatus = true;
                          });
                          loadOrderFood();
                        });
                      },
                      child: Container(
                          margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
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
                                  BorderRadius.all(Radius.circular(10.0))),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                        Image.asset(
                                      'assets/images/user.png',
                                      width: 60,
                                      height: 60,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 10, 0, 0),
                                            child: Text(
                                              '${orderFoodModels[index].name}',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.call,
                                                size: 15,
                                                color: Colors.grey,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                '${orderFoodModels[index].phonenumber}',
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.dining,
                                                size: 20,
                                                color: Colors.green,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                '${orderFoodModels[index].orderfoodStatus}',
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                           Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                '${getNetPrice(orderFoodModels[index].netPrice.toString(), orderFoodModels[index].promotionDiscount.toString(), orderFoodModels[index].promotionId == null ? '0' : orderFoodModels[index].promotionId.toString())}',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.green),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                '₭',
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.date_range,
                                            color: Colors.grey[600],
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                              '${orderFoodModels[index].orderfoodDateTime!.substring(0, 11)}'),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.access_time_outlined,
                                            color: Colors.grey[600],
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                              '${orderFoodModels[index].orderfoodDateTime!.substring(11, 16)}')
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )),
                    ),
                    Positioned(
                        top: -9,
                        right: 4,
                        child: IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (contxt) => ShowInfoFoodCompleted(
                                          orderFoodModel:
                                              orderFoodModels[index],
                                        ))).then((value) {
                              setState(() {
                                loadStatus = true;
                              });
                              loadOrderFood();
                            });
                          },
                          icon: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 18,
                            color: Colors.grey[300],
                          ),
                        )),
                  ]);
                }),
          );
  }Column iconNoCanceled() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/menu_icon.png',fit: BoxFit.fill,width: 150,height: 150,),
          SizedBox(height: 20,),
          Text('No completed orders',style: TextStyle(color: Colors.grey,fontSize: 18),),
        ],
      );
  }

  Center showProgress() => Center(
        child: CircularProgressIndicator(),
      );

  Future<Null> loadOrderFood() async {
    if (orderFoodModels.length != 0) {
      orderFoodModels.clear();
    }

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? restaurantId = preferences.getString('restaurantId');
    String orderfoodStatus = 'completed';
    var url =
        '${Myconstant().domain}/res_reserve/get_all_orderfood_where_restaurantId_and_status.php?isAdd=true&restaurantId=$restaurantId&orderfoodStatus=$orderfoodStatus';

    await Dio().get(url).then((value) {
      if (value.toString() != 'null') {
        setState(() {
          loadStatus = false;
        });
        var result = json.decode(value.data);
        print(result);
        for (var map in result) {
          OrderFoodModel orderFoodModel = OrderFoodModel.fromJson(map);
          setState(() {
            orderFoodModels.add(orderFoodModel);
          });
        }

        for (int index = 0; index < orderFoodModels.length; index++) {
          print('food menu name === ${orderFoodModels[index].foodmenuName}');
          String foodname = orderFoodModels[index]
              .foodmenuName
              .toString()
              .replaceAll(RegExp(r'(?:_|[^\w\s])+'), "");
          print('food name $index === $foodname');
        }
      }
    });
  }

  
}
