import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'qrScreen.dart';

class OrderDetails extends StatefulWidget {

  final List<Widget> items;
  final String orderID, orderedBy;
  final bool isCollected;
  OrderDetails({
    @required this.items,
    @required this.orderID,
    @required this.orderedBy,
    @required this.isCollected
  });

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Order Details",
          style: GoogleFonts.raleway(
            fontSize: 18
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: widget.items,
          ),
        ),
      ),
      floatingActionButton: widget.isCollected ? FloatingActionButton.extended(
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => QRDisplayScreen(
                orderID: widget.orderID,
                orderedBy: widget.orderedBy
              )
            )
          );
        },
        label: Text(
          "Show Order QR Code",
          style: GoogleFonts.raleway(
            fontSize: 16
          ),
        ),
        icon: Icon(Icons.photo_camera),
      ) : Container(),
    );
  }
}