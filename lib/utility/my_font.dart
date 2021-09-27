import 'package:flutter/material.dart';

class MyFont {


  Text textBeforeTextfield(String text)=>Text(
      text,
      style: TextStyle(
          fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
    );

  Text textS17W400Black(String text) =>Text(
    text, 
    style: TextStyle(fontSize: 17,fontWeight: FontWeight.w400,color: Colors.blueGrey)
    ,
  );

  Text textS17W500Black(String text) =>Text(
    text, 
    style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500,color: Colors.brown),
  );

    
  
}
