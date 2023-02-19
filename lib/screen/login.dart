import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:loginsystem/model/profile.dart';
import 'package:loginsystem/screen/welcome.dart';
import 'package:loginsystem/screen/register.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  String _email = "";
  String _password = "";
  //

  //Profile profile = Profile();
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
                          _forgotPassword(context),
                          _signup(context),
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
          height: 30,
        ),
        Image.network(
          "https://cdn.discordapp.com/attachments/826134815375229008/1074920369347113030/fresh-vegetables-logo-A10D7349C9-seeklogo.png",
          height: 300,
          width: 300,
        ),
        //Image.asset("assets/images/logo.png"),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }

  _inputField(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          decoration: InputDecoration(
              hintText: "Username",
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
          height: 15,
        ),
        TextFormField(
          validator: RequiredValidator(errorText: "กรุณาป้อนรหัสผ่านด้วยครับ"),
          obscureText: true,
          onSaved: (password) {
            _password = password ?? "";
          },
          decoration: InputDecoration(
            hintText: "Password",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none),
            fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
            filled: true,
            prefixIcon: Icon(Icons.key),
          ),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async {
            if (formKey.currentState?.validate() ?? false) {
              formKey.currentState?.save();
              try {
                await FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                        email: _email, password: _password)
                    .then((value) {
                  formKey.currentState?.reset();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return WelcomeScreen();
                  }));
                });
              } on FirebaseAuthException catch (e) {
                Fluttertoast.showToast(
                    msg: e.message ?? "", gravity: ToastGravity.CENTER);
              }
            }
          },
          child: Text(
            "                               Login                               ",
            style: TextStyle(fontSize: 20),
          ),
          style: ElevatedButton.styleFrom(
            shape: StadiumBorder(),
            padding: EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ],
    );
  }

  _forgotPassword(context) {
    return TextButton(onPressed: () {}, child: Text("Forgot password?"));
  }

  _signup(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Dont have an account? "),
        TextButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return RegisterScreen();
              }));
            },
            child: Text("Sign Up"))
      ],
    );
  }
}
