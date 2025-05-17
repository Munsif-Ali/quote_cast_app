// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserSessionImpl _$$UserSessionImplFromJson(Map<String, dynamic> json) =>
    _$UserSessionImpl(
      isLoggedIn: json['isLoggedIn'] as bool,
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
      user: json['user'] == null
          ? null
          : UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$UserSessionImplToJson(_$UserSessionImpl instance) =>
    <String, dynamic>{
      'isLoggedIn': instance.isLoggedIn,
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'user': instance.user,
    };
