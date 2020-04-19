import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'successful.dart';

class CheckoutPage extends StatefulWidget {

  final List shoppingBag;
  final int total;
  final String ownerEmail, customerEmail;
  CheckoutPage({
    @required this.shoppingBag,
    @required this.total,
    @required this.customerEmail,
    @required this.ownerEmail
  });

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {

  int total;
  List shoppingBag = List();

  @override
  void initState() {
    total = widget.total;
    shoppingBag = widget.shoppingBag;
    super.initState();
  }

  fetchImage(itemID) async{
    var ref = Firestore.instance.collection("items");
    var doc = await ref.document(itemID).get();
    return doc["imgURL"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Checkout",
          style: GoogleFonts.raleway(
            fontSize: 18,
            color: Colors.white
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 24,
          horizontal: 18
        ),
        child: ListView.builder(
          itemCount: shoppingBag.length,
          itemBuilder: (BuildContext context, int index){
            return Padding(
              padding: EdgeInsets.symmetric(
                vertical: 12
              ),
              child: Row(
                children: <Widget>[
                  InkWell(
                    onTap: (){
                      var itemID = shoppingBag[index]["itemID"];
                      for (int index = 0; index < shoppingBag.length; index++){
                        if(shoppingBag[index]["itemID"] == itemID){
                          total = total - shoppingBag[index]["price"];
                          shoppingBag.removeAt(index);
                          break;
                        }
                      }
                      setState(() {});
                    },
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.remove_circle_outline
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 18,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.redAccent,
                    radius: 18,
                    child: Icon(
                      Icons.list,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        shoppingBag[index]["itemName"],
                        style: GoogleFonts.raleway(
                          fontSize: 20
                        ),
                      ),
                      SizedBox(
                        height: 2
                      ),
                      Text(
                        "Price: \u20B9 " + shoppingBag[index]["price"].toString(),
                        style: GoogleFonts.varelaRound(
                          fontSize: 14
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async{
          var ref = Firestore.instance;
          DateTime now = DateTime.now();
          String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
          Map<String, dynamic> finalisedCart = {
            "cart": shoppingBag,
            "isActive": true,
            "orderedAt": widget.ownerEmail,
            "orderedBy": widget.customerEmail,
            "total": total,
            "timestamp": formattedDate
          };
          await ref.collection("orders").add(finalisedCart);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => SuccessfulScreen()
            )
          );
        },
        label: Text(
          "Place order of " + total.toString()
        ),
        icon: Icon(Icons.chevron_right),
      ),
    );
  }
}