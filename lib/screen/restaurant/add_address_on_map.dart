import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/utility/my_constant.dart';
import 'package:flutter_rrs_app/utility/normal_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart' hide Location;
import 'package:geolocator/geolocator.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geolocator/geolocator.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddAddressMap extends StatefulWidget {
  AddAddressMap({Key? key}) : super(key: key);

  @override
  _AddAddressOnMapState createState() => _AddAddressOnMapState();
}

class _AddAddressOnMapState extends State<AddAddressMap> {
  String? name,
      street,
      isoCounntryCode,
      country,
      postalCode,
      administrativeArea,
      subAdministrativeArea,
      locality,
      subLocality,
      thoroughfare,
      subthoroughfare;
  // final Geolocator _geolocator = Geolocator();

  String? _isoCountryCode;
  String? address;
  GoogleMapController? mapController;
  FToast? fToast;
  // List<Marker> _myMarker = [];
  //Field
  double? lat, lng;
  bool loadConfirm = false;
  GoogleMapController? _controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fToast = FToast();
    fToast!.init(context);
    initialLocation();
  }

// กำหนดให้ที่อยู่เริ่มต้นป็นที่อยู่ปัจจุบัน ตามตำแหน่งของโทรศัพท์
  Future<Null> initialLocation() async {
    LocationData? locationData = await findLocationData();

    setState(() {
      lat = locationData.latitude;
      lng = locationData.longitude;
      GetAddressFromLatLong(lat!, lng!);
      _getLocationAddress(lat!, lng!);
      print('lat =$lat,lng = $lng');
    });
  }

  // //ขอการเข้าถึง Location ใน Android
  Future<LocationData> findLocationData() async {
    Location location = Location();
    return location.getLocation();
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
          onDragEnd: (dragEndPosition) {
            setState(() {
              lat = dragEndPosition.latitude;
              lng = dragEndPosition.longitude;
              GetAddressFromLatLong(lat!, lng!);
            });
            print('dragEndPosition=$dragEndPosition');
          })
    ].toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   leading: IconButton(
      //     icon: Icon(Icons.arrow_back_ios_new_rounded),
      //     color: Colors.grey,
      //     onPressed: () => Navigator.pop(context),
      //   ),
      // ),
      body: Stack(
        children: [
          lat == null
              ? Center(
                  child: Container(
                      color: Colors.white,
                      height: 100,
                      width: 100,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: Colors.blue,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text('Loading....'),
                          ],
                        ),
                      )),
                )
              : GoogleMap(
                  initialCameraPosition:
                      CameraPosition(target: LatLng(lat!, lng!), zoom: 16.0),
                  mapType: MapType.normal,
                  onTap: _handleTap,
                  markers: myMarker(),
                ),
          Positioned(
              top: 40,
              right: 15.0,
              left: 15,
              child: Container(
                height: 70.0,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.grey,
                          size: 25,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Flexible(
                          child: address == null
                              ? Text('loading...')
                              : Text(
                                  '${address}',
                                  maxLines: 2,
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                )),
                    ],
                  ),
                ),
              )),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
              Container(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  child: loadConfirm == true
                      ? Transform.scale(
                          scale: 0.7,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 4.0,
                          ))
                      : Text(
                          'Confirm',
                          style: TextStyle(fontSize: 16),
                        ),
                  onPressed: () {
                    setState(() {
                      loadConfirm = true;
                    });
                    print('lat = $lat,lng = $lng');
                    insertData();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              )
            ]),
          )
        ],
      ),
    );
  }

  Future<Null> insertData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? restaurantId = preferences.getString('restaurantId');

    String url =
        '${Myconstant().domain}/res_reserve/add_restaurant_location.php?isAdd=true&restaurantId=$restaurantId&latitude=$lat&longitude=$lng';
    try {
      Response response = await Dio().get(url);
      print('res = $response');
      if (response.toString() == 'true') {
        showToast();
        Navigator.pop(context);
      } else
        normalDialog(context, 'try again');
    } catch (e) {}
  }

  void showToast() {
    return fToast!.showToast(
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(milliseconds: 2000),
      child: Container(
        height: 40,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
        child: Material(
          elevation: 10,
          borderRadius: BorderRadius.circular(50),
          color: Colors.green,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.done_all_rounded,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Sucessfully',
                  style: TextStyle(fontSize: 14, color: Colors.white),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _handleTap(LatLng tappedPoint) {
    print('tapp = $tappedPoint');
    setState(() {
      lat = tappedPoint.latitude;
      lng = tappedPoint.longitude;
      GetAddressFromLatLong(lat!, lng!);
      // _myMarker = [];
      // _myMarker.add(Marker(
      //   markerId: MarkerId(tappedPoint.toString()),
      //   position:  LatLng(lat!,lng!),
      //   draggable: true,
      //   icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      //   onDragEnd: (dragEndPosition){
      //     print('dragEndPosition=$dragEndPosition');

      //   }
      // ));
    });
  }

  Future<void> GetAddressFromLatLong(double latitude, double longitude) async {
    print('GetAddressFromLatLong GetAddressFromLatLong');
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
    print('placemarks=== $placemarks');
    Placemark place = placemarks[0];
    address =
        '${place.name},${place.street}, ${place.subLocality}, ${place.locality}, ${place.country}, ${place.postalCode}';
    print(address);
    setState(() {
      name = place.name;
      street = place.street;
      isoCounntryCode = place.isoCountryCode;
      country = place.country;
      postalCode = place.postalCode;
      administrativeArea = place.administrativeArea;
      subAdministrativeArea = place.subAdministrativeArea;
      locality = place.locality;
      subLocality = place.subLocality;
      thoroughfare = place.subThoroughfare;
      subthoroughfare = place.subThoroughfare;
    });
  }

  Future<String> _getLocationAddress(double latitude, double longitude) async {
    List<Placemark> newPlace =
        await placemarkFromCoordinates(latitude, longitude);
    Placemark placeMark = newPlace[0];
    String? name = placeMark.name;
    // String subLocality = placeMark.subLocality;
    String? locality = placeMark.locality;
    String? administrativeArea = placeMark.administrativeArea;
    // String subAdministrativeArea = placeMark.administrativeArea;
    String? postalCode = placeMark.postalCode;
    String? country = placeMark.country;
    // String subThoroughfare = placeMark.subThoroughfare;
    String? thoroughfare = placeMark.thoroughfare;
    _isoCountryCode = placeMark.isoCountryCode;
    print(
        "$name, $thoroughfare, $locality, $administrativeArea, $postalCode, $country");
    return "$name, $thoroughfare, $locality, $administrativeArea, $postalCode, $country";
  }
}
