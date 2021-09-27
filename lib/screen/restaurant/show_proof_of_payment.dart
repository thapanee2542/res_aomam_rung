import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/utility/my_constant.dart';

class ShowProofOfPayment extends StatefulWidget {
  final urlImage;
  ShowProofOfPayment({Key? key, this.urlImage}) : super(key: key);

  @override
  _ShowProofOfPaymentState createState() => _ShowProofOfPaymentState();
}

class _ShowProofOfPaymentState extends State<ShowProofOfPayment> {
  String? urlPayment;
  @override
  void initState() {
    super.initState();
    urlPayment = widget.urlImage;
    print(urlPayment);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Image.network(
            '${Myconstant().domain}/res_reserve${widget.urlImage}',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
