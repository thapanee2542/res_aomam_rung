import 'package:flutter/material.dart';

import 'add_promotion.dart';

class ShowPromotion extends StatefulWidget {
  ShowPromotion({Key? key}) : super(key: key);

  @override
  _ShowTableState createState() => _ShowTableState();
}

class _ShowTableState extends State<ShowPromotion> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  backgroundColor: Color(0xff1CA7EA),
                  child: Icon(Icons.add),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder:(context)=>AddPromotion()));
                  }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
