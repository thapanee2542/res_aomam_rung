import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/screen/restaurant/add_address_on_map.dart';
import 'package:flutter_rrs_app/screen/restaurant/add_bank_account.dart';
import 'package:flutter_rrs_app/screen/restaurant/show_bank_account.dart';

class ShowOverviewPage extends StatefulWidget {
  ShowOverviewPage({Key? key}) : super(key: key);

  @override
  _ShowOverviwPageState createState() => _ShowOverviwPageState();
}

class _ShowOverviwPageState extends State<ShowOverviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Center(
              child: Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                    color: Color(0xffFFF5DD)),
                child: GridView.count(
                  padding: EdgeInsets.all(20.0),
                  crossAxisCount: 3,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  children: [
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            print('Add table');
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0xff797EF6)
                                    ,
                                blurRadius: 10.0,
                                offset: new Offset(0.0, 4.0),
                                   
                                   
                                   )
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 23,
                              backgroundColor: Color(0xff797EF6),
                              child: Icon(
                                Icons.chair,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Add table',
                          style:
                              TextStyle(fontSize: 13, color: Color(0xff818181)),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            print('Add food');
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0xff797EF6)
                                    ,
                                blurRadius: 10.0,
                                offset: new Offset(0.0, 4.0),
                                   
                                   
                                   )
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 23,
                              backgroundColor: Color(0xff797EF6),
                              child: Icon(
                                Icons.fastfood,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Add food',
                          style:
                              TextStyle(fontSize: 13, color: Color(0xff818181)),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            print('Add payment');
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>ShowBankAccount()));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0xff797EF6)
                                    ,
                                blurRadius: 10.0,
                                offset: new Offset(0.0, 4.0),
                                   
                                   
                                   )
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 23,
                              backgroundColor: Color(0xff797EF6),
                              child: Icon(
                                Icons.payment,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Payment',
                          style:
                              TextStyle(fontSize: 13, color: Color(0xff818181)),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            print('Location');
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>AddAddressMap()));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0xff797EF6)
                                    ,
                                blurRadius: 10.0,
                                offset: new Offset(0.0, 4.0),
                                   
                                   
                                   )
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 23,
                              backgroundColor: Color(0xff797EF6),
                              child: Icon(
                                Icons.location_on_sharp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Location',
                          style:
                              TextStyle(fontSize: 13, color: Color(0xff818181)),
                        )
                      ],
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
