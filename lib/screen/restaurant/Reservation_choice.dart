import 'package:flutter/material.dart';

class ReservationChoice extends StatefulWidget {
  ReservationChoice({Key? key}) : super(key: key);

  @override
  _ReservationChoiceState createState() => _ReservationChoiceState();
}

class _ReservationChoiceState extends State<ReservationChoice> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: GridView.count(
        padding: EdgeInsets.all(20.0),
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        children: [
          Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(30),
            color: Color(0xffF1B739),
            child: InkWell(
              onTap: () {
                
                print('Create promotion');
                
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.create,
                    size: 50,
                    color: Colors.white,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Create promotion',
                    style: TextStyle(
                        fontSize: 16,
                        color:  Colors.grey
                            ),
                  )
                ],
              ),
            ),
          ),
          Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(30),
            color: Color(0xffF1B739),
            child: InkWell(
              onTap: () {
                print('Active promotion');
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.list,
                    size: 50,
                    color:  Colors.white,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Active promotion',
                    style: TextStyle(
                        fontSize: 16,
                        color:
                           Colors.grey),
                  )
                ],
              ),
            ),
          ),
          
         
        ],
      ),
    );
  }
}
