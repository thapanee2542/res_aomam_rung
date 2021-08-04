import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:math' as math;

class AddPromotion extends StatefulWidget {
  AddPromotion({Key? key}) : super(key: key);

  @override
  _AddMenuState createState() => _AddMenuState();
}

class _AddMenuState extends State<AddPromotion> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController dateCtl = TextEditingController();

  TextEditingController _controller = TextEditingController();

  var currentSelectedValue;
  @override
  void initState() {
    super.initState();
    _controller.text = "0"; // Setting the initial value for the field.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xffF1B739),
          title: Text('Add promotion'),
        ),
        body: Container(
          padding: EdgeInsets.all(30),
          child: Form(
              key: _formkey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Promotion type",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    typeFieldWidget(),

                    SizedBox(
                      height: 25,
                    ),
                    Text(
                      "Discount (%)",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    formDiscount(),
                    SizedBox(
                      height: 25,
                    ),
                    Text(
                      "Start date",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    formStartDate(),
                    SizedBox(
                      height: 25,
                    ),
                    Text(
                      "Food description",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    //  formFoodDescription(),
                    SizedBox(
                      height: 25,
                    ),
                    //    saveButton(),
                  ],
                ),
              )),
        ));
  }

  Widget typeFieldWidget() {
    const orderTypes = ["Reserve a table", "Order food"];
    return FormField<String>(
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10), border: OutlineInputBorder()),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              hint: Text("Select type promotion"),
              value: currentSelectedValue,
              isDense: true,
              onChanged: (newValue) {
                setState(() {
                  currentSelectedValue = newValue;
                });
                print(currentSelectedValue);
              },
              items: orderTypes.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget formDiscount() {
    return TextFormField(
      readOnly: true,
      initialValue: _controller.text,
      controller: _controller,
      inputFormatters: [FilteringTextInputFormatter.deny((RegExp(r'[/\\]')),)],
      textAlign: TextAlign.center,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Discount is required.';
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      // onSaved: (value) => tableNumseat = value,
      // onChanged: (value) {
      //   setState(() {
      //     tableNumseat = value;
      //   });
      // },
      keyboardType:
          TextInputType.numberWithOptions(decimal: false, signed: false),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10),
          border: OutlineInputBorder(),
          prefixIcon: IconButton(
            icon: Icon(
              Icons.arrow_drop_down_circle_rounded,
              size: 30,
            ),
            onPressed: () {
              int currentValue = int.parse(_controller.text);
              setState(() {
                currentValue--;
                _controller.text =
                    (currentValue > 0 ? currentValue : 0).toString();
              });
            },
          ),
          suffixIcon: Transform.rotate(
            angle: 180 * math.pi / 180,
            child: IconButton(
              icon: Icon(
                Icons.arrow_drop_down_circle_rounded,
                size: 30,
              ),
              onPressed: () {
                int currentValue = int.parse(_controller.text);
                setState(() {
                  currentValue++;
                  _controller.text = (currentValue).toString();
                });
              },
            ),
          )),
    );
  }

  Widget formStartDate() {
    return TextFormField(
      controller: dateCtl,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(10), border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.calendar_today),
        //labelText: "Date of birth",
        // hintText: "Ex. Insert your dob",
      ),
      onTap: () async {
        DateTime date = DateTime(1900);
        FocusScope.of(context).requestFocus(new FocusNode());

        date = (await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100)))!;

        dateCtl.text = DateFormat('yyyy-MM-dd').format(date);
        print('date = $date');
      },
    );
  }
}
