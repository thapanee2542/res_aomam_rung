import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/model/tableres_model.dart';
import 'package:flutter_rrs_app/screen/restaurant/edit_table.dart';
import 'package:flutter_rrs_app/utility/my_constant.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'add_table.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ShowTable extends StatefulWidget {
  ShowTable({Key? key}) : super(key: key);

  @override
  _ShowTableState createState() => _ShowTableState();
}

class _ShowTableState extends State<ShowTable> {
  bool status = true; //มีข้อมูลโต๊ะ
  bool loadStatus = true;
  List<TableResModel> tableresModels = [];

  @override
  void initState() {
    super.initState();
    readTableRes();
  }

  Future<Null> readTableRes() async {
    if (tableresModels.length != 0) {
      tableresModels.clear();
    }
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? restaurantId = preferences.getString('restaurantId');

    print(restaurantId);
    String url =
        '${Myconstant().domain}/res_reserve/getTableWhereRestaurantId.php?isAdd=true&restaurantId=$restaurantId';
    await Dio().get(url).then((value) {
      setState(() {
        loadStatus = false;
      });
      if (value.toString() != 'null') {
        print('value ==>> $value');
        var result = json.decode(value.data);
        print('result ==>> $result');
        for (var map in result) {
          TableResModel tableresModel = TableResModel.fromJson(map);
          setState(() {
            tableresModels.add(tableresModel);
          });
        }
      } else {
        setState(() {
          status = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loadStatus ? showProgress() : showListTable(),
      floatingActionButton: addTableButton(context),
      // children: [
      //   loadStatus ? showProgress() : showListTable(),
      //   addTableButton(context),
      // ],
    );
  }

  Center showProgress() => Center(
        child: CircularProgressIndicator(),
      );

  Widget addTableButton(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                  backgroundColor: Color(0xff1CA7EA),
                  child: Icon(Icons.add),
                  onPressed: () {
                    //ถ้ากลับมาจะสั่งให้บิ้วใหม่
                    Navigator.push(context,
                            MaterialPageRoute(builder: (context) => AddTable()))
                        .then((value) => readTableRes());
                  }),
            ],
          ),
        ],
      );
  }

  Widget showListTable() => ListView.separated(
      separatorBuilder: (context, index) {
        return Divider();
      },
      itemCount: tableresModels.length,
      itemBuilder: (context, index) {
        return Slidable(
          actionPane: SlidableDrawerActionPane(),
          secondaryActions: [
            IconSlideAction(
              caption: 'Edit',
              color: Colors.blue,
              icon: Icons.edit,
              onTap: () {
                
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditTable(

                              tableResModel: tableresModels[index],
                            ))).then((value) => readTableRes());
              },
            ),
            IconSlideAction(
              caption: 'Delete',
              color: Colors.red,
              icon: Icons.delete,
              onTap: () {deleteTable(tableresModels[index]);},
            )
          ],
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.15,
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: MediaQuery.of(context).size.height * 0.15,
                    child: Image.network(
                      '${Myconstant().domain}${tableresModels[index].tablePicOne}',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.15,
                    //  width: MediaQuery.of(context).size.width*0.62,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.amber[200],
                                radius: 15,
                                child: Text(
                                  '${tableresModels[index].tableResId.toString()}',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                '${tableresModels[index].tableName.toString()}',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.chair,
                                color: Color(0xff767A83),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                '${tableresModels[index].tableNumseat.toString()} ',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'seats',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87),
                              ),
                            ],
                          ),
                         

                          // Text(
                          //   'Description: ${tableresModels[index].tableDescrip.toString()}',
                          //   style: TextStyle(fontSize: 12),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });

  Future<Null> deleteTable(TableResModel tableResModel) async {
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              title: Text(
                'Do You want to delete table ${tableResModel.tableResId} ${tableResModel.tableName} ?',
                style: TextStyle(color: Colors.red),
              ),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'cancel',
                          style: TextStyle(color: Colors.blue, fontSize: 17),
                        )),
                    TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          String? url =
                              '${Myconstant().domain}/res_reserve/delete_table.php?isAdd=true&tableId=${tableResModel.tableId}';
                          await Dio().get(url).then((value) => readTableRes());
                        },
                        child: Text(
                          'confirm',
                          style: TextStyle(color: Colors.blue, fontSize: 17),
                        )),
                  ],
                )
              ],
            ));
  }
}
// Padding(
//           padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
//           child: Row(
//             children: [
//               Container(
//                 color: Colors.blue,
//                 width: MediaQuery.of(context).size.width * 0.3,
//                 height: MediaQuery.of(context).size.height * 0.15,
//                 child: Image.network(
//                   '${MyConstant().domain}${tableresModels[index].tablePicOne}',
//                   fit: BoxFit.cover,
//                 ),
//               ),
//              Container(
//                width: MediaQuery.of(context).size.width * 0.6,
//                height: MediaQuery.of(context).size.height * 0.15,
//                child: Text(tableresModels[index].tableName.toString()),
//                color: Colors.red,
//              ),
//             ],
//           ),
//         );