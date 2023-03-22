import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:loginsystem/screen/itemPage.dart';
import 'package:loginsystem/screen/login.dart';
import 'package:loginsystem/screen/NavBar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:loginsystem/model/data.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loginsystem/screen/editproduct.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreen createState() => _WelcomeScreen();
}

class _WelcomeScreen extends State<WelcomeScreen> {
  final auth = FirebaseAuth.instance;

  int top;
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
            builder: (context, hot) {
              if (!hot.hasData) {
                return Text("Loading.....");
              } else {
                return FutureBuilder<List<QuerySnapshot>>(
                  future: Future.wait(
                    hot.data.docs.map(
                      (document) => FirebaseFirestore.instance
                          .collection("Producr")
                          .doc(document.id)
                          .collection("rating")
                          .get(),
                    ),
                  ),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Text("Loading.....");
                    } else {
                      return ListView.builder(
                        itemCount: hot.data.docs.length,
                        itemBuilder: (context, index) {
                          double sumOfCreditMulSGPA = 0, sumOfCredit = 0;
                          double king = 0.0;
                          double rating = 0.0;
                          int ratingx = 0;
                          final producrxDocs = snapshot.data[index].docs;
                          for (int i = 0; i < producrxDocs.length; i++) {
                            double creditMulSGPA =
                                king + producrxDocs[i].get("rating").toDouble();
                            sumOfCreditMulSGPA += creditMulSGPA;
                          }
                          ratingx = producrxDocs.length;

                          if (producrxDocs.length == 0) {
                            rating = 0.0;
                          } else {
                            rating = sumOfCreditMulSGPA / producrxDocs.length;
                          }

                          return SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 0),
                              child: Column(children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  child: Container(
                                    width: 350,
                                    height: 150,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 2,
                                            blurRadius: 10,
                                            offset: Offset(0, 3),
                                          )
                                        ]),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: 5,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        ResultPage(
                                                            hot.data.docs[index]
                                                                .id,
                                                            index),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Image.network(
                                              hot.data.docs[index]["url"],
                                              height: 100,
                                              width: 100,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Container(
                                          width: 150,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Text(
                                                hot.data.docs[index]["name"],
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                hot.data.docs[index]["detail"],
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
                                                        hot.data.docs[index]
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
                                                    initialRating:
                                                        rating, //ดาวที่ได้
                                                    minRating: 1,
                                                    direction: Axis.horizontal,
                                                    itemCount: 5,
                                                    ignoreGestures: true,
                                                    itemSize: 13,
                                                    allowHalfRating:
                                                        true, //ครึ่งดาว
                                                    itemPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 2),
                                                    itemBuilder: (context, _) =>
                                                        Icon(
                                                      Icons.star,
                                                      color: Colors.orange,
                                                    ),
                                                    onRatingUpdate: (top) {
                                                      print(top);
                                                    },
                                                  ),
                                                  Container(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    rating.toStringAsFixed(2) +
                                                        ('  ($ratingx)'),
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 0,
                                            ),
                                            IconButton(
                                              icon: Image.network(
                                                "https://cdn.discordapp.com/attachments/819007560120008726/1081679877670961243/254032.png",
                                                height: 20,
                                                width: 20,
                                              ),
                                              color: Colors.grey,
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        ResultPage(
                                                            hot.data.docs[index]
                                                                .id,
                                                            index),
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ]),
                            ),
                          );
                        },
                      );
                    }
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
