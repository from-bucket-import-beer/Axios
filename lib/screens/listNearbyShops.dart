import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:nima/nima_actor.dart';
import 'shopCard.dart';

class ShopsNearByScreen extends StatefulWidget {

  final String pinCode, email;
  ShopsNearByScreen({@required this.pinCode, @required this.email});

  @override
  _ShopsNearByScreenState createState() => _ShopsNearByScreenState();
}

class _ShopsNearByScreenState extends State<ShopsNearByScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: Firestore.instance.collection("shops").where("pincode", isEqualTo: widget.pinCode).snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.hasData){
            if(snapshot.data.documents.length == 0){
              return Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height / 1.5,
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: Center(
                        child: NimaActor(
                          "assets/flares/oops.nma",
                          fit: BoxFit.contain,
                          animation: "Idle",
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    Text(
                      "No shops nearby use this platform!",
                      style: GoogleFonts.raleway(
                        fontSize: 24
                      ),
                    )
                  ],
                ),
              );
            }
            else{
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index){
                  List favs = snapshot.data.documents[index]["favorites"];
                  bool isFavorite = favs.contains(widget.email);
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 12
                    ),
                    child: ShopCard(
                      docID: snapshot.data.documents[index].documentID,
                      isFav: isFavorite,
                      favorites: favs,
                      email: widget.email,
                      shopName: snapshot.data.documents[index]["name"],
                      shopEmail: snapshot.data.documents[index]["ownerEmail"],
                      shopAddress: snapshot.data.documents[index]["address"],
                      timings: snapshot.data.documents[index]["timings"],
                      shopImgUrl: snapshot.data.documents[index]["shopImgUrl"]
                    ),
                  );
                },
              );
            }
          }
          else{
            return Center(
              child: Container(
                height: MediaQuery.of(context).size.height / 1.5,
                width: MediaQuery.of(context).size.width / 1.5,
                child: FlareActor(
                  "assets/flares/loader.flr",
                  animation: "loading",
                  fit: BoxFit.cover
                ),
              ),
            );
          }
        }
      )
    );
  }
}