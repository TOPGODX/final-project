import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:loginsystem/screen/login.dart';
import 'package:loginsystem/screen/NavBar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:loginsystem/model/data.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreen createState() => _WelcomeScreen();
}

List<ProducrModel> ProducrModels = List();

class _WelcomeScreen extends State<WelcomeScreen> {
  final auth = FirebaseAuth.instance;
  // @override
  // void initStare() {
  //   super.initState();
  //   // readAllData();
  // }

/*
  Future<Void> readAllData() {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("subject");
    collectionReference.snapshots().listen((response) {
      List<DocumentSnapshot> snapshots = response.docs;

      for (var snapshot in snapshots) {
        print('snapshot = $snapshot');
        Map<String, dynamic> data = snapshot.data()! as Map<String, dynamic>;
      }
    });
    return;
  }
*/

  // Widget ShowListView(int index) {
  //   return Row(
  //     children: <Widget>[
  //       Container(
  //         width: MediaQuery.of(context).size.width * 0.5,
  //         height: MediaQuery.of(context).size.width * 0.5,
  //         child: Image.network(ProducrModels[index].urlpic),
  //       )
  //     ],
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: Text("                  MARKET SHOP",
            textDirection: TextDirection.ltr,
            style: GoogleFonts.oswald(
              fontWeight: FontWeight.normal,
              color: Colors.white,
            )),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection("Producr").snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  print('xcxzcz');
                  return Text("Loading.....");
                } else {
                  return Container(
                    child: ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (BuildContext buildContext, int index) {
                        print(snapshot.data.docs[index]['name']);
                        // return ShowListView(index);

                        return SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            child: Column(children: [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Container(
                                  width: 380,
                                  height: 150,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 3,
                                          blurRadius: 10,
                                          offset: Offset(0, 3),
                                        )
                                      ]),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 15,
                                      ),
                                      InkWell(
                                        onTap: () {},
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Image.network(
                                            snapshot.data.docs[index]['url'],
                                            height: 150,
                                            width: 150,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Container(
                                        width: 160,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(
                                              snapshot.data.docs[index]['name'],
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              snapshot.data.docs[index]
                                                  ['detail'],
                                              style: GoogleFonts.kanit(
                                                  fontSize: 12,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                            Row(
                                              children: [
                                                Image.network(
                                                  "https://cdn.discordapp.com/attachments/846300874976133161/1076955671842541619/ezuelEWRrrIsW6VFUU7Gt91bR60AH6B8LHdB9n2M8DAAAAAElFTkSuQmCC.png",
                                                  height: 18,
                                                  width: 18,
                                                ),
                                                Text(
                                                  "  เวลาเปิด " +
                                                      snapshot.data.docs[index]
                                                          ['time'] +
                                                      " น",
                                                  style: GoogleFonts.pridi(
                                                    fontSize: 11,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                RatingBar.builder(
                                                  initialRating: 5,
                                                  minRating: 1,
                                                  direction: Axis.horizontal,
                                                  itemCount: 5,
                                                  itemSize: 15,
                                                  itemPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 2),
                                                  itemBuilder: (context, _) =>
                                                      Icon(
                                                    Icons.star,
                                                    color: Colors.orange,
                                                  ),
                                                  onRatingUpdate: (index) {},
                                                ),
                                                Text(
                                                  " ( 4.0 ) ",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 5),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Icon(
                                              Icons.search,
                                              color: Colors.grey,
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ]),
                          ),
                        );
                      },
                    ),
                  );
                }
              }),
        ),
      ),
    );
  }
}
