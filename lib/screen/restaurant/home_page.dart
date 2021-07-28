import 'package:flutter/material.dart';
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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Color(0xffF1B739),
            expandedHeight: 200,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                'assets/images/res_demo_1.jpg',
                fit: BoxFit.cover,
              ),
              title: Text(
                '$restaurantNameshop',
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
            actions: [
              Icon(Icons.settings),
              SizedBox(width: 12),
            ],
          ),
        ],
      ),
    );
  }
}
