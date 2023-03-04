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
import 'package:loginsystem/screen/editproduct.dart';
import 'package:loginsystem/screen/welcome.dart';
import 'package:loginsystem/screen/NavBar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class Addproscreen extends StatefulWidget {
  final String id;
  final int index;
  Addproscreen(this.id, this.index);
  @override
  State<Addproscreen> createState() {
    return _Addproscreen(this.id, this.index);
  }
}

class _Addproscreen extends State<Addproscreen> {
  final String id;
  final int index;
  _Addproscreen(this.id, this.index);

  File file;

  String nameshop = "", urlpic = "", price = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavBar(),
        appBar: AppBar(
          title: Text(
            "เพิ่มรูปสินค้า",
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
    final mainCollectionRef = FirebaseFirestore.instance.collection('Producr');
    final mainDocRef = mainCollectionRef.doc(id);
    final subCollectionRef = mainDocRef.collection('Producrx');
    subCollectionRef.add({
      'name': nameshop,
      'price': price,
      'url': urlpic,
    });
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return Editpro(id, index);
    }));
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

        Container(height: 20), //space between text field
        TextFormField(
            onChanged: (value) => price = value.trim(),
            decoration: InputDecoration(
              labelText: "ราคา", //babel text

              prefixIcon: Icon(Icons.attach_money,
                  color: Colors.green.shade400), //prefix iocn

              labelStyle: TextStyle(fontSize: 13, color: Colors.redAccent),
              border: OutlineInputBorder(), //label style
            )),

        Container(height: 20),

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
                  price == null ||
                  price.isEmpty) {
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
