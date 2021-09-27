import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/model/order_food_model.dart';
import 'package:flutter_rrs_app/screen/restaurant/show_proof_of_payment.dart';
import 'package:intl/intl.dart';

class ShowInfoFoodCancel extends StatefulWidget {
  final OrderFoodModel? orderFoodModel;
  ShowInfoFoodCancel({Key? key, this.orderFoodModel}) : super(key: key);

  @override
  _ShowInfoFoodCancelState createState() => _ShowInfoFoodCancelState();
}

class _ShowInfoFoodCancelState extends State<ShowInfoFoodCancel> {
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
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: (Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/images/cancelorder_icon.png',
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
                                'Order canceled',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Text('${orderFoodModel!.orderfoodReasonCancelStatus}')
                            ],
                          ),
                        ),
                      ],
                    )),
                  ),
                ),
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
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  fixedSize: Size(double.infinity, 0),
                                  primary: Colors.blue),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ShowProofOfPayment(
                                              urlImage: orderFoodModel!.picture,
                                            )));
                              },
                              child: Row(
                                children: [
                                  Text(
                                    'Proof of payment',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 15,
                                  )
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
                            Text('${orderFoodModel!.paymentDate}',
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
                                '${orderFoodModel!.paymentTime.toString().substring(10, 15)}',
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
    ]);
  }
}
