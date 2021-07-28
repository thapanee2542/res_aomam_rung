import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/screen/restaurant/reservation_page.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'home_page.dart';
import 'my_shop_page.dart';

class HomeRes2 extends StatefulWidget {
  HomeRes2({Key? key}) : super(key: key);

  @override
  _HomeRes2State createState() => _HomeRes2State();
}

class _HomeRes2State extends State<HomeRes2> {

  int currentPage = 1;
  GlobalKey bottomNavigationKey = GlobalKey();
  

  @override
  Widget build(BuildContext context) {
    var divheight = MediaQuery.of(context).size.height;
    return Scaffold(
      //appBar: appbar(divheight),
      body: body(),
      bottomNavigationBar: bottomNavigationBar(),
    );
  }

  FancyBottomNavigation bottomNavigationBar() {
    return FancyBottomNavigation(
      textColor: Colors.white,
      inactiveIconColor: Colors.white,
      activeIconColor: Colors.white,
      barBackgroundColor: Color(0xffF1B739),
      circleColor: Color(0xffFAE0A3),
      tabs: [
        TabData(
            iconData: Icons.restaurant_menu,
            title: "Management",
            onclick: () {}),
        TabData(iconData: Icons.home, title: "Home", onclick: () {}),
        TabData(iconData: Icons.list_alt, title: "Reservation", onclick: () {}),
      ],
      initialSelection: 1,
      key: bottomNavigationKey,
      onTabChangedListener: (position) {
        setState(() {
          currentPage = position;
        });
      },
    );
  }

  Container body() {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Center(
        child: _getPage(currentPage),
      ),
    );
  }

  AppBar appbar(double divheight) {
    return AppBar(
      title: Text(''),
      backgroundColor: Color(0xffF1B739),
      toolbarHeight: divheight / 9,
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.settings),
          tooltip: "Setting account",
        )
      ],
      leading: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: CircleAvatar(
          radius: 10.0,
          backgroundImage: AssetImage('assets/images/res_demo_1.jpg'),
          backgroundColor: Colors.transparent,
        ),
      ),
      leadingWidth: 80.0,
    );
  }

  _getPage(int page) {
    switch (page) {
      case 0:
        return MyShopPage();
      case 1:
        return HomePage();
      default:
        return ReservationPage();
    }
  }
}
