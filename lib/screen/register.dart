import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:loginsystem/model/profile.dart';
import 'package:loginsystem/screen/login.dart';



class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  Profile profile = Profile();
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
              onSaved: (String? username) {
             profile.username = username??"";
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
          onSaved: (String email) {
            profile.email = email;
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
          onSaved: (String password) {
            profile.password = password;
          },
        ),
        SizedBox(
          height: 35,
        ),
        ElevatedButton(
          child: Text(
            "                               Sign Up                               ",
            style: TextStyle(fontSize: 20),
          ),
          style: ElevatedButton.styleFrom(
            shape: StadiumBorder(),
            padding: EdgeInsets.symmetric(vertical: 16),
          ),
          onPressed: () async {
            if (formKey.currentState.validate()) {
              formKey.currentState.save();
              try {
                await FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                        email: profile.email, password: profile.password)
                    .then((value) {
                  formKey.currentState.reset();
                  Fluttertoast.showToast(
                      msg: "สร้างบัญชีผู้ใช้เรียบร้อยแล้ว",
                      gravity: ToastGravity.TOP);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return LoginScreen();
                  }));
                });
              } on FirebaseAuthException catch (e) {
                print(e.code);
                String message;
                if (e.code == 'email-already-in-use') {
                  message = "มีอีเมลนี้ในระบบแล้วครับ โปรดใช้อีเมลอื่นแทน";
                } else if (e.code == 'weak-password') {
                  message = "รหัสผ่านต้องมีความยาว 6 ตัวอักษรขึ้นไป";
                } else {
                  message = e.message;
                }
                Fluttertoast.showToast(
                    msg: message, gravity: ToastGravity.CENTER);
              }
            }
          },
        ),
      ],
    );
  }

  _Login(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Already have an account? "),
        TextButton(onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context){
                          return LoginScreen();
                      })
                    );
                  }, child: Text("Login"))
      ],
    );
  }
}
