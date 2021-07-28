import 'package:flutter/material.dart';

class PastBookings extends StatefulWidget {
  const PastBookings({Key? key}) : super(key: key);

  @override
  _PastBookingsState createState() => _PastBookingsState();
}

class _PastBookingsState extends State<PastBookings> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Icon(Icons.book_online),
    );
  }
}
