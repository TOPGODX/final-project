import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:loginsystem/screen/my_Style.dart';
import 'package:loginsystem/screen/welcome.dart';
import 'package:loginsystem/screen/NavBar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class addscreen extends StatefulWidget {
  @override
  _addscreen createState() => _addscreen();
}

class _addscreen extends State<addscreen> {
  File file;

  double lat, lng;

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

  String nameshop = "",
      address = "",
      detail = "",
      urlpic = "",
      time = "",
      phone = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavBar(),
        appBar: AppBar(
          title: Text(
            "เพิ่มร้านค้า",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                _image(context),
                _maker(context),
              ],
            ),
          ),
        ));
  }

  final myStyle = TextStyle(fontWeight: FontWeight.w600, fontSize: 22);
  _image(context) {
    return Column(
      children: <Widget>[
        Text(
          "เพิ่มรูปร้าน",
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
                          "https://cdn.discordapp.com/attachments/846300874976133161/1076429263412142100/396915-200.png",
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
          "รายละเอียดร้าน",
          style: TextStyle(fontSize: 20),
        ),
        Container(height: 20),
      ],
    );
  }

  Future<void> uplodPictuer() async {
    final file = this.file;
    if (file == null) return;
    Random random = Random();
    int i = random.nextInt(10000);
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref =
        storage.ref().child("shop/producr$i.jng" + DateTime.now().toString());
    UploadTask uploadTask = ref.putFile(file);
    urlpic = await (await uploadTask).ref.getDownloadURL();
    print('url = $urlpic');
    insertValue();
  }

  Future<void> insertValue() async {
    Map<String, dynamic> map = Map();
    map['name'] = nameshop;
    map['address'] = address;
    map['detail'] = detail;
    map['url'] = urlpic;
    map['time'] = time;
    map['lat'] = lat;
    map['lng'] = lng;
    map['phone'] = phone;

    final top = FirebaseFirestore.instance
        .collection("Producr")
        .doc()
        .set(map)
        .then((value) {
      print('object');
      MaterialPageRoute route = MaterialPageRoute(
        builder: (value) => WelcomeScreen(),
      );
      Navigator.of(context).pushAndRemoveUntil(route, (value) => false);
    });
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

  Set<Marker> myMarker() {
    return <Marker>[
      Marker(
          markerId: MarkerId(nameshop),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(
            title: nameshop,
            snippet: 'ละติจูด =$lat,ลองติจูด =$lng',
          ))
    ].toSet();
  }

  Container showMap() {
    LatLng latLng = LatLng(lat, lng);
    CameraPosition cameraPosition = CameraPosition(target: latLng, zoom: 16.0);
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

  _maker(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
            onChanged: (value) => nameshop = value.trim(),
            decoration: InputDecoration(
              labelText: "ชื่อร้านอาหาร", //babel text

              prefixIcon:
                  Icon(Icons.store, color: Colors.green.shade400), //prefix iocn

              labelStyle: TextStyle(fontSize: 13, color: Colors.redAccent),
              border: OutlineInputBorder(),
            )),

        Container(height: 20), //space between text field

        TextFormField(
            onChanged: (value) => detail = value.trim(),
            decoration: InputDecoration(
              labelText: "รายละเอียด", //babel text

              prefixIcon: Icon(Icons.details_sharp,
                  color: Colors.green.shade400), //prefix iocn

              labelStyle: TextStyle(fontSize: 13, color: Colors.redAccent),
              border: OutlineInputBorder(), //label style
            )),

        Container(height: 20), //space between text field

        TextFormField(
            onChanged: (value) => address = value.trim(),
            decoration: InputDecoration(
              labelText: "ที่อยู่ร้าน", //babel text

              prefixIcon: Icon(Icons.maps_ugc_sharp,
                  color: Colors.green.shade400), //prefix iocn

              labelStyle: TextStyle(fontSize: 13, color: Colors.redAccent),
              border: OutlineInputBorder(), //label style
            )),
        Container(height: 20), //space between text field
        TextFormField(
            onChanged: (value) => phone = value.trim(),
            decoration: InputDecoration(
              labelText: "เบอร์โทร", //babel text

              prefixIcon:
                  Icon(Icons.phone, color: Colors.green.shade400), //prefix iocn

              labelStyle: TextStyle(fontSize: 13, color: Colors.redAccent),
              border: OutlineInputBorder(), //label style
            )),
        Container(height: 20), //space between text field
        TextFormField(
            onChanged: (value) => time = value.trim(),
            decoration: InputDecoration(
              labelText: "เวลาเปิดปิด", //babel text

              prefixIcon: Icon(Icons.lock_clock,
                  color: Colors.green.shade400), //prefix iocn

              labelStyle: TextStyle(fontSize: 13, color: Colors.redAccent),
              border: OutlineInputBorder(), //label style
            )),

        Container(height: 20),
        lat == null ? MyStyle().showProgress() : showMap(),

        Container(height: 20),
        Container(
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton.icon(
            onPressed: () {
              if (file == null) {
                final snackBar = SnackBar(
                  /// need to set following properties for best effect of awesome_snackbar_content
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.transparent,
                  content: AwesomeSnackbarContent(
                    title: '!! แจ้งเตือน !!',
                    message: 'กรุณาอัพโหลดรูปภาพให้เรียบร้อย',

                    /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                    contentType: ContentType.failure,
                  ),
                );
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(snackBar);
              } else if (nameshop == null ||
                  nameshop.isEmpty ||
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
                uplodPictuer();
                // insertValue();
              }
            },
            icon: Icon(Icons.save),
            label: Text('Save'),
          ),
        )
      ],
    );
  }
}
