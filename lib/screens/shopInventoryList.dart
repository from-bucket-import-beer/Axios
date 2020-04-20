import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nima/nima_actor.dart';
import 'package:share/share.dart';
import 'package:google_fonts/google_fonts.dart';
import 'checkoutPage.dart';

class ShopInventory extends StatefulWidget {

  final String shopName, shopAddress, shopTimings, shopImgUrl, shopID, email, ownerEmail;
  ShopInventory({this.shopName, this.shopAddress, this.shopTimings, this.shopImgUrl, this.shopID, this.email, this.ownerEmail});

  @override
  _ShopInventoryState createState() => _ShopInventoryState();
}

class _ShopInventoryState extends State<ShopInventory> {

  List shoppingBag = List();
  int total = 0;

  addToCart(itemID, price, itemName) async{
    total = total + price;
    Map<String, dynamic> itemDetails = {
      "itemID": itemID,
      "price": price,
      "quantity": 1,
      "itemName": itemName
    };
    shoppingBag.add(itemDetails);
    setState(() {});
  }

  removeFromCart(itemID, price) async{
    total = total - price;
    for (int index = 0; index < shoppingBag.length; index++){
      if(shoppingBag[index]["itemID"] == itemID){
        shoppingBag.removeAt(index);
        break;
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Center(
            child: Column(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height / 3,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height / 3,
                        width: MediaQuery.of(context).size.width,
                        child: Image.network(
                          widget.shopImgUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height / 3,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.black45
                      ),
                      Positioned(
                        top: 24,
                        left: 16,
                        child: InkWell(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Icon(
                              Icons.chevron_left,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 24,
                        right: 16,
                        child: InkWell(
                          onTap: (){
                            var message = "Check out this store, " + widget.shopName + "!";
                            Share.share(message);
                          },
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Icon(
                              Icons.share,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 48,
                        left: 20,
                        child: Text(
                          widget.shopName,
                          style: GoogleFonts.raleway(
                            fontSize: 24,
                            color: Colors.white
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 20,
                        child: Text(
                          widget.shopTimings != null ? "Timings: " + widget.shopTimings : "",
                          style: GoogleFonts.openSans(
                            fontSize: 20,
                            color: Colors.white
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: Firestore.instance.collection("items").where("shopID", isEqualTo: widget.shopID).snapshots(),
                    builder: (BuildContext context, AsyncSnapshot snapshot){
                      if(snapshot.hasData){
                        if(snapshot.data.documents.length != 0){
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (BuildContext context, int index){
                              var itemID = snapshot.data.documents[index].documentID;
                              Map<String, dynamic> itemDetails = {
                                "itemID": itemID,
                                "price": snapshot.data.documents[index]["price"],
                                "quantity": 1,
                                "itemName": snapshot.data.documents[index]["name"]
                              };
                              bool isInShoppingBag = false;
                              for (var item in shoppingBag){
                                if(item["itemID"] == itemID){
                                  isInShoppingBag = true;
                                  break;
                                }
                              }
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.redAccent,
                                  child: snapshot.data.documents[index]["imgURL"].length > 0 ? Image.network(
                                      snapshot.data.documents[index]["imgURL"]
                                  ) : Text(
                                    snapshot.data.documents[index]["name"].toString()[0].toUpperCase(),
                                    style: GoogleFonts.varelaRound(
                                      color: Colors.white
                                    ),
                                  ),
                                ),
                                title: Text(
                                  snapshot.data.documents[index]["name"],
                                  style: GoogleFonts.raleway(
                                    fontSize: 18
                                  ),
                                ),
                                subtitle: Text(
                                  "\u20B9 " + snapshot.data.documents[index]["price"],
                                  style: GoogleFonts.openSans(
                                    fontSize: 16
                                  ),
                                ),
                                trailing: isInShoppingBag ? InkWell(
                                  onTap: (){
                                    removeFromCart(itemID, int.parse(snapshot.data.documents[index]["price"].toString()));
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Icon(Icons.remove_circle_outline),
                                  ),
                                ) : snapshot.data.documents[index]["quantity"] != "0" ? InkWell(
                                  onTap: (){
                                    addToCart(itemID, int.parse(snapshot.data.documents[index]["price"].toString()), snapshot.data.documents[index]["name"]);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Icon(Icons.add_circle_outline),
                                  ),
                                ) : Icon(Icons.not_interested),
                              );
                            },
                          );
                        }
                        else{
                          return Center(
                            child: Container(
                              height: MediaQuery.of(context).size.height / 1.5,
                              width: MediaQuery.of(context).size.width / 2,
                              child: Center(
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 24,
                                    ),
                                    Container(
                                      height: MediaQuery.of(context).size.height / 3,
                                      width: MediaQuery.of(context).size.width / 2,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 54
                                        ),
                                        child: NimaActor(
                                          "assets/flares/oops.nma",
                                          fit: BoxFit.contain,
                                          animation: "Idle",
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      "Uh - oh, looks like this shop ran out of supplies! Don't worry! They'll be back soon :D",
                                      style: GoogleFonts.openSans(
                                        fontSize: 15
                                      ),
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Text(
                                      "Meanwhile, check out other stores nearby!",
                                      style: GoogleFonts.openSans(
                                        fontSize: 15
                                      ),
                                    )
                                  ],
                                )
                              ),
                            ),
                          );
                        }
                      }
                      else{
                        return Container(
                          height: MediaQuery.of(context).size.height / 2,
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                    },
                  ),
                )
              ],
            ),
          )
        ]
      ),
      floatingActionButton: shoppingBag.length != 0 ? FloatingActionButton.extended(
        onPressed: (){
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => CheckoutPage(
                total: total,
                shoppingBag: shoppingBag,
                ownerEmail: widget.ownerEmail,
                customerEmail: widget.email,
              )
            )
          );
        },
        label: Text(
          "Checkout"
        ),
        icon: Icon(Icons.shopping_cart),
      ) : Container()
    );
  }
}