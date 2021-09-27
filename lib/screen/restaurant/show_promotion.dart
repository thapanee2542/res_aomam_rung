import 'dart:convert';

import 'dart:math' as math;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/model/all_discount_promotion_model.dart';
import 'package:flutter_rrs_app/model/promotion_model.dart';
import 'package:flutter_rrs_app/screen/restaurant/add_pro_buy1get1.dart';
import 'package:flutter_rrs_app/screen/restaurant/add_pro_foodmenu_reduction.dart';
import 'package:flutter_rrs_app/screen/restaurant/edit_pro_all_discount.dart';
import 'package:flutter_rrs_app/screen/restaurant/edit_pro_foodmenu_reduction.dart';
import 'package:flutter_rrs_app/screen/restaurant/edit_pro_gbuy1_get1.dart';

import 'package:flutter_rrs_app/utility/my_constant.dart';
import 'package:flutter_rrs_app/utility/my_font.dart';
import 'package:flutter_rrs_app/utility/normal_dialog.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'add_pro_alldiscount.dart';

class ShowPromotion extends StatefulWidget {
  ShowPromotion({Key? key}) : super(key: key);

  @override
  _ShowTableState createState() => _ShowTableState();
}

class _ShowTableState extends State<ShowPromotion> {
  List<PromotionModel> promotionModels = [];
  List<PromotionModel> promotionModelsHistory = [];
  bool status = true; //มีข้อมูลโปรโมชั่น
  bool loadStatus = true;
  var checkDateTime;
  FToast? fToast;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readPromotionActive();
    readPromotionHistory();
    fToast = FToast();
    fToast!.init(context);
  }

  String checkLengthTime(int time) {
    String _time;
    if (time.toString().length == 1) {
      _time = '0' + time.toString();
      return _time;
    } else
      return time.toString();
  }

  String timesBetween(DateTime from, DateTime to) {
    //รับค่า Dateime เข้ามา
    from = DateTime(from.year, from.month, from.day, from.hour, from.minute);
    to = DateTime(to.year, to.month, to.day, to.hour, to.minute);
    print('from.hour = $from');
    print('to.hour = $to');

    //ตัดDateTime ให้เหลือเฉพาะชั่วโมงและนาที แล้วแปลงเป็นตัวเลข
    int fromMinute = int.parse(from.toString().substring(14, 16));
    print('from.minute = $fromMinute');
    int fromHour = int.parse(from.toString().substring(11, 13));
    print('from.hour = $fromHour');
    int toMinute = int.parse(to.toString().substring(14, 16));
    print('to.minute = $toMinute');
    int toHour = int.parse(to.toString().substring(11, 13));
    print('to.hour = $toHour');

    //แปลงชั่วโมงเป็นนาที แล้วบวกกับนาทีที่เหลือ
    int minuteFrom = (fromHour * 60) + fromMinute;
    int minuteTo = (toHour * 60) + toMinute;
    print('minuteFrom = $minuteFrom');
    print('minuteTo = $minuteTo');

    //นำนาทีมาลบกับ
    int diffMinute = (minuteFrom - minuteTo).abs();
    print('diffMinute = $diffMinute');
    //แปลงนาทีเป็นชั่วโมง
    int minute = diffMinute % 60;
    int hour = (diffMinute / 60).toInt();
    print('minute = $minute');
    print('Hour = $hour');
    //ส่งตัวเลขที่คำนวณได้ไปตรวจสอบว่ามีหลักเียวมั้ย ถ้ามีหลัเดียวให้เพิ่ม 0 ข้างหน้า 1 ตัว
    String minuteCheck = checkLengthTime(minute);
    String hourCheck = checkLengthTime(hour);
    print('minuteCheck = $minuteCheck');
    print('hourCheck= $hourCheck');

    String timeDifference = hourCheck + ":" + minuteCheck;
    print('timeDifference = $timeDifference');

    // int diffDay = (to.difference(from).inHours / 24).round();

    return timeDifference;
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day, from.hour, from.minute);
    to = DateTime(to.year, to.month, to.day, to.hour, to.minute);

    print('from = $from,to = $to');

    return (to.difference(from).inHours / 24).round();
  }

  Row getDate(String sDate, String eDate, String sTime, String eTime,
      String _promotionId) {
    String promotionId = _promotionId;

    // print('sDate = $sDate,eDate=$eDate,sTime=$sTime,eTime=$eTime ');
    TimeOfDay startTime = TimeOfDay(
        hour: int.parse(sTime.split(":")[0]),
        minute: int.parse(sTime.split(":")[1]));
    TimeOfDay endTime = TimeOfDay(
        hour: int.parse(eTime.split(":")[0]),
        minute: int.parse(eTime.split(":")[1]));
    String timeDifference;
    DateTime timeNow = DateTime.now();

    print('start time = $startTime');
    String sDateTime = sDate + " " + sTime;
    String eDateTime = eDate + " " + eTime;
    // print('sDT = $sDateTime,eDT = $eDateTime');
    DateTime startDateTime = DateTime.parse(sDateTime);
    DateTime endDateTime = DateTime.parse(eDateTime);

    DateTime dateNow = DateTime.now();
    String subDateNow = dateNow.toString().substring(0, 10);
    print('sub date now = $subDateNow,end date = $eDate');

    int difference;
    // print('start = $startDateTime,finish=$endDateTime,now = $dateNow');

    //1. ถ้าวันที่เริ่มต้นโปรโมชั่น อยู่หลังวันที่ปัจจุบัน now-----start ให้นำ satat-now = จำนวนวันที่ถึงโปรโมชั่น
    if (startDateTime.isAfter(dateNow)) {
      difference = daysBetween(dateNow, startDateTime);

      return Row(
        children: [
          Icon(
            Icons.access_alarm_outlined,
            color: Colors.blue,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            'Coming in $difference days',
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
          ),
        ],
      );
      //2.ถ้าวันที่ปัจจุบันตรงกับวันที่เริ่มต้น และวันที่ปัจจุบันตรงกับวันที่สิ้นสุด(วันที่เริ่มต้นกับวันที่สิ้นสุดเป็นวันเดียวกัน) ให้แสดงเวลาที่เหลือ
    } else if ((subDateNow == sDate && sDate == eDate) ||
        daysBetween(dateNow, endDateTime) == 0) {
      TimeOfDay timeDatenow = TimeOfDay.fromDateTime(dateNow);
      TimeOfDay timeEndDate = TimeOfDay.fromDateTime(endDateTime);

      //ถ้าเวลาปัจจุบันยู่หลังเวลาสิ้นสุด หรือเวลาปัจจุบันเท่ากับเวลาสิ้นสุด ให้แก้ไขสถานะของโปรโมชั่นเป็น false
      if (timeDatenow.hour >= timeEndDate.hour &&
          timeDatenow.minute >= timeEndDate.minute) {
        editValueOnMySQL(promotionId);

        return Row(
          children: [
            Icon(
              Icons.access_alarm_outlined,
              color: Colors.red,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              'Out of time',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
            ),
          ],
        );
      } else {
        print('timeDatenow = $timeDatenow');
        timeDifference = timesBetween(dateNow, endDateTime);
        print('difftime = $timeDifference');
        return Row(
          children: [
            Icon(
              Icons.access_alarm_outlined,
              color: Colors.red,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              '$timeDifference times left',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
            ),
          ],
        );
      }
    }

    //3.ถ้าวันที่ปัจจุบันอยู่ระหว่างวันที่เริ่มและจบโปรโมชั่น  start---now---end หรือ วันที่เริ่มตรงกับวันที่ปัจจุบัน  ให้นำ end-now = จำนวนวันที่เหลือของโปรโมชั่น
    else if ((startDateTime.isBefore(dateNow) && endDateTime.isAfter(dateNow))
        // ||
        // startDateTime.isAtSameMomentAs(dateNow)&&endDateTime.isAfter(startDateTime)
        ) {
      difference = daysBetween(dateNow, endDateTime);
      print(
          '2.start = $startDateTime,finish=$endDateTime,now = $dateNow,diff=$difference');
      return Row(
        children: [
          Icon(
            Icons.access_alarm_outlined,
            color: Colors.red,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            '$difference days left',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
          ),
        ],
      );
    } else if (dateNow.isAfter(startDateTime) && dateNow.isAfter(endDateTime)) {
      return Row(
        children: [
          Icon(
            Icons.access_alarm_outlined,
            color: Colors.red,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            'Out of time',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
          ),
        ],
      );
    } else
      return Row(
        children: [
          Icon(
            Icons.access_alarm_outlined,
            color: Colors.blue,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            'No',
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
          ),
        ],
      );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(30.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 35,
                    child: TabBar(
                      unselectedLabelColor: Colors.grey,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.amber),
                      tabs: [
                        Tab(
                          child: Container(
                            height: 35,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                    color: Color(0xffF1B739), width: 1)),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.alarm_on_rounded),
                                  Text("Active"),
                                ]),
                          ),
                        ),
                        Tab(
                          child: Container(
                            height: 35,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                    color: Color(0xffF1B739), width: 1)),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.alarm_off_rounded),
                                  Text("History"),
                                ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(children: [
          loadStatus ? showProgress() : showListAllDiscountActive(),
          loadStatus ? showProgress() : showListAllDiscountHistory(),
        ]),
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          backgroundColor: Color(0xff1CA7EA),
          children: [
            SpeedDialChild(
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
              label: 'Buy 1 Get 1 Free',
              onTap: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddProBuyOneGetOne()))
                    .then((value) => readPromotionActive());
              },
              backgroundColor: Color(0xff9DA3B3),
            ),
            SpeedDialChild(
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
              label: 'Food price reduction',
              backgroundColor: Color(0xff9DA3B3),
              onTap: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddProFoodMenuReduction()))
                    .then((value) => readPromotionActive());
              },
            ),
            SpeedDialChild(
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
              label: 'All discount',
              backgroundColor: Color(0xff9DA3B3),
              onTap: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddProAllDiscount()))
                    .then((value) => readPromotionActive());
              },
            )
          ],
        ),
      ),
    );
  }

  Center showProgress() => Center(
        child: CircularProgressIndicator(),
      );

  Future<Null> readPromotionActive() async {
    if (promotionModels.length != 0) {
      promotionModels.clear();
    }

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? restaurantId = preferences.getString('restaurantId');

    String url =
        '${Myconstant().domain}/res_reserve/getAllDisPromotionWhereRestaurantId.php?restaurantId=$restaurantId&isAdd=true';
    await Dio().get(url).then((value) {
      setState(() {
        loadStatus = false;
      });

      if (value.toString() != 'null') {
        var result = json.decode(value.data);
        for (var map in result) {
          PromotionModel promotionModel = PromotionModel.fromJson(map);
          setState(() {
            promotionModels.add(promotionModel);
          });
        }
      } else {
        setState(() {
          status = false;
        });
      }
    });
  }

  Future<Null> readPromotionHistory() async {
    if (promotionModelsHistory.length != 0) {
      promotionModelsHistory.clear();
    }

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? restaurantId = preferences.getString('restaurantId');

    String url =
        '${Myconstant().domain}/res_reserve/getAllDisPromotionHistoryWhereRestaurantId.php?restaurantId=$restaurantId&isAdd=true';
    await Dio().get(url).then((value) {
      setState(() {
        loadStatus = false;
      });

      if (value.toString() != 'null') {
        var result = json.decode(value.data);
        for (var map in result) {
          PromotionModel promotionModel = PromotionModel.fromJson(map);
          setState(() {
            promotionModelsHistory.add(promotionModel);
          });
        }
      } else {
        setState(() {
          status = false;
        });
      }
    });
  }

  Future<Null> editValueOnMySQL(String id) async {
    String promotion_status = 'false';
    String promotionId = id;
    String url =
        '${Myconstant().domain}/res_reserve/edit_pro_status_where_promotionId.php?isAdd=true&promotion_id=$promotionId&promotion_status=$promotion_status';

    await Dio().get(url).then((value) {
      if (value.toString() == 'true') {
      } else {}
    });
  }

  Widget showListAllDiscountActive() {
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 32),
      child: ListView.builder(
          // separatorBuilder: (context, index) {
          //   return Divider(
          //     height: 0,
          //     thickness: 0,
          //   );
          // },
          itemCount: promotionModels.length,
          itemBuilder: (context, index) {
            return Stack(children: [
              Container(
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
                    borderRadius: BorderRadius.all(Radius.circular(8.0))),
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                    child: showListAllPromotion(index)),
              ),
              Positioned(
                  top: -12,
                  right: 5,
                  child: TextButton(
                    style: ButtonStyle(
                        overlayColor:
                            MaterialStateProperty.all(Colors.grey[100])),
                    child: Row(
                      children: [
                        Text(
                          'Edit',
                          style: TextStyle(color: Colors.blue, fontSize: 12),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 12,
                          color: Colors.blue,
                        )
                      ],
                    ),
                    onPressed: () {
                      if (promotionModels[index].promotionType ==
                              "Order food" ||
                          promotionModels[index].promotionType ==
                              "Reserve a table") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProAllDiscount(
                                      promotionModel: promotionModels[index],
                                    ))).then((value) => readPromotionActive());
                      } else if (promotionModels[index].promotionType ==
                          "Food discount") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProFoodMenuReduction(
                                      promotionModel: promotionModels[index],
                                    ))).then((value) => readPromotionActive());
                      } else if (promotionModels[index].promotionType ==
                          "Buy 1 get 1 free") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProBuyOneGetOneFree(
                                      promotionModel: promotionModels[index],
                                    ))).then((value) => readPromotionActive());
                      } else
                        null;
                    },
                  ))
            ]);
          }),
    );
  }

  Widget showListAllDiscountHistory() {
    return Container(
      child: ListView.builder(
          itemCount: promotionModelsHistory.length,
          itemBuilder: (context, index) {
            return Stack(children: [
              Container(
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
                    borderRadius: BorderRadius.all(Radius.circular(8.0))),
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                    child: showListAllPromotionHistory(index)),
              ),
              Positioned(
                  top: -12,
                  right: 5,
                  child: TextButton(
                    style: ButtonStyle(
                        overlayColor:
                            MaterialStateProperty.all(Colors.grey[100])),
                    child: Row(
                      children: [
                        // Text(
                        //   'Edit',
                        //   style: TextStyle(color: Colors.blue, fontSize: 12),
                        // ),
                        // Icon(
                        //   Icons.arrow_forward_ios_rounded,
                        //   size: 12,
                        //   color: Colors.blue,
                        // )
                      ],
                    ),
                    onPressed: () {
                      if (promotionModelsHistory[index].promotionType ==
                              "Order food" ||
                          promotionModelsHistory[index].promotionType ==
                              "Reserve a table") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProAllDiscount(
                                      promotionModel:
                                          promotionModelsHistory[index],
                                    ))).then((value) => readPromotionActive());
                      } else if (promotionModelsHistory[index].promotionType ==
                          "Food discount") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProFoodMenuReduction(
                                      promotionModel:
                                          promotionModelsHistory[index],
                                    ))).then((value) => readPromotionActive());
                      } else if (promotionModelsHistory[index].promotionType ==
                          "Buy 1 get 1 free") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProBuyOneGetOneFree(
                                      promotionModel:
                                          promotionModelsHistory[index],
                                    ))).then((value) => readPromotionActive());
                      } else
                        null;
                    },
                  ))
            ]);
          }),
    );
  }

  Column showListAllPromotionHistory(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Show type of promotion
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '---- ${promotionModelsHistory[index].promotionType} ----',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        //บอกจำนวนวันและเวลาที่ใกล้จะมาถึงและยังมาไม่ถึง
        getDate(
            promotionModelsHistory[index].promotionStartDate.toString(),
            promotionModelsHistory[index].promotionFinishDate.toString(),
            promotionModelsHistory[index].promotionStartTime.toString(),
            promotionModelsHistory[index].promotionFinishTime.toString(),
            promotionModelsHistory[index].promotionId.toString()),

        //Show text Promotion start and end date :
        MyFont().textS17W500Black('Promotion start and end date :'),

        //Show date
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.date_range,
              color: Colors.black54,
            ),
            MyFont().textS17W400Black(
                '${promotionModelsHistory[index].promotionStartDate} - ${promotionModelsHistory[index].promotionFinishDate}'),
          ],
        ),

        //Show time
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.access_time,
              color: Colors.black54,
            ),
            MyFont().textS17W400Black(
                '${promotionModelsHistory[index].promotionStartTime} - ${promotionModelsHistory[index].promotionFinishTime}'),
          ],
        ),
        Divider(),

        Row(
          children: [
            MyFont().textS17W500Black('Promotion details :'),
          ],
        ),
        promotionModelsHistory[index].promotionDiscount != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyFont().textS17W400Black('Discount'),
                  MyFont().textS17W400Black(
                      '${promotionModelsHistory[index].promotionDiscount} %'),
                ],
              )
            : Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyFont().textS17W400Black('Normal price'),
                      MyFont().textS17W400Black(
                          '${promotionModelsHistory[index].promotionOldPrice}')
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyFont().textS17W400Black('Promotion price'),
                      MyFont().textS17W400Black(
                          '${promotionModelsHistory[index].promotionNewPrice}')
                    ],
                  )
                ],
              )
      ],
    );
  }

  Column showListAllPromotion(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Show type of promotion
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '---- ${promotionModels[index].promotionType} ----',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        //บอกจำนวนวันและเวลาที่ใกล้จะมาถึงและยังมาไม่ถึง
        getDate(
            promotionModels[index].promotionStartDate.toString(),
            promotionModels[index].promotionFinishDate.toString(),
            promotionModels[index].promotionStartTime.toString(),
            promotionModels[index].promotionFinishTime.toString(),
            promotionModels[index].promotionId.toString()),

        //Show text Promotion start and end date :
        MyFont().textS17W500Black('Promotion start and end date :'),

        //Show date
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.date_range,
              color: Colors.black54,
            ),
            MyFont().textS17W400Black(
                '${promotionModels[index].promotionStartDate} - ${promotionModels[index].promotionFinishDate}'),
          ],
        ),

        //Show time
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.access_time,
              color: Colors.black54,
            ),
            MyFont().textS17W400Black(
                '${promotionModels[index].promotionStartTime} - ${promotionModels[index].promotionFinishTime}'),
          ],
        ),
        Divider(),

        Row(
          children: [
            MyFont().textS17W500Black('Promotion details :'),
          ],
        ),
        promotionModels[index].promotionDiscount != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyFont().textS17W400Black('Discount'),
                  MyFont().textS17W400Black(
                      '${promotionModels[index].promotionDiscount} %'),
                ],
              )
            : Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyFont().textS17W400Black('Normal price'),
                      MyFont().textS17W400Black(
                          '${promotionModels[index].promotionOldPrice}')
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyFont().textS17W400Black('Promotion price'),
                      MyFont().textS17W400Black(
                          '${promotionModels[index].promotionNewPrice}')
                    ],
                  )
                ],
              )
      ],
    );
  }
}
