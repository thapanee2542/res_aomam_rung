import 'dart:convert';


import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/model/foodmenu_mode.dart';
import 'package:flutter_rrs_app/screen/restaurant/add_menu.dart';
import 'package:flutter_rrs_app/screen/restaurant/add_table.dart';
import 'package:flutter_rrs_app/screen/restaurant/edit_foodmenu.dart';
import 'package:flutter_rrs_app/utility/my_constant.dart';
import 'package:flutter_rrs_app/utility/normal_dialog.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowMenu extends StatefulWidget {
  ShowMenu({Key? key}) : super(key: key);

  @override
  _ShowMenuState createState() => _ShowMenuState();
}

class _ShowMenuState extends State<ShowMenu> {
  bool status = false; //มีข้อมูลอาหาร
  bool loadStatus = true;
bool? statusFood;
String? foodMenuStatus;
  
  List<FoodMenuModel> foodMenuModels = [];
  bool _statusFoodMenu = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readFoodMenu();
  }

  Future<Null> readFoodMenu() async {
    if (foodMenuModels.length != 0) {
      foodMenuModels.clear();
    }

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? restaurantId = preferences.getString('restaurantId');

    String url =
        '${Myconstant().domain}/res_reserve/getFoodmenuWhereRestaurantId.php?isAdd=true&restaurantId=$restaurantId';
    await Dio().get(url).then((value) {
      setState(() {
        loadStatus = false;
      });
      if (value.toString() != 'null') {
        var result = json.decode(value.data);
        for (var map in result) {
          FoodMenuModel foodMenuModel = FoodMenuModel.fromJson(map);
          setState(() {
            foodMenuModels.add(foodMenuModel);
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
      body: loadStatus ? showProgress() : showListFoodMenu(),
      floatingActionButton: addTableButton(context),
    );
  }

  Center showProgress() => Center(
        child: CircularProgressIndicator(),
      );

  Widget showListFoodMenu() => ListView.separated(
        separatorBuilder: (context, index) {
          return Divider();
        },
        itemCount: foodMenuModels.length,
        itemBuilder: (context, index) {
          return Slidable(
            actionPane: SlidableDrawerActionPane(),
            secondaryActions: [
              IconSlideAction(
                caption: 'Edit',
                color: Colors.blue,
                icon: Icons.edit,
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder:(context)=>EditFoodMenu(foodMenuModel: foodMenuModels[index],) )).then((value) => readFoodMenu());
                },
              ),
              IconSlideAction(
                caption: 'Delete',
                color: Colors.red,
                icon: Icons.delete,
                onTap: (){deleteFoodMenu(foodMenuModels[index]);},
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
                        '${Myconstant().domain}${foodMenuModels[index].foodMenuPicture}',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.15,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${foodMenuModels[index].foodMenuName}',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                                '${foodMenuModels[index].foodMenuPrice}',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                            // SwitchListTile(value: statusFoodMenu, onChanged:(bool value){}),
                            Row(
                          
                              children: [
                              
                              Container(
                              
                                width: 100,
                                child :
                              foodMenuModels[index].foodMenuStatus == 'true' ? Text('ready to serve') : Text('not available')),
                              Switch(
                             
                                value: foodMenuModels[index].foodMenuStatus == 'true'?statusFood = true : statusFood = false,
                                onChanged: (bool value) {
                                  
                                  setState(() {
                                    statusFood = value;
                                    updateStatusFood(foodMenuModels[index],statusFood);


                                  });

                                   
                                })
                            ],)
                            
                            
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );

  Future<Null> updateStatusFood(FoodMenuModel foodMenuModel,bool? statusFood) async{
      String? foodMenuId = foodMenuModel.foodMenuId;
      
      statusFood == true ? foodMenuStatus = 'true' : foodMenuStatus = 'false';
      print('status = $statusFood');
      print('foodMenuStatus = $foodMenuStatus');

      String url = '${Myconstant().domain}/res_reserve/editStatusWhereId.php?isAdd=true&foodMenuId=$foodMenuId&foodMenuStatus=$foodMenuStatus';
      try {
        await Dio().get(url).then((value) {
          if (value.toString() == 'true') {
           
            normalDialog(context, 'complete');
             readFoodMenu();
            
          }else {
            normalDialog(context, 'try again');
          }
        });
      } catch (e) {
      }
  }    

  Padding addTableButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
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
                            MaterialPageRoute(builder: (context) => AddMenu()))
                        .then((value) => readFoodMenu());
                  }),
            ],
          ),
        ],
      ),
    );
  }

  Future<Null> deleteFoodMenu(FoodMenuModel foodMenuModel) async {
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              title: Text(
                'Do You want to delete table ${foodMenuModel.foodMenuName} ?',
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
                              '${Myconstant().domain}/res_reserve/delete_foodmenu.php?isAdd=true&foodMenuId=${foodMenuModel.foodMenuId}';
                          await Dio().get(url).then((value) => readFoodMenu());
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
