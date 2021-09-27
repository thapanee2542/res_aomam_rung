import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/model/restaurant_model.dart';
import 'package:flutter_rrs_app/screen/restaurant/edit_vat.dart';
import 'package:flutter_rrs_app/utility/my_constant.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ShowProfileRes extends StatefulWidget {
  ShowProfileRes({Key? key}) : super(key: key);

  @override
  _ShowProfileResState createState() => _ShowProfileResState();
}

class _ShowProfileResState extends State<ShowProfileRes> {
  bool loadStatusReadTime = true;
  bool loadStatusReadRestaurant = true;
  bool loadStatusReadLocation = true;

  double? lat;
  double? lng;

  String? isSelectVAT;
  List<String> openingTimes = [];
  List<String> closedTimes = [];

  bool ontapHaveVat = false;
  List<RestaurantModel> restaurantModels = [];

  List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Satrday',
    'Sunday'
  ];

  @override
  void initState() {
    super.initState();
    readOpeningHours();
    readRestaurant();
    readRestaurantLatLng();
  }

  List<String> createListOpenTimes(var result) {
    openingTimes.add(result[0]['monday_open']);
    openingTimes.add(result[0]['tuesday_open']);
    openingTimes.add(result[0]['wednesday_open']);
    openingTimes.add(result[0]['thursday_open']);
    openingTimes.add(result[0]['friday_open']);
    openingTimes.add(result[0]['saturday_open']);
    openingTimes.add(result[0]['sunday_open']);
    return openingTimes;
  }

  List<String> createListClosedTimes(var result) {
    closedTimes.add(result[0]['monday_closed']);
    closedTimes.add(result[0]['tuesday_closed']);
    closedTimes.add(result[0]['wednesday_closed']);
    closedTimes.add(result[0]['thursday_closed']);
    closedTimes.add(result[0]['friday_closed']);
    closedTimes.add(result[0]['saturday_closed']);
    closedTimes.add(result[0]['sunday_closed']);
    return closedTimes;
  }

  Future readOpeningHours() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? restaurantId = preferences.getString('restaurantId');
    String url =
        '${Myconstant().domain}/res_reserve/get_opening_hours_where_restaurantId.php?isAdd=true&restaurantId=$restaurantId';
    await Dio().get(url).then((value) {
      if (value.toString() != 'null') {
        var result = json.decode(value.data);
        print('result ====> $result');
        print('result2 ===> ${result[0]['monday_open']}');
        setState(() {
          openingTimes = createListOpenTimes(result);
          closedTimes = createListClosedTimes(result);
          loadStatusReadTime = false;
          print('openingTimes ===> $openingTimes');
          print('closedTimes ===> $closedTimes');
        });
      }
    });
  }

  //ดึงข้อมูลจาก table restaurant
  Future readRestaurant() async {
    if (restaurantModels.length != 0) {
      restaurantModels.clear();
    }
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? restaurantId = preferences.getString('restaurantId');
    String url =
        '${Myconstant().domain}/res_reserve/get_restaurant_where_restaurantId.php?isAdd=true&restaurantId=$restaurantId';
    await Dio().get(url).then((value) {
      if (value.toString() != 'null') {
        setState(() {
          loadStatusReadRestaurant = false;
        });
        var result = json.decode(value.data);
        if (value.toString() != 'null') {
          var result = json.decode(value.data);
          print('result all discount promotion ==> $result');
          for (var map in result) {
            RestaurantModel restaurantModel = RestaurantModel.fromJson(map);
            setState(() {
              restaurantModels.add(restaurantModel);
            });
          }
        }
      }
    });
  }

  Future readRestaurantLatLng() async {
    // if (restaurantModels.length != 0) {
    //   restaurantModels.clear();
    // }
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? restaurantId = preferences.getString('restaurantId');
    String url =
        '${Myconstant().domain}/res_reserve/get_location_where_restaurantId.php?isAdd=true&restaurantId=$restaurantId';
    await Dio().get(url).then((value) {
      if (value.toString() != 'null') {
        setState(() {
          loadStatusReadRestaurant = false;
        });
        var result = json.decode(value.data);
        if (value.toString() != 'null') {
          setState(() {
            loadStatusReadLocation = false;
          });

          var result = json.decode(value.data);
          setState(() {
            lat = double.parse(result[0]['latitude']);
            lng = double.parse(result[0]['longitude']);
            print('lat = $lat,lng = $lng');
          });
        }
      }
    });
  }
  Set<Marker> myMarker() {
    return <Marker>[
      Marker(
          draggable: true,
          markerId: MarkerId('myMarker'),
          position: LatLng(lat!, lng!),
          infoWindow: InfoWindow(title: 'Your restaurant'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          
       ) ].toSet();
  }

  Center showProgress() => Center(
        child: CircularProgressIndicator(),
      );

  @override
  Widget build(BuildContext context) {
    return loadStatusReadRestaurant == true &&
            loadStatusReadLocation == true &&
            loadStatusReadTime == true
        ? showProgress()
        : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Restaurant code'),
                      Text('${restaurantModels[0].restaurantId}'),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Owner name'),
                      Text('${restaurantModels[0].name}'),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Email'),
                      Text('${restaurantModels[0].email}'),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Phone number'),
                      Text('${restaurantModels[0].phonenumber}'),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Identification number'),
                      Text('${restaurantModels[0].restaurantIdNumber}'),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Restaurant name'),
                      Text('${restaurantModels[0].restaurantNameshop}'),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Resturant branch'),
                      Text('${restaurantModels[0].restaurantBranch}'),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Type of foode'),
                      Text('${restaurantModels[0].typeOfFood}'),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text('VAT'),
                          IconButton(
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                              onPressed: () {
                                showModalBottomSheet(
                                    isScrollControlled: true,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(30))),
                                    context: context,
                                    builder: (BuildContext context) => EditVat(
                                          restaurantModel: restaurantModels[0],
                                        )).then((value) {
                                  // setState(() {
                                  //   loadStatusReadTime = true;
                                  //   loadStatusReadRestaurant = true;
                                  //   loadStatusReadLocation = true;
                                  // });
                                  readOpeningHours();
                                  readRestaurant();
                                  readRestaurantLatLng();
                                });
                              },
                              icon: Icon(
                                Icons.edit,
                                size: 17,
                                color: Colors.grey,
                              ))
                        ],
                      ),
                      Text('${restaurantModels[0].vat} %'),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.location_on_sharp),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                          child:
                              Text('${restaurantModels[0].restaurantAddress}')),
                    ],
                  ),
               SizedBox(height: 10,),
                  Container(
                   decoration: BoxDecoration(
                     
                    //  borderRadius: BorderRadius.circular(10),
                  color: Colors.yellow[100],
                  border: Border.all(
                    color: Colors.grey,
                    width: 3,
                  )
                  ),
                    width: double.infinity,
                    height: 200,
                    child: GoogleMap(
                  initialCameraPosition:
                      CameraPosition(target: LatLng(lat!, lng!), zoom: 18.0),
                  mapType: MapType.normal,
               
                  markers: myMarker(),
                ),
                  ),
                  Divider(),
                  loadStatusReadTime == true
                      ? showProgress()
                      : Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.access_time),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('Opening hours'),
                                  ],
                                ),
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: BoxConstraints(),
                                  onPressed: () {},
                                  icon: Icon(Icons.edit,size: 18,color: Colors.grey,),
                                ),
                              ],
                            ),
                            SizedBox(height: 10,),
                            ListView.builder(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                itemCount: days.length,
                                itemBuilder: (context, index) {
                                  return Row(
                                    children: [
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                          flex: 1,
                                          child: Text('${days[index]}')),
                                      Expanded(
                                          flex: 2,
                                          child: openingTimes[index] ==
                                                      '00:00:00' &&
                                                  closedTimes[index] ==
                                                      '00:00:00'
                                              ? Text('Closed')
                                              : Text(
                                                  '${openingTimes[index]} - ${closedTimes[index]}')),
                                    ],
                                  );
                                }),
                            Divider(),
                          ],
                        ),
                ],
              ),
            ),
          );
  }
}
