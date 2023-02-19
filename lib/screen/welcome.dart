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
  final auth = FirebaseAuth.instance;
  @override
  void initStare() {
    super.initState();
    readAllData();
  }
  
  Future<Void> readAllData() {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    CollectionReference collectionReference =
    FirebaseFirestore.instance.collection("subject");
    collectionReference.snapshots().listen((response){
      
    List<DocumentSnapshot> snapshots = response.docs;
    
    for (var snapshot in snapshots) {
      print('snapshot = $snapshot');
      Map<String, dynamic> data = snapshot.data()! as Map<String, dynamic>;
     
  
    }
    

    });
  }

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
          child: Column(
            children: [],
          ),
        ),
      ),
    );
  }
}
