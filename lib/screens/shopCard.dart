import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'shopInventoryList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShopCard extends StatelessWidget {

  final String shopName, shopAddress, timings, shopImgUrl, shopEmail, email, docID;
  final bool isFav;
  List favorites;
  ShopCard({
    @required this.shopName,
    @required this.shopAddress,
    @required this.timings,
    @required this.shopImgUrl,
    @required this.isFav,
    @required this.favorites,
    @required this.email,
    @required this.docID,
    @required this.shopEmail
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 5,
      width: MediaQuery.of(context).size.width / 1.2,
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            24
          ),
          child: InkWell(
            onTap: () async{
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => ShopInventory(
                    shopName: shopName,
                    shopAddress: shopAddress,
                    ownerEmail: shopEmail,
                    shopImgUrl: shopImgUrl,
                    shopID: docID,
                    shopTimings: timings,
                    email: email
                  )
                )
              );
            },
            child: Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height / 5,
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: Image.network(
                    shopImgUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 5,
                  width: MediaQuery.of(context).size.width / 1.2,
                  color: Colors.black38,
                ),
                Positioned(
                  right: 8,
                  top: 12,
                  child: InkWell(
                    onTap: () async{
                      var ref = await Firestore.instance.collection("shops").document(docID).get();
                      if(isFav){
                        favorites.remove(email);
                      }
                      else{
                        favorites.add(email);
                      }
                      var details = ref.data;
                      details["favorites"] = favorites;
                      await Firestore.instance.collection("shops").document(docID).setData(details);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: Colors.white
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 48,
                  left: 12,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      color: Colors.redAccent,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8
                        ),
                        child: Text(
                          shopName,
                          style: GoogleFonts.raleway(
                            color: Colors.black,
                            fontSize: 18
                          ),
                        ),
                      ),
                    ),
                  )
                ),
                Positioned(
                  bottom: 8,
                  left: 12,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      color: Color(0x9FFFFFFF),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8
                        ),
                        child: Wrap(
                          children: <Widget>[
                            Text(
                              "Address: " + shopAddress,
                              style: GoogleFonts.raleway(
                                color: Colors.black,
                                fontSize: 12
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
