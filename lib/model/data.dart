import 'package:equatable/equatable.dart';

class ProducrModel {
  String nameshop;
  String address;
  String detail;
  String urlpic;

  ProducrModel(
    this.nameshop,
    this.address,
    this.detail,
    this.urlpic,
  );
  ProducrModel.fromMap(Map<String, dynamic> map) {
    nameshop = map['name'];
    address = map['address'];
    detail = map['detail'];
    urlpic = map['url'];
  }
}
