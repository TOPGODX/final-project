import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:loginsystem/screen/login.dart';
import 'package:loginsystem/screen/welcome.dart';
import 'package:loginsystem/screen/add.dart';
import 'package:google_fonts/google_fonts.dart';


class NavBar extends StatelessWidget {
  @override
  final auth = FirebaseAuth.instance;
  Widget build(BuildContext context) {
    return Drawer(
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
            title: Text(
              auth.currentUser.email,
              textAlign: TextAlign.start,  
            textDirection: TextDirection.ltr,
            style: GoogleFonts.oswald( fontWeight: FontWeight.bold,
                  fontSize: 18,)
             
            ),
            onTap: () => null,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.store, color: Colors.red.shade400),
            title: Text(
              'Show List',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'แสดงรายการ',
              style: TextStyle(
                color: Colors.grey ,
              ),
            ),
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return WelcomeScreen();
              }));
            },
          ),
          ListTile(
            leading: Icon(Icons.add_circle, color: Colors.green.shade400),
            title: Text(
              'Add Shop',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'เพิ่มรายการ',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return addscreen();
              }));
            },
          ),
          ListTile(
            leading: Icon(Icons.info, color: Colors.blue.shade400),
            title: Text(
              'information',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'เพิ่มเพิ่มตำหน่ง',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            onTap: () => null,
          ),
          Divider(),
          ListTile(
            title: Text('Exit'),
            leading: Icon(Icons.exit_to_app, color: Colors.yellow.shade400),
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
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
