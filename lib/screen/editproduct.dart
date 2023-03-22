import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:loginsystem/screen/addxproduct.dart';
import 'package:loginsystem/screen/welcome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loginsystem/screen/NavBar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loginsystem/screen/my_Style.dart';
import 'package:clippy_flutter/clippy_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class Editpro extends StatefulWidget {
  final String id;
  final int index;
  Editpro(this.id, this.index);
  @override
  State<Editpro> createState() {
    return _Editpro(this.id, this.index);
  }
}

class _Editpro extends State<Editpro> {
  final String id;
  final int index;

  _Editpro(this.id, this.index);

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
                  .collection('Producrx')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  print('xcxzcz');
                  return Text("Loading.....");
                } else {
                  double sumOfCreditMulSGPA = 0, sumOfCredit = 0;
                  double rating = 0.0;

                  print(snapshot.data.docs.length);

                  print(rating);

                  return Container(
                    child: ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (BuildContext buildContext, int top) {
                        print(snapshot.data.docs[top]['name']);
                        //return Container();
                        // return ShowListView(index);

                        return SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            child: Column(children: [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Container(
                                  width: 380,
                                  height: 120,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 5,
                                      ),
                                      InkWell(
                                        onTap: () {},
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Image.network(
                                            snapshot.data.docs[top]['url'],
                                            height: 100,
                                            width: 100,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 30,
                                      ),
                                      Container(
                                        width: 140,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              snapshot.data.docs[top]['name'],
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.taviraj(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
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
                                                  '${snapshot.data.docs[top]['price']}' +
                                                      '   บาท',
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.pridi(
                                                    color: Colors.black,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 0,
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete),
                                            color: Colors.red,
                                            onPressed: () {
                                              showDialog<String>(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        AlertDialog(
                                                  title:
                                                      const Text('แจ้งเตือน'),
                                                  content: const Text(
                                                      'ต้องจะลบหรือไม่'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(context,
                                                              'Cancel'),
                                                      child:
                                                          const Text('ยกเลิก'),
                                                    ),
                                                    TextButton(
                                                      child: const Text('ตกลง'),
                                                      onPressed: () => {
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'Producr')
                                                            .doc(id)
                                                            .collection(
                                                                'Producrx')
                                                            .doc(snapshot.data
                                                                .docs[top].id)
                                                            .delete(),
                                                        Navigator.pop(
                                                            context, 'ตกลง'),
                                                      },
                                                    ),
                                                  ],
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
                    ),
                  );
                }
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => Addproscreen(id, index),
          ));
        },
        label: const Text('Add'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.lightGreen,
      ),
    );
  }
}
