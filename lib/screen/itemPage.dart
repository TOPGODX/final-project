import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:loginsystem/screen/showshop.dart';
import 'package:loginsystem/screen/welcome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loginsystem/screen/NavBar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loginsystem/screen/my_Style.dart';
import 'package:clippy_flutter/clippy_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ResultPage extends StatefulWidget {
  final String id;
  final int index;
  ResultPage(this.id, this.index);
  @override
  State<ResultPage> createState() {
    return _ResultPage(this.id, this.index);
  }
}

class _ResultPage extends State<ResultPage> {
  final String id;
  final int index;
  double kub;
  double nut;

  _ResultPage(this.id, this.index);
  final auth = FirebaseAuth.instance;

  double rating = 0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Producr')
                  .doc(id)
                  .collection('rating')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  print('xcxzcz');
                  return Text("Loading.....");
                } else {
                  double sumOfCreditMulSGPA = 0, sumOfCredit = 0;
                  double king = 0.0;
                  double rating = 0.0;
                  int ratingx = 0;
                  int mailx = 0;
                  String mail;

                  for (int i = 0; i < snapshot.data.docs.length; i++) {
                    double creditMulSGPA =
                        king + snapshot.data.docs[i]['rating'].toDouble();
                    sumOfCreditMulSGPA += creditMulSGPA;
                  }
                  for (int i = 0; i < snapshot.data.docs.length; i++) {
                    if (snapshot.data.docs[i]['email'] != null) {
                      if (auth.currentUser?.email ==
                          snapshot.data.docs[i]['email']) mailx++;
                    }
                  }

                  ratingx = snapshot.data.docs.length;

                  if (snapshot.data.docs.length == 0) {
                    rating = 0.0;
                  } else {
                    rating = sumOfCreditMulSGPA / snapshot.data.docs.length;
                  }

                  return Scaffold(
                    body: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Center(
                        child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("Producr")
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                print('xcxzcz');
                                return Text("Loading.....");
                              } else {
                                final mainCollectionRef = FirebaseFirestore
                                    .instance
                                    .collection('Producr');
                                final mainDocRef = mainCollectionRef.doc(id);
                                final subCollectionRef =
                                    mainDocRef.collection('rating');
                                @override
                                Set<Marker> myMarker() {
                                  return <Marker>[
                                    Marker(
                                        markerId: MarkerId(
                                            snapshot.data.docs[index]['name']),
                                        position: LatLng(
                                            snapshot.data.docs[index]['lat'],
                                            snapshot.data.docs[index]['lng']),
                                        infoWindow: InfoWindow(
                                          title: snapshot.data.docs[index]
                                              ['name'],
                                          snippet: 'เวลาเปิดปิด ' +
                                              snapshot.data.docs[index]
                                                  ['time'] +
                                              ' น.',
                                        ))
                                  ].toSet();
                                }

                                Container showMap() {
                                  LatLng latLng = LatLng(
                                      snapshot.data.docs[index]['lat'],
                                      snapshot.data.docs[index]['lng']);
                                  CameraPosition cameraPosition =
                                      CameraPosition(
                                          target: latLng, zoom: 15.0);
                                  return Container(
                                    height: 200,
                                    child: GoogleMap(
                                      initialCameraPosition: cameraPosition,
                                      mapType: MapType.normal,
                                      onMapCreated: (controller) {},
                                      markers: myMarker(),
                                    ),
                                  );
                                }

                                return Padding(
                                  padding: EdgeInsets.only(top: 5),
                                  child: ListView(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(16),
                                        child: Image.network(
                                          snapshot.data.docs[index]['url'],
                                          height: 200,
                                          width: double.infinity,
                                        ),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        color:
                                            Color.fromARGB(255, 253, 253, 253),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  top: 0,
                                                  bottom: 0,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      snapshot.data.docs[index]
                                                          ['name'],
                                                      style: TextStyle(
                                                        fontSize: 28,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        Container(
                                                          height: 30,
                                                        ),
                                                        IconButton(
                                                          padding:
                                                              EdgeInsets.zero,
                                                          icon: Image.network(
                                                            "https://cdn.discordapp.com/attachments/819007560120008726/1079127463424168036/basket-icon_34490.png",
                                                            height: 200,
                                                            width: 200,
                                                          ),
                                                          color: Colors.cyan,
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .push(
                                                                    MaterialPageRoute(
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  Showshop(
                                                                      snapshot
                                                                          .data
                                                                          .docs[
                                                                              index]
                                                                          .id,
                                                                      index),
                                                            ));
                                                          },
                                                        ),
                                                        Text(
                                                          " สินค้า",
                                                          style:
                                                              GoogleFonts.kanit(
                                                            color: Colors.blue,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                          ),
                                                        ),
                                                        Container(
                                                          height: 10,
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top: 0, bottom: 10),
                                                child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      RatingBar.builder(
                                                        initialRating:
                                                            rating, //ดาวที่ได้
                                                        minRating: 1,
                                                        direction:
                                                            Axis.horizontal,
                                                        itemCount: 5,
                                                        ignoreGestures: true,
                                                        itemSize: 15,
                                                        allowHalfRating:
                                                            true, //ครึ่งดาว
                                                        itemPadding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 2),
                                                        itemBuilder:
                                                            (context, _) =>
                                                                Icon(
                                                          Icons.star,
                                                          color: Colors.orange,
                                                        ),
                                                        onRatingUpdate:
                                                            (kub) {},
                                                      ),
                                                      Row(
                                                        children: [
                                                          RatingBar.builder(
                                                            initialRating:
                                                                rating, //ดาวที่ได้
                                                            minRating: 1,
                                                            direction:
                                                                Axis.horizontal,
                                                            itemCount: 1,
                                                            ignoreGestures:
                                                                false,
                                                            itemSize: 15,
                                                            allowHalfRating:
                                                                true, //ครึ่งดาว
                                                            itemPadding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        2),
                                                            itemBuilder:
                                                                (context, _) =>
                                                                    Icon(
                                                              Icons.star,
                                                              color:
                                                                  Colors.orange,
                                                            ),
                                                            onRatingUpdate:
                                                                (you) {
                                                              if (mailx == 0) {
                                                                if (auth.currentUser
                                                                        ?.email !=
                                                                    snapshot.data
                                                                            .docs[index]
                                                                        [
                                                                        'email']) {
                                                                  showDialog<
                                                                      void>(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      return AlertDialog(
                                                                        title:
                                                                            const Text(
                                                                          'คะแนนรีวิว',
                                                                          style:
                                                                              TextStyle(fontWeight: FontWeight.bold),
                                                                        ),
                                                                        actions: <
                                                                            Widget>[
                                                                          Center(
                                                                            child:
                                                                                RatingBar.builder(
                                                                              initialRating: 0, //ดาวที่ได้
                                                                              minRating: 1,
                                                                              direction: Axis.horizontal,
                                                                              itemCount: 5,
                                                                              ignoreGestures: false,
                                                                              itemSize: 30, //ครึ่งดาว
                                                                              itemPadding: EdgeInsets.symmetric(horizontal: 2),
                                                                              itemBuilder: (context, _) => Icon(
                                                                                Icons.star,
                                                                                color: Colors.orange,
                                                                              ),
                                                                              onRatingUpdate: (kub) {
                                                                                subCollectionRef.add({
                                                                                  'email': auth.currentUser?.email,
                                                                                  'rating': kub,
                                                                                });
                                                                                Navigator.of(context).pop();
                                                                              },
                                                                            ),
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Container(height: 20)
                                                                            ],
                                                                          )
                                                                        ],
                                                                      );
                                                                    },
                                                                  );
                                                                }
                                                              }
                                                            },
                                                          ),
                                                          Text(
                                                            rating.toStringAsFixed(
                                                                    2) +
                                                                ('($ratingx)'),
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ],
                                                      )
                                                    ]),
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Row(
                                                children: [
                                                  Image.network(
                                                    "https://cdn.discordapp.com/attachments/846300874976133161/1076955671842541619/ezuelEWRrrIsW6VFUU7Gt91bR60AH6B8LHdB9n2M8DAAAAAElFTkSuQmCC.png",
                                                    height: 30,
                                                    width: 30,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    "  เวลาเปิด " +
                                                        snapshot.data
                                                                .docs[index]
                                                            ['time'] +
                                                        " น",
                                                    style: GoogleFonts.pridi(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Row(
                                                children: [
                                                  Image.network(
                                                    "https://cdn.discordapp.com/attachments/846300874976133161/1077647667972292669/844e8cd4ab26c82286238471f0e5a901.png",
                                                    height: 30,
                                                    width: 30,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    '  ' +
                                                        snapshot.data
                                                                .docs[index]
                                                            ['phone'],
                                                    style: GoogleFonts.pridi(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Image.network(
                                                    "https://cdn.discordapp.com/attachments/846300874976133161/1077651630012514436/4781517.png",
                                                    height: 30,
                                                    width: 30,
                                                  ),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  Flexible(
                                                    child: Text(snapshot
                                                            .data.docs[index]
                                                        ['address']),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              snapshot.data.docs[index]
                                                          ['lat'] ==
                                                      null
                                                  ? MyStyle().showProgress()
                                                  : showMap(),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            }),
                      ),
                    ),
                  );
                }
              }),
        ),
      ),
    );
  }
}
