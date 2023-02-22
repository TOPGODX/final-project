import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyStyle {
  Widget showProgress() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

Widget itemPage(BuildContext context) {
  return Scaffold(
    body: Padding(
      padding: EdgeInsets.only(top: 5),
      child: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Image.asset(
              'c',
              height: 300,
              width: 300,
            ),
          )
        ],
      ),
    ),
  );
}

class barwidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(CupertinoIcons.bars),
              ),
            )
          ],
        ));
  }
}
