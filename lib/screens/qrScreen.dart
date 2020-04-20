import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:convert';

class QRDisplayScreen extends StatefulWidget {

  final String orderID, orderedBy;
  QRDisplayScreen({
    @required this.orderID,
    @required this.orderedBy,
  });

  @override
  _QRDisplayScreenState createState() => _QRDisplayScreenState();
}

class _QRDisplayScreenState extends State<QRDisplayScreen> {

  Map<String, dynamic> itemMap;
  var mapData = '';
  
  @override
  void initState() {
    itemMap = {
      "orderID": widget.orderID,
      "orderedBy": widget.orderedBy
    };
    mapData = json.encode(itemMap);
    setState((){});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: mapData.length > 0 ? QrImage(
          data: mapData,
        ) : CircularProgressIndicator(),
      ),
    );
  }
}