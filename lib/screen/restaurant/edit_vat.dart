import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/model/restaurant_model.dart';
import 'dart:math' as math;

import 'package:flutter_rrs_app/utility/my_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditVat extends StatefulWidget {
  final RestaurantModel? restaurantModel;
  EditVat({Key? key, this.restaurantModel}) : super(key: key);

  @override
  _EditVatState createState() => _EditVatState();
}

class _EditVatState extends State<EditVat> {
  TextEditingController _controller = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  String? vat;
   bool loadSubmit = false;
  
  RestaurantModel? restaurantModel;
 
  @override
  void initState() {
    super.initState();
   
    restaurantModel = widget.restaurantModel;
    _controller.text = restaurantModel!.vat.toString();

    print(restaurantModel!.name);
  }

  @override
  Widget build(BuildContext context) {
    
    return Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
        child: FractionallySizedBox(
          heightFactor: 0.5,
          child: Column(
             mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Transform.rotate(
                angle: 90 * math.pi / 180,
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey,
                  size: 18,
                ),
              ),
            )),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Edit VAT',style: TextStyle(fontSize: 20),),
              ],
            ),
            SizedBox(height: 10,),
             Form(
              key: _formkey,
                child: TextFormField(
                
              controller: _controller,
              onSaved: (value) => vat = value,
              onChanged: (value) {
                setState(() {
                  vat = value;
                });
              },
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty)
                  return 'Please enter vat';
                return null;
              },
              decoration: InputDecoration(
                suffixText: '%',
                suffixStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border: OutlineInputBorder()),
            )),
            SizedBox(
              height: 10,
            ),
            Container(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  if (_formkey.currentState!.validate()) {
                    setState(() {
                      loadSubmit = true;
                    });
                    editVat(vat);
                    
                 
                  }
                },
                child: loadSubmit ? Container(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator()):
                Text(
                  'Submit',
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xffF1B739),
                ),
              ),
            )


          ],),
        ));
      
  }

    Future<Null> editVat(String? vat) async {
     SharedPreferences preferences = await SharedPreferences.getInstance();
    String? restaurantId = preferences.getString('restaurantId');

    var url =
        '${Myconstant().domain}/res_reserve/edit_vat_where_resraurantId.php?vat=$vat&isAdd=true&restaurantId=$restaurantId';

    await Dio().get(url).then((value) {
      if (value.toString() == 'true') {
        Navigator.pop(context);
        
      }
    });
  }
}
