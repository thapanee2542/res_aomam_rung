import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/model/order_food_model.dart';
import 'package:flutter_rrs_app/screen/restaurant/show_food_cancel_page.dart';
import 'package:flutter_rrs_app/screen/restaurant/show_proof_of_payment.dart';
import 'package:flutter_rrs_app/utility/my_constant.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:proste_dialog/proste_dialog.dart';

class ShowInfoFoodConfirm extends StatefulWidget {
  final OrderFoodModel? orderFoodModel;
  ShowInfoFoodConfirm({Key? key, this.orderFoodModel}) : super(key: key);

  @override
  _ShowInfoFoodConfirmState createState() => _ShowInfoFoodConfirmState();
}

class _ShowInfoFoodConfirmState extends State<ShowInfoFoodConfirm> {
  final formatCurrency = new NumberFormat("#,##0.00", "en_US");
  bool loadIndictor = false;
  bool ediStatus = false;
  OrderFoodModel? orderFoodModel;
  List<String> menufoods = [];
  List<String> prices = [];
  List<String> amounts = [];
  List<String> netPrices = [];
  List<List<String>> listMenufoods = [];
  List<List<String>> listPrices = [];
  List<List<String>> listAmounts = [];
  List<List<String>> listnetPrices = [];

  @override
  void initState() {
    super.initState();

    orderFoodModel = widget.orderFoodModel;
    print(orderFoodModel!.foodmenuName);
    print(orderFoodModel!.foodmenuPrice);
    print(orderFoodModel!.netPrice);
    print(orderFoodModel!.amount);
    print(orderFoodModel!.foodmenuId);
    if (orderFoodModel!.promotionId == null) {
      orderFoodModel!.promotionDiscount = '0';
    }
    menufoods = changeArray(orderFoodModel!.foodmenuName!);
    prices = changeArray(orderFoodModel!.foodmenuPrice!);
    amounts = changeArray(orderFoodModel!.amount!);
    netPrices = changeArray(orderFoodModel!.netPrice!);

    listMenufoods.add(menufoods);
    listAmounts.add(amounts);
    listnetPrices.add(netPrices);
    listPrices.add(prices);
    print('listMenufoods == $listMenufoods');
  }

  // ฟังก์ชั่นใส่format ราคาอาหาร
  List<String> formatPrice() {
    List<String> netPricesFormat = [];
    for (int index = 0; index < netPrices.length; index++) {
      int price = int.parse(netPrices[index]);
      String priceFormat = formatCurrency.format(price);
      netPricesFormat.add(priceFormat);
    }
    return netPricesFormat;
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

  // ฟังก์ชันหาราคาส่วนลด
  double discountAmount(int discount, int totalPrice) {
    double discountAmount = totalPrice * (discount / 100);
    return discountAmount;
  }

  //  ฟังก์ชันราคารวมทั้งหมดหลังหักส่วนลด
  double totalPriceAfterDiscount(int totalPrice, int discount) {
    double afterDiscount = totalPrice - (totalPrice * (discount / 100));
    return afterDiscount;
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
    return Stack(children: [
      Scaffold(
          appBar: AppBar(
            title: Text('Booking details'),
            backgroundColor: Color(0xffF1B739),
            leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back_ios_new_rounded)),
          ),
          bottomNavigationBar: positionButton(context),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Order food No.',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        '${orderFoodModel!.id}',
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '${orderFoodModel!.orderfoodDateTime}',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: (Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/images/user.png',
                          width: 45,
                          height: 45,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${orderFoodModel!.name}',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Text('${orderFoodModel!.phonenumber}')
                            ],
                          ),
                        ),
                      ],
                    )),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: (Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/images/restaurant_icon2.png',
                          width: 45,
                          height: 45,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${orderFoodModel!.restaurantNameshop}',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                  'Restaurant No. ${orderFoodModel!.restaurantId}')
                            ],
                          ),
                        ),
                      ],
                    )),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              'assets/images/list_icon.png',
                              width: 20,
                              height: 20,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Food list summary',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        Divider(),
                        ListView.separated(
                            separatorBuilder: (context, index) {
                              return Divider();
                            },
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            itemCount: menufoods.length,
                            itemBuilder: (context, index) {
                              return Row(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${amounts[index]}x',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
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
                                              fontSize: 15))),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(formatPrice()[index],
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15)),
                                    ],
                                  ),
                                ],
                              );
                            }),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total food price',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            Text(
                                '${formatCurrency.format(totalPrice()).toString()} ₭',
                                style: TextStyle(fontSize: 15))
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Discount',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            Text('${orderFoodModel!.promotionDiscount} %',
                                style: TextStyle(
                                  fontSize: 15,
                                ))
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Discount amount',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            Text(
                                '${formatCurrency.format(discountAmount(int.parse(orderFoodModel!.promotionDiscount.toString()), totalPrice()))} ₭',
                                style: TextStyle(
                                  fontSize: 15,
                                ))
                          ],
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            Text(
                                '${formatCurrency.format(totalPriceAfterDiscount(totalPrice(), int.parse(orderFoodModel!.promotionDiscount.toString()))).toString()} ₭',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  'assets/images/bill_icon.png',
                                  width: 25,
                                  height: 25,
                                ),
                                SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Payment',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                              ],
                            ),
                            
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(double.infinity,0),
                                primary: Colors.blue
                              ),
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                      ShowProofOfPayment(urlImage: orderFoodModel!.picture,)
                                  ));
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      'Proof of payment',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    Icon(Icons.arrow_forward_ios_rounded,size: 15,)
                                  ],
                                ),
                                
                                )
                          ],
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Payment date',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            Text(
                                '${orderFoodModel!.paymentDate}',
                                style: TextStyle(
                                  fontSize: 15,
                                ))
                          ],
                        ),
                         Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Payment time',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            Text(
                                '${orderFoodModel!.paymentTime.toString().substring(10,15)}',
                                style: TextStyle(
                                  fontSize: 15,
                                ))
                          ],
                        ),



                      ],
                    ),
                  ),
                )
              ],
            ),
          )),
      loadIndictor == true
          ? Stack(children: [
              Opacity(
                opacity: 0.5,
                child:
                    const ModalBarrier(dismissible: false, color: Colors.black),
              ),
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  child: LoadingIndicator(
                      indicatorType: Indicator.ballClipRotatePulse,
                      colors: const [
                        Colors.amberAccent,
                        Colors.orange,
                        Colors.lightGreen
                      ],
                      strokeWidth: 5,
                      backgroundColor: Colors.transparent,
                      pathBackgroundColor: Colors.transparent),
                ),
              )
            ])
          : Container(),
    ]);
  }

  Container positionButton(BuildContext context) {
    return Container(
      height: 60,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.transparent,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 30.0,
            offset: new Offset(10.0, 10.0),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: buttonCancelOrder()),
              // Padding(
              //     padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              //     child: buttonEditOrder()),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: buttonConfirmOder(context)),
            ],
          ),
        ],
      ),
    );
  }

  ElevatedButton buttonConfirmOder(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.green,
        onPrimary: Colors.white,
        shadowColor: Colors.greenAccent,
        elevation: 3,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        minimumSize:
            Size(MediaQuery.of(context).size.width / 2.5, 40), //////// HERE
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) => ProsteDialog(
            // duration: Duration(seconds: 5),
            type: DialogTipType.success,
            content: Text(
                'Are you sure to completed order food No. ${orderFoodModel!.id}'),
            insetPadding: EdgeInsets.all(15),
            dialogRadius: 10,
            title: Text(
              'Please Confirm',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            titlePadding: EdgeInsets.only(top: 20),
            contentPadding: EdgeInsets.all(15),
            confirmButtonText:
                Text('Yes', style: TextStyle(color: Colors.white)),
            cancelButtonText: Text('No', style: TextStyle(color: Colors.white)),
            showConfirmButton: true,
            showCancelButton: true,
            confirmButtonColor: Colors.green,
            cancelButtonColor: Colors.red,
            onConfirm: () {
              setState(() {
                loadIndictor = true;
                Navigator.pop(context);
              });
              print('preinstall confirm pressed');
              editStatus('completed');
            },
            onCancel: () {
              print('preinstall cancel pressed');
              Navigator.pop(context);
            },
          ),
        );
      },
      child: Text(
        'Completed',
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  // //เเสดงรายละเอียดเมนูอาหารที่สั่ง
// //listviewอยู่ในlistview
  ListView buildListViewMenuFood(int index) => ListView.builder(
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemCount: menufoods.length,
      itemBuilder: (context, index2) => Row(
            children: [
              Expanded(flex: 3, child: Text(listMenufoods[index][index2])),
              Expanded(flex: 1, child: Text(listAmounts[index][index2])),
              // Expanded(flex: 1, child: Text(listPrices[index][index2])),
              Expanded(flex: 1, child: Text(listnetPrices[index][index2]))
            ],
          ));

  ElevatedButton buttonCancelOrder() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.red,
        onPrimary: Colors.white,
        shadowColor: Colors.redAccent,
        elevation: 3,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        minimumSize:
            Size(MediaQuery.of(context).size.width / 2.5, 40), //////// HERE
      ),
      onPressed: () {
        showModalBottomSheet(
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
            context: context,
            builder: (BuildContext context) => ShowFoodCancelPage(
                  orderFoodModel: orderFoodModel,
                ));
      },
      child: Text(
        'Cancel order',
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  Future<Null> editStatus(String status) async {
    String id = orderFoodModel!.id.toString();
    String orderfoodStatus = status;

    var url =
        '${Myconstant().domain}/res_reserve/edit_status_orderfood_where_id.php?id=$id&isAdd=true&orderfoodStatus=$orderfoodStatus';

    await Dio().get(url).then((value) {
      if (value.toString() == 'true') {
        setState(() {
          loadIndictor = false;
        });
        showDialog(
          context: context,
          builder: (_) => ProsteDialog(
            duration: Duration(seconds: 3),
            type: DialogTipType.success,
            content: Text(''),
            insetPadding: EdgeInsets.all(15),
            dialogRadius: 10,
            title: Text(
              'Order completed',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            titlePadding: EdgeInsets.only(top: 20),
            contentPadding: EdgeInsets.all(15),
            confirmButtonText:
                Text('Yes', style: TextStyle(color: Colors.white)),
            cancelButtonText: Text('No', style: TextStyle(color: Colors.white)),
            showConfirmButton: true,
            showCancelButton: true,
            confirmButtonColor: Colors.green,
            cancelButtonColor: Colors.red,
            onConfirm: () {
              setState(() {
                loadIndictor = true;
              });
              print('preinstall confirm pressed');
              editStatus('confirm');
            },
            onCancel: () {
              print('preinstall cancel pressed');
              Navigator.pop(context);
            },
          ),
        ).then((value) {
          Navigator.pop(context);
        });
      }
    });
  }
}
