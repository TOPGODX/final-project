import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:loginsystem/screen/login.dart';
import 'package:loginsystem/screen/NavBar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreen createState() => _WelcomeScreen();
}

class _WelcomeScreen extends State<WelcomeScreen> {
  final Stream<QuerySnapshot> _subjectStream =
      FirebaseFirestore.instance.collection('subject').snapshots();
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: Text("                  MARKET SHOP",
            textDirection: TextDirection.ltr,
            style: GoogleFonts.oswald(
              fontWeight: FontWeight.normal,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: StreamBuilder<QuerySnapshot>(
              stream: _subjectStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading");
                }
                return Column(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  print(data['name']);
                  return Text(data['name']);
                }).toList());
              }),
        ),
      ),
    );
  }
}
