import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/model/tableres_model.dart';


class EditTable extends StatefulWidget {
  
  final TableResModel? tableResModel;
  EditTable({Key? key, this.tableResModel}):super(key: key);


  @override
  _EditTableState createState() => _EditTableState();
}

class _EditTableState extends State<EditTable> {
  
 final _formkey = GlobalKey<FormState>();
 TableResModel? tableResModel;

 @override
  void initState() {
    // รับค่าจากตัวแปรเข้ามา
    super.initState();
    tableResModel = widget.tableResModel;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit table ${tableResModel?.tableResId} ${tableResModel?.tableName}'),),
      body: Container(
          padding: EdgeInsets.all(30),
          child: Form(
              key: _formkey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Table name",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    formTableName(),
                   
                  ],
                ),
              )),
        )
    );
  }

  Widget formTableName() => TextFormField(
      //  textAlignVertical: TextAlignVertical.center,
      // validator: (value) {
      //   if (value == null || value.isEmpty) return 'Table name is required.';
      //   return null;
      // },
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      // onSaved: (value) => tableName = value,
      // onChanged: (value) {
      //   setState(() {
      //     tableName = value;
      //   });
      // },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10), border: OutlineInputBorder()),
    );
}