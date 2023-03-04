import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:loginsystem/model/profile.dart';
import 'package:loginsystem/screen/edit.dart';
import 'package:loginsystem/screen/my_Style.dart';
import 'package:loginsystem/screen/editproduct.dart';
import 'package:loginsystem/screen/welcome.dart';
import 'package:loginsystem/screen/NavBar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class Edit extends StatefulWidget {
  final int index;
  Edit(this.index);
  @override
  State<Edit> createState() {
    return _Editx(this.index);
  }
}

class _Editx extends State<Edit> {
  final int index;
  double lat, lng;
  _Editx(this.index);
  String time;
  File file;

  @override
  void initState() {
    super.initState();

    findlaglng();
  }

  Future<Null> findlaglng() async {
    print('xxxxx');
    LocationData locationData = await locationDatax();
    setState(() {
      lat = locationData.latitude;
      lng = locationData.longitude;
    });

    print('lat =$lat,lng = $lng');
  }

  Future<LocationData> locationDatax() async {
    Location location = Location();
    try {
      print('xxxxx');
      return location.getLocation();
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: Center(
                child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection("Producr").snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  print('xcxzcz');
                  return Text("Loading.....");
                } else {}
                String name = snapshot.data.docs[index]['name'];
                String address = snapshot.data.docs[index]['address'];
                String detail = snapshot.data.docs[index]['detail'];
                String phone = snapshot.data.docs[index]['phone'];
                String time = snapshot.data.docs[index]['time'];

                TextEditingController _name;
                _name = TextEditingController(text: name);
                TextEditingController _detail;
                _detail = TextEditingController(text: detail);
                TextEditingController _time;
                _time = TextEditingController(text: time);
                TextEditingController _phone;
                _phone = TextEditingController(text: phone);
                TextEditingController _address;
                _address = TextEditingController(text: address);

                Set<Marker> myMarker() {
                  return <Marker>[
                    Marker(
                        markerId: MarkerId(name),
                        position: LatLng(lat, lng),
                        infoWindow: InfoWindow(
                          title: name,
                          snippet: 'ละติจูด =$lat,ลองติจูด =$lng',
                        ))
                  ].toSet();
                }

                Container showMap() {
                  LatLng latLng = LatLng(lat, lng);
                  CameraPosition cameraPosition =
                      CameraPosition(target: latLng, zoom: 16.0);
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

                return Column(
                  children: [
                    Text(
                      "แก้ไข้รูป",
                      style: TextStyle(fontSize: 20),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                            icon: Icon(Icons.add_a_photo),
                            onPressed: () => chooseImage(ImageSource.camera)),
                        Builder(builder: (context) {
                          final file = this.file;
                          return Container(
                              width: 200,
                              height: 200,
                              child: file == null
                                  ? Image.network(
                                      snapshot.data.docs[index]['url'],
                                      height: 300,
                                      width: 300,
                                    )
                                  : Image.file(
                                      file,
                                    ));
                        }),
                        IconButton(
                            icon: Icon(Icons.add_photo_alternate),
                            onPressed: () => chooseImage(ImageSource.gallery)),
                      ],
                    ),
                    Container(height: 20),
                    Text(
                      "แก้ไขรายละเอียดร้าน",
                      style: TextStyle(fontSize: 20),
                    ),
                    Container(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(height: 20), //space between text field
                        TextFormField(
                            controller: _name,
                            decoration: InputDecoration(
                              labelText: "ชื่อร้านอาหาร", //babel text

                              prefixIcon: Icon(Icons.store,
                                  color: Colors.green.shade400), //prefix iocn

                              labelStyle: TextStyle(
                                  fontSize: 13, color: Colors.redAccent),
                              border: OutlineInputBorder(), //label style
                            )),
                        Container(height: 20), //space between text field
                        TextFormField(
                            controller: _detail,
                            decoration: InputDecoration(
                              labelText: "รายละเอียด", //babel text

                              prefixIcon: Icon(Icons.details_sharp,
                                  color: Colors.green.shade400), //prefix iocn

                              labelStyle: TextStyle(
                                  fontSize: 13, color: Colors.redAccent),
                              border: OutlineInputBorder(), //label style
                            )),
                        Container(height: 20), //space between text field
                        TextFormField(
                            controller: _address,
                            decoration: InputDecoration(
                              labelText: "ที่อยู่ร้าน", //babel text

                              prefixIcon: Icon(Icons.maps_ugc_sharp,
                                  color: Colors.green.shade400), //prefix iocn

                              labelStyle: TextStyle(
                                  fontSize: 13, color: Colors.redAccent),
                              border: OutlineInputBorder(), //label style
                            )),
                        Container(height: 20), //space between text field
                        TextFormField(
                            controller: _phone,
                            decoration: InputDecoration(
                              labelText: "เบอร์โทร", //babel text

                              prefixIcon: Icon(Icons.phone,
                                  color: Colors.green.shade400), //prefix iocn

                              labelStyle: TextStyle(
                                  fontSize: 13, color: Colors.redAccent),
                              border: OutlineInputBorder(), //label style
                            )),
                        Container(height: 20), //space between text field
                        TextFormField(
                            controller: _time,
                            decoration: InputDecoration(
                              labelText: "เวลาเปิดปิด", //babel text

                              prefixIcon: Icon(Icons.lock_clock,
                                  color: Colors.green.shade400), //prefix iocn

                              labelStyle: TextStyle(
                                  fontSize: 13, color: Colors.redAccent),
                              border: OutlineInputBorder(), //label style
                            )),

                        Container(height: 20),
                        lat == null ? MyStyle().showProgress() : showMap(),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              if (name == null ||
                                  name.isEmpty ||
                                  address == null ||
                                  address.isEmpty ||
                                  detail == null ||
                                  detail.isEmpty ||
                                  time == null ||
                                  time.isEmpty ||
                                  phone == null ||
                                  phone.isEmpty) {
                                final snackBar = SnackBar(
                                  /// need to set following properties for best effect of awesome_snackbar_content
                                  elevation: 0,
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.transparent,
                                  content: AwesomeSnackbarContent(
                                    title: '!! แจ้งเตือน !!',
                                    message: 'กรุณากรอบข้อมูลให้ครบ !!',

                                    /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                    contentType: ContentType.failure,
                                  ),
                                );
                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(snackBar);
                              } else {
                                Map<String, dynamic> map = Map();
                                map['name'] = _name.text;
                                map['address'] = _address.text;
                                map['detail'] = _detail.text;
                                map['time'] = _time.text;
                                map['lat'] = lat;
                                map['lng'] = lng;
                                map['phone'] = _phone.text;

                                FirebaseFirestore.instance
                                    .collection("Producr")
                                    .doc(snapshot.data.docs[index].id)
                                    .update(map);

                                MaterialPageRoute route = MaterialPageRoute(
                                  builder: (value) => EditScreen(),
                                );
                                Navigator.of(context).pushAndRemoveUntil(
                                    route, (value) => false);
                              }

                              // insertValue();
                            },
                            icon: Icon(Icons.save),
                            label: Text('edit'),
                          ),
                        )
                      ],
                    ),
                  ],
                );
              },
            )),
          ),
        ));
  }

  Future<Null> chooseImage(ImageSource source) async {
    try {
      var object = await ImagePicker()
          .getImage(source: source, maxHeight: 800.0, maxWidth: 800.0);
      setState(() {
        file = File(object?.path ?? "");
      });
    } catch (e) {}
  }
}
