import 'package:flutter/material.dart';


class ReservationPage extends StatefulWidget {
  ReservationPage({Key? key}) : super(key: key);

  @override
  _MyShopPageState createState() => _MyShopPageState();
}

class _MyShopPageState extends State<ReservationPage> {
  @override
  Widget build(BuildContext context) {
    var divheight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: DefaultTabController(
        length: 6,
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
                'Reservation',
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
                      Tab( text: "all"),
                      Tab( text: "new"),
                      Tab(text: "confirm",),
                      Tab(text: "unconfirmed",),
                      Tab(text: "refuse",),
                      Tab(text: "cancel",),
                    ],
                  ),
                ),
                pinned: true,
              ),
            ];
          },
        body: Center(
            child: Text("Sample text"),
          ),
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
