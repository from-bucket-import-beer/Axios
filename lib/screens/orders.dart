import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderHistory extends StatefulWidget {

  final String email;
  OrderHistory({
    @required this.email
  });

  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StreamBuilder(
          stream: Firestore.instance.collection("orders").where("orderedBy", isEqualTo: widget.email).snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if(snapshot.hasData){
              if(snapshot.data.documents.length != 0){
                return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int index){
                    var doc = snapshot.data.documents[index];
                    return ListTile(
                      trailing: Text(
                        "\u20B9 " + doc["total"].toString(),
                        style: GoogleFonts.raleway(
                          fontSize: 18
                        ),
                      ),
                      subtitle: Column(
                        children: <Widget>[],
                      ),
                    );
                  },
                );
              }
              else{
                return Center(
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height / 2,
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: FlareActor(
                          "assets/flares/no-orders.flr",
                          fit: BoxFit.contain,
                          animation: "defauld",
                        ),
                      ),
                      SizedBox(
                        height: 36,
                      ),
                      Text(
                        "No orders placed :(",
                        style: GoogleFonts.lato(
                          fontSize: 18
                        ),
                      )
                    ],
                  ),
                );
              }
            }
            else{
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        )
      ),
    );
  }
}