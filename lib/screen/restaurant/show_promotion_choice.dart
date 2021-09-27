import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/screen/restaurant/add_pro_alldiscount.dart';
import 'package:flutter_rrs_app/screen/restaurant/add_pro_buy1get1.dart';
import 'package:flutter_rrs_app/screen/restaurant/add_pro_foodmenu_reduction.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class ShowPromotionChoice extends StatefulWidget {
  ShowPromotionChoice({Key? key}) : super(key: key);

  @override
  _ShowPromotionChoiceState createState() => _ShowPromotionChoiceState();
}

class _ShowPromotionChoiceState extends State<ShowPromotionChoice> {
  bool isActiveCreate = false;
  bool isActiveList = false;
  bool isActiveHistory = false;
  bool isActiveSearch = false;

  @override
  void initState() {
    super.initState();
    isActiveSearch = false;
    isActiveHistory = false;
    isActiveCreate = false;
    isActiveList = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: speedDialMenu(context),
      body: GridView.count(
        padding: EdgeInsets.all(20.0),
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        children: [
          Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(30),
            color: isActiveCreate == false ? Colors.white : Color(0xffF1B739),
            child: InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return showDialogCreatePromtion();
                    });
                print('Create promotion');
                setState(() {
                  isActiveCreate = true;
                  isActiveSearch = false;
                  isActiveHistory = false;
                  isActiveList = false;
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.create,
                    size: 50,
                    color: isActiveCreate == false
                        ? Color(0xffF1B739)
                        : Colors.white,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Create promotion',
                    style: TextStyle(
                        fontSize: 16,
                        color: isActiveCreate == false
                            ? Colors.grey
                            : Colors.white),
                  )
                ],
              ),
            ),
          ),
          Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(30),
            color: isActiveList == false ? Colors.white : Color(0xffF1B739),
            child: InkWell(
              onTap: () {
                print('Active promotion');
                setState(() {
                  isActiveList = true;
                  isActiveCreate = false;
                  isActiveSearch = false;
                  isActiveHistory = false;
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.list,
                    size: 50,
                    color: isActiveList == false
                        ? Color(0xffF1B739)
                        : Colors.white,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Active promotion',
                    style: TextStyle(
                        fontSize: 16,
                        color:
                            isActiveList == false ? Colors.grey : Colors.white),
                  )
                ],
              ),
            ),
          ),
          Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(30),
            color: isActiveHistory == false ? Colors.white : Color(0xffF1B739),
            child: InkWell(
              onTap: () {
                print('Promotion history');
                setState(() {
                  isActiveHistory = true;
                  isActiveCreate = false;
                  isActiveSearch = false;

                  isActiveList = false;
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 50,
                    color: isActiveHistory == false
                        ? Color(0xffF1B739)
                        : Colors.white,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Promotion history',
                    style: TextStyle(
                        fontSize: 16,
                        color: isActiveHistory == false
                            ? Colors.grey
                            : Colors.white),
                  )
                ],
              ),
            ),
          ),
          Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(30),
            color: isActiveSearch == false ? Colors.white : Color(0xffF1B739),
            child: InkWell(
              onTap: () {
                print('Search promotion');
                setState(() {
                  isActiveSearch = true;
                  isActiveHistory = false;
                  isActiveCreate = false;

                  isActiveList = false;
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search,
                    size: 50,
                    color: isActiveSearch == false
                        ? Color(0xffF1B739)
                        : Colors.white,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Search promotion',
                    style: TextStyle(
                        fontSize: 16,
                        color: isActiveSearch == false
                            ? Colors.grey
                            : Colors.white),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Dialog showDialogCreatePromtion() => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                  left: Constants.padding,
                  top: Constants.avatarRadius,
                  right: Constants.padding,
                  bottom: Constants.padding),
              margin: EdgeInsets.only(top: Constants.avatarRadius),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(Constants.padding),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black,
                        offset: Offset(0, 10),
                        blurRadius: 10),
                  ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Select promotion type",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  Divider(),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddProAllDiscount())).then((value) => Navigator.pop(context))
                          ;
                    },
                    child: Container(
                      width: 200,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Discount for all(%)'),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16,
                          )
                        ],
                      ),
                    ),
                    style: ElevatedButton.styleFrom(primary: Colors.grey),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddProFoodMenuReduction()));
                    },
                    child: Container(
                      width: 200,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Discount food menu'),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16,
                          )
                        ],
                      ),
                    ),
                    style: ElevatedButton.styleFrom(primary: Colors.grey),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddProBuyOneGetOne()));
                    },
                    child: Container(
                      width: 200,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Buy 1 get 1 free'),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16,
                          )
                        ],
                      ),
                    ),
                    style: ElevatedButton.styleFrom(primary: Colors.grey),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            Positioned(
                left: Constants.padding,
                right: Constants.padding,
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: Constants.avatarRadius,
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(
                          Radius.circular(Constants.avatarRadius)),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.amber,
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      )),
                ))
          ],
        ),
      );

  SpeedDial speedDialMenu(BuildContext context) {
    return SpeedDial(
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
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddProBuyOneGetOne()));
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
                    builder: (context) => AddProFoodMenuReduction()));
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
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddProAllDiscount()));
          },
        )
      ],
    );
  }
}

class Constants {
  Constants._();
  static const double padding = 10;
  static const double avatarRadius = 45;
}
