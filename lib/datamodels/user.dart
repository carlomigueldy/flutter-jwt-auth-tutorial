import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(
  nullable: false,
  fieldRename: FieldRename.snake,
)
class User {
  final int id;
  final String firstName;
  final String middleName;
  final String lastName;
  final String email;

  User({
    this.id,
    this.firstName = "",
    this.middleName = "",
    this.lastName = "",
    this.email = "",
  });
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
