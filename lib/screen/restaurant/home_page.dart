import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/screen/restaurant/show_overview_page.dart';
import 'package:flutter_rrs_app/screen/restaurant/show_profile_restaurant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? restaurantNameshop;

  @override
  void initState() {
    super.initState();
    findRestaurant();
  }

  Future<Null> findRestaurant() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      restaurantNameshop = preferences.getString('restaurantNameshop');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
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
                      'Management',
                      style: TextStyle(),
                    ),
                    //centerTitle: true,
                  ),
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: CircleAvatar(
                      radius: 10.0,
                      backgroundImage:
                          AssetImage('assets/images/res_demo_1.jpg'),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ),
                SliverPersistentHeader(
                  delegate: _SliverAppBarDelegate(
                    TabBar(
                      // indicator: BoxDecoration(color: Colors.white),
                      // indicatorSize: TabBarIndicatorSize.tab,
                      // indicator:
                      //     ShapeDecoration(
                      //       color: Colors.amber,
                      //       shape: RoundedRectangleBorder()),
                      labelColor: Colors.black87,
                      
                      
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Color(0xffF1B739),
                      tabs: [
                        Tab(text: "Overview"),
                        Tab(text: "Profile"),
                        
                      ],
                    ),
                  ),
                  pinned: true,
                ),
              ];
            },
            body: TabBarView(
              children: [ShowOverviewPage(), ShowProfileRes()],
            )),
      ),
    );
    
    // Scaffold(
    //   body: CustomScrollView(
        
    //     slivers: [
    //       SliverAppBar(
            
           
    //         backgroundColor: Color(0xffF1B739),
    //         expandedHeight: 200,
    //         floating: true,
    //         pinned: true,
    //         flexibleSpace: FlexibleSpaceBar(
    //           background: Image.asset(
    //             'assets/images/res_demo_1.jpg',
    //             fit: BoxFit.cover,
    //           ),
    //           title: Text(
    //             '$restaurantNameshop',
    //             style: TextStyle(),
    //           ),
    //           //centerTitle: true,
    //         ),
    //         leading: Padding(
    //           padding: const EdgeInsets.only(left: 10.0),
    //           child: CircleAvatar(
    //             radius: 10.0,
    //             backgroundImage: AssetImage('assets/images/res_demo_1.jpg'),
    //             backgroundColor: Colors.transparent,
    //           ),
    //         ),
    //         actions: [
    //           Icon(Icons.settings),
    //           SizedBox(width: 12),
    //         ],
    //       ),
      
    //     ],
    //   ),
    // );
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
      color: Color(0xffFFF5DD),
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
