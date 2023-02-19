import 'package:equatable/equatable.dart';

class Subject extends Equatable {
  final String nameshop;
  final String address;
  final String detail;

  const Subject({
    required this.nameshop,
    required this.address,
    required this.detail,
  });

  @override
  List<Object?> get props => [nameshop, address, detail];
}
