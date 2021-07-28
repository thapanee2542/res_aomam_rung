import 'package:flutter/material.dart';

class ShopOwner extends StatefulWidget {
  const ShopOwner({Key? key}) : super(key: key);

  @override
  _ShopOwnerState createState() => _ShopOwnerState();
}

class _ShopOwnerState extends State<ShopOwner> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [Text("ShopOwner")],
      ),
    );
  }
}
