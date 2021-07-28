import 'package:flutter/material.dart';
import 'package:card_settings/card_settings.dart';

class TestCard extends StatefulWidget {
  TestCard({Key? key}) : super(key: key);

  @override
  _TestCardState createState() => _TestCardState();
}

class _TestCardState extends State<TestCard> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? title = "Spheria";
  String? author = "Cody Leet";
  String? url = "http://www.codyleet.com/spheria";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Test"),),
      body: Form(
        key: _formKey,
        child: CardSettings(
          children: <CardSettingsSection>[
            CardSettingsSection(
              header: CardSettingsHeader(
                label: 'Favorite Book',
              ),
              children: <CardSettingsWidget>[
                 CardSettingsText(
                  label: 'Title',
               //   initialValue: title,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Title is required.';
                  },
                  onSaved: (value) => title = value,
                ),
                CardSettingsCheckboxPicker(
                  label: "category",
                   validator: (List<String>? value) {
                    if (value == null || value.isEmpty) return 'Title is required.';
                    return null;
                  },
                  onSaved: (value) => title = value.toString(),
                  options: [
                  'Animal','Tiger'
                ])
              ],)
          ],
        ),
      ),
    );
  }
}
