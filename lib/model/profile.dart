import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  final String email;
  final String password;
  final String username;

  const Profile({
    required this.email,
    required this.password,
    required this.username,
  });

  @override
  List<Object?> get props => [email, password, username];
}
