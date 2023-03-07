import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:loginsystem/model/profile.dart';
import 'package:loginsystem/screen/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();

  //Profile profile = Profile();
  String _username = "";
  String _email = "";
  String _password = "";
  String rool;
  String email = "";
  String selectedItem;
  List<String> Listx = ['User', 'Seller'];
  String validateDropdownValue(String value) {
    if (value == null) {
      return 'กรุณาเลือกผู้ใช้';
    }
    return null;
  }

  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Error"),
              ),
              body: Center(
                child: Text("${snapshot.error}"),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              body: Container(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _header(context),
                          _inputField(context),
                          // _forgotPassword(context),
                          _Login(context),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }

  _header(context) {
    return Column(
      children: [
        SizedBox(
          height: 35,
        ),
        Text(
          "Sign Up",
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 35,
        ),
      ],
    );
  }

  _inputField(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Username", style: TextStyle(fontSize: 15)),
        SizedBox(
          height: 10,
        ),
        TextFormField(
          decoration: InputDecoration(
              hintText: "Username",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none),
              fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
              filled: true,
              prefixIcon: Icon(Icons.person)),
          onSaved: (String username) {
            _username = username ?? "";
          },
        ),
        SizedBox(
          height: 20,
        ),
        Text("Email", style: TextStyle(fontSize: 15)),
        SizedBox(
          height: 10,
        ),
        TextFormField(
          decoration: InputDecoration(
              hintText: "email",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none),
              fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
              filled: true,
              prefixIcon: Icon(Icons.email)),
          validator: MultiValidator([
            RequiredValidator(errorText: "กรุณาป้อนอีเมลด้วยครับ"),
            EmailValidator(errorText: "รูปแบบอีเมลไม่ถูกต้อง")
          ]),
          keyboardType: TextInputType.emailAddress,
          onSaved: (email) {
            _email = email ?? "";
          },
        ),
        SizedBox(
          height: 20,
        ),
        Text("Password", style: TextStyle(fontSize: 15)),
        SizedBox(
          height: 10,
        ),
        TextFormField(
          decoration: InputDecoration(
            hintText: "Password",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none),
            fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
            filled: true,
            prefixIcon: Icon(Icons.key),
          ),
          validator: RequiredValidator(errorText: "กรุณาป้อนรหัสผ่านด้วยครับ"),
          obscureText: true,
          onSaved: (password) {
            _password = password ?? "";
          },
        ),
        SizedBox(
          height: 10,
        ),
        Text("User", style: TextStyle(fontSize: 15)),
        DropdownButton<String>(
          isExpanded: true,
          style: TextStyle(
              color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
          hint: new Text(
            "  ข้อมูลผู้ใช้",
            style: TextStyle(
                color: Color.fromARGB(255, 2, 0, 0),
                fontWeight: FontWeight.normal,
                fontSize: 15),
          ),
          value: rool,
          items: Listx.map((gender) {
            return DropdownMenuItem<String>(
              value: gender,
              child: Text(gender),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              rool = value;
              print(rool);
            });
          },
        ),
        SizedBox(
          height: 35,
        ),
        Center(
          child: ElevatedButton(
              child: Text(
                "                               Sign Up                               ",
                style: TextStyle(fontSize: 20),
              ),
              style: ElevatedButton.styleFrom(
                shape: StadiumBorder(),
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () async {
                if (rool == null) {
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
                  if (formKey.currentState?.validate() ?? false) {
                    formKey.currentState?.save();
                    try {
                      await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                              email: _email, password: _password)
                          .then((value) => {
                                postDetailsToFirestore(_username, rool),
                                formKey.currentState?.reset(),
                                Fluttertoast.showToast(
                                    msg: "สร้างบัญชีผู้ใช้เรียบร้อยแล้ว",
                                    gravity: ToastGravity.TOP),
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) {
                                  return LoginScreen();
                                })),
                              });
                    } on FirebaseAuthException catch (e) {
                      print(e.code);
                      String message;
                      if (e.code == 'email-already-in-use') {
                        message =
                            "มีอีเมลนี้ในระบบแล้วครับ โปรดใช้อีเมลอื่นแทน";
                      } else if (e.code == 'weak-password') {
                        message = "รหัสผ่านต้องมีความยาว 6 ตัวอักษรขึ้นไป";
                      } else {
                        message = e.message ?? "";
                      }
                      Fluttertoast.showToast(
                          msg: message, gravity: ToastGravity.CENTER);
                    }
                  }
                }
              }),
        ),
      ],
    );
  }

  _Login(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Already have an account? "),
        TextButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return LoginScreen();
              }));
            },
            child: Text("Login"))
      ],
    );
  }

  postDetailsToFirestore(String email, String rool) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    CollectionReference ref = FirebaseFirestore.instance.collection('users');
    ref.doc(_email).set({'user': _username, 'rool': rool});
  }
}
