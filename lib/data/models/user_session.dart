import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:quote_cast_app/data/models/user_model.dart';

part 'user_session.freezed.dart';
part 'user_session.g.dart';

@freezed
class UserSession with _$UserSession {
  const factory UserSession({
    required bool isLoggedIn,
    String? accessToken,
    String? refreshToken,
    UserModel? user,
  }) = _UserSession;

  factory UserSession.loggedOut() => const UserSession(isLoggedIn: false);

  factory UserSession.fromJson(Map<String, dynamic> json) =>
      _$UserSessionFromJson(json);
}
