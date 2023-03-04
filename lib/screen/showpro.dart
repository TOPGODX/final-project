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

class Showpro extends StatefulWidget {
  @override
  _ShowproState createState() => _ShowproState();
}

class _ShowproState extends State<Showpro> {
  final auth = FirebaseAuth.instance;
  String namex = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
          title: Card(
        child: TextField(
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.search), hintText: "ค้นหาสินค้า"),
          onChanged: (val) {
            setState(() {
              namex = val;
            });
          },
        ),
      )),
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
                          .collection("Producrx")
                          .get(),
                    ),
                  ),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Text("Loading.....");
                    } else {
                      return ListView.builder(
                        itemCount: hot.data.docs.length,
                        itemBuilder: (context, love) {
                          final producrxDocs = snapshot.data[love].docs;

                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: producrxDocs.length,
                                  itemBuilder: (context, index) {
                                    // print(hot.data.docs[love]["name"]);
                                    // print(producrxDocs[index].get("name"));
                                    // print(producrxDocs[index].get("price"));
                                    // print(hot.data.docs[love].id);
                                    if (namex.isEmpty) {
                                      return SingleChildScrollView(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 10),
                                          child: Column(children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5),
                                              child: Container(
                                                width: 380,
                                                height: 120,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.5),
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
                                                        alignment:
                                                            Alignment.center,
                                                        child: Image.network(
                                                          producrxDocs[index]
                                                              .get("url"),
                                                          height: 90,
                                                          width: 90,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 60,
                                                    ),
                                                    Container(
                                                      width: 140,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              Text(
                                                                producrxDocs[
                                                                        index]
                                                                    .get(
                                                                        "name"),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    GoogleFonts
                                                                        .pridi(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Image.network(
                                                                "https://cdn.discordapp.com/attachments/819007560120008726/1081390847318302831/green-dollar-png-download-image.png",
                                                                height: 30,
                                                                width: 30,
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                '${producrxDocs[index].get("price")}' +
                                                                    '   บาท',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    GoogleFonts
                                                                        .pridi(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Image.network(
                                                                "https://cdn.discordapp.com/attachments/819007560120008726/1081391769943539834/e15b3a4d40aca7334d7d7cf33a680000.png",
                                                                height: 30,
                                                                width: 30,
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                hot.data.docs[
                                                                        love]
                                                                    ["name"],
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    GoogleFonts
                                                                        .pridi(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 1),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          IconButton(
                                                            icon: const Icon(
                                                                Icons.search),
                                                            color: Colors.grey,
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .push(
                                                                MaterialPageRoute(
                                                                  builder: (BuildContext
                                                                          context) =>
                                                                      ResultPage(
                                                                          hot
                                                                              .data
                                                                              .docs[love]
                                                                              .id,
                                                                          love),
                                                                ),
                                                              );
                                                            },
                                                          ),
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
                                    }

                                    if (producrxDocs[index]
                                        .get("name")
                                        .toString()
                                        .startsWith(namex.toLowerCase())) {
                                      return SingleChildScrollView(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 10),
                                          child: Column(children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5),
                                              child: Container(
                                                width: 380,
                                                height: 120,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.5),
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
                                                        alignment:
                                                            Alignment.center,
                                                        child: Image.network(
                                                          producrxDocs[index]
                                                              .get("url"),
                                                          height: 90,
                                                          width: 90,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 60,
                                                    ),
                                                    Container(
                                                      width: 140,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              Text(
                                                                producrxDocs[
                                                                        index]
                                                                    .get(
                                                                        "name"),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    GoogleFonts
                                                                        .pridi(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Image.network(
                                                                "https://cdn.discordapp.com/attachments/819007560120008726/1081390847318302831/green-dollar-png-download-image.png",
                                                                height: 30,
                                                                width: 30,
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                '${producrxDocs[index].get("price")}' +
                                                                    '   บาท',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    GoogleFonts
                                                                        .pridi(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Image.network(
                                                                "https://cdn.discordapp.com/attachments/819007560120008726/1081391769943539834/e15b3a4d40aca7334d7d7cf33a680000.png",
                                                                height: 30,
                                                                width: 30,
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                hot.data.docs[
                                                                        love]
                                                                    ["name"],
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    GoogleFonts
                                                                        .pridi(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 1),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          IconButton(
                                                            icon: const Icon(
                                                                Icons.search),
                                                            color: Colors.grey,
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .push(
                                                                MaterialPageRoute(
                                                                  builder: (BuildContext
                                                                          context) =>
                                                                      ResultPage(
                                                                          hot
                                                                              .data
                                                                              .docs[love]
                                                                              .id,
                                                                          love),
                                                                ),
                                                              );
                                                            },
                                                          ),
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
                                    }

                                    return Container();
                                  },
                                ),
                              ],
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
