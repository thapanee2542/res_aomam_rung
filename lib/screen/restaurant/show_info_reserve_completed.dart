import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/model/reservation_model.dart';
import 'package:flutter_rrs_app/model/reserve_details_model.dart';
import 'package:flutter_rrs_app/model/user_model.dart';
import 'package:flutter_rrs_app/screen/restaurant/show_reserve_cancel_page.dart';
import 'package:flutter_rrs_app/utility/my_constant.dart';
import 'package:flutter_rrs_app/utility/normal_dialog.dart';
import 'dart:math' as math;

class ShowInfoCompleted extends StatefulWidget {
  final ReserveDetailsModel? reserveDetailsModel;

  ShowInfoCompleted({Key? key, this.reserveDetailsModel}) : super(key: key);

  @override
  _ShowInfoCompletedState createState() => _ShowInfoCompletedState();
}

class _ShowInfoCompletedState extends State<ShowInfoCompleted> {
  ReserveDetailsModel? reserveDetailsModel;
   List<String> menufoods = [];
  List<String> prices = [];
  List<String> amounts = [];
  List<String> netPrices = [];
  String? reservationTime;
  int _value = 0;
PersistentBottomSheetController? _controller; // <------ Instance variable
final _scaffoldKey = GlobalKey<ScaffoldState>(); // <---- Another instance variable
  @override
  void initState() {
    super.initState();

    reserveDetailsModel = widget.reserveDetailsModel;
    if (reserveDetailsModel!.orderfoodId.toString() != '0') {
      menufoods = changeArray(reserveDetailsModel!.foodmenuName!);
    prices = changeArray(reserveDetailsModel!.foodmenuPrice!);
    amounts = changeArray(reserveDetailsModel!.amount!);
    netPrices = changeArray(reserveDetailsModel!.netPrice!);
    }
    
    reservationTime =
        reserveDetailsModel!.reservationTime.toString().substring(10, 15);
  }

  // ฟังก์ชันหาราคารวมของอาหาร ยังไม่หักลบจากส่วนลดต่างๆ
  int totalPrice() {
    int totalPrice = 0;
    for (int index = 0; index < netPrices.length; index++) {
      int price = int.parse(netPrices[index]);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking details'),
        backgroundColor: Color(0xffF1B739),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Stack(children: [
          Container(
            // width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10.0,
                    offset: new Offset(0.0, 10.0),
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Icon(Icons.history,color: Colors.green,size: 40,),
                      ),
                      Center(child: Text('Completed',style: TextStyle(fontSize: 16,color: Colors.green,fontWeight: FontWeight.bold),)),
                      Center(
                          child: Text(
                        'Reservation No. ${reserveDetailsModel!.reservationId}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      )),
                      Center(
                          child: Text(
                        'Restaurant No. ${reserveDetailsModel!.restaurantId}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      )),
                      Divider(
                        color: Colors.grey,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.contacts,
                            size: 20,
                            color: Colors.blueGrey[800],
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Customer Detail',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.blueGrey[800]),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Name',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text('${reserveDetailsModel!.name}'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Phone number',
                              style: TextStyle(color: Colors.grey)),
                          Text('${reserveDetailsModel!.phonenumber}'),
                        ],
                      ),
                      Divider(),
                      Row(
                        children: [
                          Icon(
                            Icons.book,
                            size: 20,
                            color: Colors.blueGrey[800],
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Booking Detail',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.blueGrey[800]),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Date', style: TextStyle(color: Colors.grey)),
                          Text('${reserveDetailsModel!.reservationDate}'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Time', style: TextStyle(color: Colors.grey)),
                          Text('$reservationTime'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Number of guest',
                              style: TextStyle(color: Colors.grey)),
                          Text('${reserveDetailsModel!.numberOfGueste}'),
                        ],
                      ),
                      Divider(),
                      Row(
                        children: [
                          Icon(
                            Icons.chair,
                            size: 20,
                            color: Colors.blueGrey[800],
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Table Detail',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.blueGrey[800]),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width*0.7 ,
                          height: MediaQuery.of(context).size.height /6,
                          child: Image.network(
                            '${Myconstant().domain}${reserveDetailsModel!.tablePicOne}',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Table Name',
                              style: TextStyle(color: Colors.grey)),
                          Text('${reserveDetailsModel!.tableName}'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Table number',
                              style: TextStyle(color: Colors.grey)),
                          Text('${reserveDetailsModel!.tableResId}'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Number of seats',
                              style: TextStyle(color: Colors.grey)),
                          Text('${reserveDetailsModel!.tableNumseat}'),
                          
                        ],
                      ),
                       reserveDetailsModel!.orderfoodId.toString() == '0'? Text(""):
                      Column(
                        children: [
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.dining,
                                    size: 20,
                                    color: Colors.blueGrey[800],
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'Food Detail',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.blueGrey[800]),
                                  ),
                                ],
                              ),
                              Text(
                                'Order food No. ${reserveDetailsModel!.orderfoodId}',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black54),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ListView.builder(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              itemCount: menufoods.length,
                              itemBuilder: (context, index) {
                                return Row(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${amounts[index]}x',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        flex: 5,
                                        child: Text(menufoods[index],
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 13))),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(netPrices[index],
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 13)),
                                      ],
                                    ),
                                  ],
                                );
                              }),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              Text('${totalPrice().toString()}',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold))
                            ],
                          )
                        ],
                      ),
                       
                    ],
                  ),
                )),
          ),
          
        ]),
      ),
    );
  }

 
  ElevatedButton buttonCancelOrder() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.red,
        onPrimary: Colors.white,
        shadowColor: Colors.redAccent,
        elevation: 3,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
        minimumSize: Size(300, 40), //////// HERE
      ),
      onPressed: () {
        showModalBottomSheet(
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
            context: context,
            builder: (BuildContext context) => ShowCancelPage(reserveDetailsModel: reserveDetailsModel,));
      },
      child: Text(
        'Cancel order',
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  ElevatedButton buttonComplete(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.green,
        onPrimary: Colors.white,
        shadowColor: Colors.greenAccent,
        elevation: 3,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
        minimumSize: Size(300, 40), //////// HERE
      ),
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Please Confirm'),
                content: Text(
                    'Are you sure to completed order reservation No. ${reserveDetailsModel!.reservationId}'),
                actions: [
                  // The "No" button
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('No', style: TextStyle(color: Colors.blue)),
                  ),
                  // The "Yes" button
                  TextButton(
                    onPressed: () {
                      editStatus('completed');
                    },
                    child: Text(
                      'Yes',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              );
            });
      },
      child: Text(
        'Completed',
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  

  

  Future<Null> editStatus(String status) async {
    String reservationId = reserveDetailsModel!.reservationId.toString();
    String reservationStatus = status;

    var url =
        '${Myconstant().domain}/res_reserve/edit_status_reservation_where_reservationId.php?reservationId=$reservationId&isAdd=true&reservationStatus=$reservationStatus';

    await Dio().get(url).then((value) {
      if (value.toString() == 'true') {
        Navigator.pop(context);
        Navigator.pop(context);
      }
    });
  }
}
