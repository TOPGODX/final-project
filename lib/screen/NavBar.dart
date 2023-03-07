import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:loginsystem/screen/login.dart';
import 'package:loginsystem/screen/showpro.dart';
import 'package:loginsystem/screen/welcome.dart';
import 'package:loginsystem/screen/edit.dart';
import 'package:loginsystem/screen/add.dart';
import 'package:google_fonts/google_fonts.dart';

class NavBar extends StatelessWidget {
  @override
  final auth = FirebaseAuth.instance;

  Widget build(BuildContext context) {
    return new StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(auth.currentUser?.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return new Text("Loading");
          }
          var userDocument = snapshot.data;

          return Drawer(
            backgroundColor: Color.fromARGB(239, 243, 243, 243),
            child: ListView(
              // Remove padding
              padding: EdgeInsets.zero,
              children: [
                Divider(),
                ListTile(
                  leading: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: 35,
                      minHeight: 35,
                      maxWidth: 55,
                      maxHeight: 55,
                    ),
                    child: Image.network(
                        "https://cdn.discordapp.com/attachments/780359466792386582/1074924286130794576/694px-Unknown_person.png",
                        fit: BoxFit.cover),
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(userDocument["user"],
                          textAlign: TextAlign.start,
                          textDirection: TextDirection.ltr,
                          style: GoogleFonts.itim(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          )),
                      Text(auth.currentUser?.email,
                          textAlign: TextAlign.start,
                          textDirection: TextDirection.ltr,
                          style: GoogleFonts.itim(
                              fontSize: 18,
                              color: Color.fromARGB(238, 90, 89, 89),
                              fontWeight: FontWeight.normal)),
                    ],
                  ),
                  onTap: () => null,
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.store, color: Colors.red),
                  title: Text(
                    'Show Shop',
                    style: GoogleFonts.itim(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'แสดงร้านค้า',
                    style: GoogleFonts.mitr(
                        color: Color.fromARGB(238, 90, 89, 89),
                        fontWeight: FontWeight.normal),
                  ),
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return WelcomeScreen();
                    }));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.production_quantity_limits,
                      color: Colors.green),
                  title: Text(
                    'Show Product',
                    style: GoogleFonts.itim(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'แสดงสินค้า',
                    style: GoogleFonts.mitr(
                      color: Color.fromARGB(238, 90, 89, 89),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return Showpro();
                    }));
                  },
                ),
                if (userDocument["rool"] == 'Seller')
                  ListTile(
                    leading: Icon(Icons.add_circle, color: Colors.blue),
                    title: Text(
                      'Add Shop',
                      style: GoogleFonts.itim(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'เพิ่มรายการ',
                      style: GoogleFonts.mitr(
                        color: Color.fromARGB(238, 90, 89, 89),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    onTap: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return addscreen();
                      }));
                    },
                  ),
                if (userDocument["rool"] == 'Seller')
                  ListTile(
                    leading: Icon(Icons.info, color: Colors.pink),
                    title: Text(
                      'information',
                      style: GoogleFonts.itim(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'แก้ไขข้อมูล',
                      style: GoogleFonts.mitr(
                        color: Color.fromARGB(238, 90, 89, 89),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    onTap: () => {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return EditScreen();
                      })),
                    },
                  ),
                Divider(),
                ListTile(
                  title: Text('Exit',
                      style: GoogleFonts.itim(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                  leading: Icon(Icons.exit_to_app,
                      color: Color.fromARGB(255, 255, 163, 59)),
                  onTap: () {
                    auth.signOut().then((value) {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return LoginScreen();
                      }));
                    });
                  },
                  subtitle: Text(
                    'ออกจากระบบ',
                    style: GoogleFonts.mitr(
                      color: Color.fromARGB(238, 90, 89, 89),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
