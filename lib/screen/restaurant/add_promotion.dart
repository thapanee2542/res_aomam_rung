import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class AddPromotion extends StatefulWidget {
  AddPromotion({Key? key}) : super(key: key);

  @override
  _AddMenuState createState() => _AddMenuState();
}

class _AddMenuState extends State<AddPromotion> {
  File? file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
          backgroundColor: Color(0xffF1B739),
          title: Text('Add promotion'),
        ),
        
      
    );
  }
}