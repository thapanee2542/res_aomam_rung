import 'dart:convert';

import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/model/reservation_model.dart';
import 'package:flutter_rrs_app/model/reserve_details_model.dart';
import 'package:flutter_rrs_app/model/user_model.dart';
import 'package:flutter_rrs_app/screen/restaurant/show_info_reserve_unconfirm.dart';
import 'package:flutter_rrs_app/screen/restaurant/show_info_reserve_confirm.dart';
import 'package:flutter_rrs_app/utility/my_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowConfirm extends StatefulWidget {
  ShowConfirm({Key? key}) : super(key: key);

  @override
  _ShowUnconfirmState createState() => _ShowUnconfirmState();
}

class _ShowUnconfirmState extends State<ShowConfirm> {
  bool loadStatus = true; //ยังไม่มีข้อมูล
  bool showIconNoreserve = false;
  List<ReserveDetailsModel> reserveDetailsModels = [];

  @override
  void initState() {
    super.initState();
    loadReserveDetail().then((value) {
      if (reserveDetailsModels.length == 0) {
        setState(() {
          loadStatus = false;
          showIconNoreserve = true;
        });
      }
    });
  }

  Future<Null> loadReserveDetail() async {
    if (reserveDetailsModels.length != 0) {
      reserveDetailsModels.clear();
    }

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? restaurantId = preferences.getString('restaurantId');
    String reservationStatus = 'confirm';

    var url =
        '${Myconstant().domain}/res_reserve/get_reserve_detail_where_status_unconfirm.php?isAdd=true&restaurantId=$restaurantId&reservationStatus=$reservationStatus';
    await Dio().get(url).then((value) {
      if (value.toString() != 'null') {
        setState(() {
          loadStatus = false;
        });
        var result = json.decode(value.data);
        print(result);
        for (var map in result) {
          ReserveDetailsModel reserveDetailsModel =
              ReserveDetailsModel.fromJson(map);
          setState(() {
            reserveDetailsModels.add(reserveDetailsModel);
          });
        }
      }
      return reserveDetailsModels;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loadStatus
        ? showProgress()
        : Scaffold(
            body: ListView.builder(
                itemCount: reserveDetailsModels.length,
                itemBuilder: (context, index) {
                  return Stack(children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ShowInfoConfirm(
                                      reserveDetailsModel:
                                          reserveDetailsModels[index],
                                    ))).then((value) {
                          setState(() {
                            loadStatus = true;
                          });
                          loadReserveDetail();
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
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Color(0xffF1B739),
                                      child: Icon(
                                        Icons.account_circle,
                                        size: 60,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      height: 70,
                                      width: 200,
                                      //  color: Colors.pink,

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
                                              '${reserveDetailsModels[index].name}',
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
                                                '${reserveDetailsModels[index].phonenumber}',
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.chair,
                                                size: 20,
                                                color: Colors.green,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              reserveDetailsModels[index]
                                                          .orderfoodId
                                                          .toString() ==
                                                      '0'
                                                  ? Text('')
                                                  : Icon(
                                                      Icons.dining,
                                                      size: 20,
                                                      color: Colors.green,
                                                    ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                '${reserveDetailsModels[index].reservationStatus}',
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          )
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
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Color(0xffFAE0A3),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0))),
                                      child: Padding(
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
                                                '${reserveDetailsModels[index].reservationDate}'),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Color(0xffFAE0A3),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0))),
                                      child: Padding(
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
                                                '${reserveDetailsModels[index].reservationTime.toString().substring(10, 15)}')
                                          ],
                                        ),
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
                                    builder: (context) => ShowInfoConfirm(
                                          reserveDetailsModel:
                                              reserveDetailsModels[index],
                                        ))).then((value) {
                              setState(() {
                                loadStatus = true;
                              });
                              loadReserveDetail();
                            });
                          },
                          icon: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 18,
                            color: Colors.grey[300],
                          ),
                        ))
                  ]);
                }),
          );
  }
  Column iconNoReserve() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/reservetable_icon.png',fit: BoxFit.fill,width: 150,height: 150,),    
          Text('No confirmed reserves',style: TextStyle(color: Colors.grey,fontSize: 18),),
        ],
      );
  }

  Center showProgress() => Center(
        child: CircularProgressIndicator(),
      );
}
