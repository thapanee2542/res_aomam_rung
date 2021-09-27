import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rrs_app/model/reserve_details_model.dart';
import 'dart:math' as math;

import 'package:flutter_rrs_app/utility/my_constant.dart';

class ShowCancelPage extends StatefulWidget {
  final ReserveDetailsModel? reserveDetailsModel;
  ShowCancelPage({Key? key,this.reserveDetailsModel}) : super(key: key);

  @override
  _ShowCancelPageState createState() => _ShowCancelPageState();
}

class _ShowCancelPageState extends State<ShowCancelPage> {
  ReserveDetailsModel? reserveDetailsModel;
  TextEditingController _controller = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  String? reason;
 bool loadSubmit = false;
  int _value = 0;

  @override
  void initState() { 
    super.initState();
    reserveDetailsModel = widget.reserveDetailsModel;
    print(reserveDetailsModel!.reservationId.toString());
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
      child: FractionallySizedBox(
        heightFactor: 0.9,
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
            Text(
              'Please specify the reason for cancellation.',
              style: TextStyle(fontSize: 20),
            ),
            // Wrap(

            //  spacing: 3,
            //   children:[  _showChoiceChip('Busy table',1),
            //   _showChoiceChip('Zones reserved by customer are not avaliable',2),
            //   ]
            // ),
            SizedBox(
              height: 10,
            ),
            Form(
              key: _formkey,
                child: TextFormField(
              controller: _controller,
              onSaved: (value) => reason = value,
              onChanged: (value) {
                setState(() {
                  reason = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty)
                  return 'Please enter a reason for cancellation';
                return null;
              },
              decoration: InputDecoration(border: OutlineInputBorder()),
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
                    editStatus('cancel');
                    
                    print('Reason : $reason');
                  }
                },
                child: loadSubmit ? Container(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator()):
                Text(
                  'Submit',
                  style: TextStyle(fontSize: 20),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xffF1B739),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _showChoiceChip(String text, int selectNumber) {
    return ChoiceChip(
      label: Text(text),
      selected: _value == selectNumber,
      onSelected: (bool selected) {
        setState(() {
          _value = selected ? selectNumber : 0;
        });
      },
    );
  }

  Future<Null> editStatus(String status) async {
    String reservationId = reserveDetailsModel!.reservationId.toString();
    print(reservationId);
    String reservationStatus = status;

    var url =
        '${Myconstant().domain}/res_reserve/edit_status_reservation_where_reservationId.php?reservationId=$reservationId&isAdd=true&reservationStatus=$reservationStatus';

    await Dio().get(url).then((value) {
      if (value.toString() == 'true') {
        editReason(reason.toString());
      }
    });
  }

  Future<Null> editReason(String reservationReasonCancelStatus) async {
    String reservationId = reserveDetailsModel!.reservationId.toString();
    
    var url =
        '${Myconstant().domain}/res_reserve/edit_reason_cancel_status.php?reservationId=$reservationId&isAdd=true&reservationReasonCancelStatus=$reservationReasonCancelStatus';

    await Dio().get(url).then((value) {
      if (value.toString() == 'true') {
        Navigator.pop(context);
        Navigator.pop(context);
      }
    });
  }





}
