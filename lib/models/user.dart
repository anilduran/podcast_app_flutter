import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {

  final String id;
  final String username;
  final String email;
  final String? profilePhotoUrl;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.profilePhotoUrl
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);


}