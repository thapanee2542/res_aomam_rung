import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/screen/restaurant/show_food_status_cancel.dart';
import 'package:flutter_rrs_app/screen/restaurant/show_food_status_completed.dart';
import 'package:flutter_rrs_app/screen/restaurant/show_food_status_confirm.dart';
import 'package:flutter_rrs_app/screen/restaurant/show_food_status_unconfirm.dart';
import 'package:flutter_rrs_app/screen/restaurant/show_table_status_cancel.dart';
import 'package:flutter_rrs_app/screen/restaurant/show_table_status_completed.dart';
import 'package:flutter_rrs_app/screen/restaurant/show_table_status_confirm.dart';
import 'package:flutter_rrs_app/screen/restaurant/show_table_status_unconfirm.dart';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';


class ReservationPage extends StatefulWidget {
  ReservationPage({Key? key}) : super(key: key);

  @override
  _MyShopPageState createState() => _MyShopPageState();
}

class _MyShopPageState extends State<ReservationPage> {


bool orderFoodPage = false;
bool reserveTablePage = true;



  @override
  Widget build(BuildContext context) {
    var divheight = MediaQuery.of(context).size.height;
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 25),
        child: SpeedDial(
          icon: orderFoodPage ?   Icons.dining:Icons.chair,
          // animatedIcon: AnimatedIcons.menu_close,
          backgroundColor: Color(0xff1CA7EA),
          children: [
           orderFoodPage ? SpeedDialChild() : SpeedDialChild(
              child: Icon(
                Icons.dining,
                color: Colors.white,
              ),
              label: 'Order food',
              backgroundColor: Color(0xff9DA3B3),
              onTap: () {
              setState(() {
               if (reserveTablePage == true) {
                  reserveTablePage = false;
                  orderFoodPage = true;
               }else{
                 orderFoodPage = true;
               }
              });
              },
            ),
            reserveTablePage ? SpeedDialChild() : SpeedDialChild(
              child: Icon(
                Icons.chair,
                color: Colors.white,
              ),
              label: 'Reserve a table and order food',
              onTap: () {
                setState(() {
               if (orderFoodPage == true) {
                  orderFoodPage = false;
                  reserveTablePage = true;
               }else{
                 reserveTablePage = true;
               }
              });
              },
              backgroundColor: Color(0xff9DA3B3),
            ),
            
           
          ],
        ),
      ),
      body: DefaultTabController(
        length: 4,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                backgroundColor: Color(0xffF1B739),
                expandedHeight: 200.0,
                floating: false,
                pinned: true,
              flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                'assets/images/res_demo_1.jpg',
                fit: BoxFit.cover,
              ),
              title: Text(
               reserveTablePage ? 'Reserve a table':'Order food',
                style: TextStyle(),
              ),
              //centerTitle: true,
            ),
            leading: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: CircleAvatar(
                radius: 10.0,
                backgroundImage: AssetImage('assets/images/res_demo_1.jpg'),
                backgroundColor: Colors.transparent,
              ),
            ),
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    isScrollable: true,
                    labelColor: Colors.black87,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Color(0xffF1B739),
                    tabs: [
                     
                       Tab(text: "unconfirmed",),
                      Tab(text: "confirm",),
                      Tab(text: "cancel",),
                      Tab(text: "completed",),
                    ],
                  ),
                ),
                pinned: true,
              ),
            ];
          },
        body:orderFoodPage? 
        TabBarView(
          
          children: [
            
          ShowFoodUnconfirm(),
          ShowFoodConfirm(),
            ShowFoodCancel(),
            ShowFoodCompleted(),
           




        ],)
        
        :TabBarView(
          
          children: [
            
            ShowUnconfirm(),
            ShowConfirm(),
            ShowCancel(),
            ShowCompleted(),
           




        ],)
        
      
       
        ),
      ),
    );
  }
  }

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
