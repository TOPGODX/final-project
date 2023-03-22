import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:loginsystem/screen/editScreen.dart';

import 'package:loginsystem/screen/itemPage.dart';
import 'package:loginsystem/screen/login.dart';
import 'package:loginsystem/screen/NavBar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:loginsystem/model/data.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loginsystem/screen/editproduct.dart';
import 'package:loginsystem/screen/welcome.dart';

class EditScreen extends StatefulWidget {
  @override
  _EditScreen createState() => _EditScreen();
}

class _EditScreen extends State<EditScreen> {
  final auth = FirebaseAuth.instance;
  int top;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: Text(
          "แก้ไข้สินค้า",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
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
                        // return ShowListView(index);

                        return SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 0),
                            child: Column(children: [
                              if (auth.currentUser?.email ==
                                  snapshot.data.docs[index]['email'])
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Container(
                                    width: 380,
                                    height: 130,
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
                                              snapshot.data.docs[index]['url'],
                                              height: 120,
                                              width: 100,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Container(
                                          width: 140,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Text(
                                                snapshot.data.docs[index]
                                                    ['name'],
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
                                                        snapshot.data
                                                                .docs[index]
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
                                            ],
                                          ),
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 0,
                                            ),
                                            PopupMenuButton(
                                              itemBuilder: (context) {
                                                return [
                                                  PopupMenuItem(
                                                    value: 'add',
                                                    child: ListTile(
                                                      leading: Icon(Icons.add),
                                                      iconColor: Colors.green,
                                                      title: Text('Product'),
                                                    ),
                                                  ),
                                                  PopupMenuItem(
                                                    value: 'edit',
                                                    child: ListTile(
                                                      leading: Icon(Icons.edit),
                                                      iconColor: Colors.blue,
                                                      title: Text('Edit'),
                                                    ),
                                                  ),
                                                  PopupMenuItem(
                                                    value: 'delete',
                                                    child: ListTile(
                                                      leading:
                                                          Icon(Icons.delete),
                                                      iconColor: Colors.red,
                                                      title: Text('Delete'),
                                                    ),
                                                  )
                                                ];
                                              },
                                              onSelected: (String value) {
                                                if (value == 'add') {
                                                  Navigator.of(context)
                                                      .push(MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        Editpro(
                                                            snapshot.data
                                                                .docs[index].id,
                                                            index),
                                                  ));
                                                }
                                                if (value == 'edit') {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          Edit(index),
                                                    ),
                                                  );
                                                }
                                                if (value == 'delete') {
                                                  showDialog<String>(
                                                    context: context,
                                                    builder: (BuildContext
                                                            context) =>
                                                        AlertDialog(
                                                      title: const Text(
                                                          'แจ้งเตือน'),
                                                      content: const Text(
                                                          'ต้องจะลบหรือไม่'),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context,
                                                                  'Cancel'),
                                                          child: const Text(
                                                              'ยกเลิก'),
                                                        ),
                                                        TextButton(
                                                          child: const Text(
                                                              'ตกลง'),
                                                          onPressed: () => {
                                                            delete(snapshot
                                                                .data
                                                                .docs[index]
                                                                .id),
                                                            Navigator.pop(
                                                                context,
                                                                'ตกลง'),
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }
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
    );
  }
}

void delete(id) {
  FirebaseFirestore.instance.collection("Producr").doc(id).delete();
}
