// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthenticationResponse _$AuthenticationResponseFromJson(
    Map<String, dynamic> json) {
  return AuthenticationResponse(
    accessToken: json['access_token'] as String,
    tokenType: json['token_type'] as String,
    expiresAt: json['expires_at'] as String,
  );
}

Map<String, dynamic> _$AuthenticationResponseToJson(
        AuthenticationResponse instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'token_type': instance.tokenType,
      'expires_at': instance.expiresAt,
    };
