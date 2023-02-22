import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:loginsystem/screen/welcome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loginsystem/screen/NavBar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loginsystem/screen/my_Style.dart';
import 'package:clippy_flutter/clippy_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class ResultPage extends StatelessWidget {
  final int index;
  ResultPage(this.index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                  print(snapshot.data.docs[index]['name']);

                  Set<Marker> myMarker() {
                    return <Marker>[
                      Marker(
                          markerId: MarkerId(snapshot.data.docs[index]['name']),
                          position: LatLng(snapshot.data.docs[index]['lat'],
                              snapshot.data.docs[index]['lng']),
                          infoWindow: InfoWindow(
                            title: snapshot.data.docs[index]['name'],
                            snippet: 'เวลาเปิดปิด ' +
                                snapshot.data.docs[index]['time'] +
                                ' น.',
                          ))
                    ].toSet();
                  }

                  Container showMap() {
                    LatLng latLng = LatLng(snapshot.data.docs[index]['lat'],
                        snapshot.data.docs[index]['lng']);
                    CameraPosition cameraPosition =
                        CameraPosition(target: latLng, zoom: 15.0);
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
                          color: Color.fromARGB(255, 253, 253, 253),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: 0,
                                    bottom: 0,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        snapshot.data.docs[index]['name'],
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 0, bottom: 10),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        RatingBar.builder(
                                          initialRating: 4.5, //ดาวที่ได้
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          itemCount: 5,
                                          ignoreGestures: false,
                                          itemSize: 15,
                                          allowHalfRating: true, //ครึ่งดาว
                                          itemPadding: EdgeInsets.symmetric(
                                              horizontal: 2),
                                          itemBuilder: (context, _) => Icon(
                                            Icons.star,
                                            color: Colors.orange,
                                          ),
                                          onRatingUpdate: (top) {
                                            print(top);
                                          },
                                        ),
                                        Text(
                                          " ( 4.5 ) ",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
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
                                          snapshot.data.docs[index]['time'] +
                                          " น",
                                      style: GoogleFonts.pridi(
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal,
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
                                      '  ' + snapshot.data.docs[index]['phone'],
                                      style: GoogleFonts.pridi(
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                      child: Text(
                                          snapshot.data.docs[index]['address']),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                snapshot.data.docs[index]['lat'] == null
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
}
