import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

/// Wraps AWS Amplify auth methods
class AuthService {
  AuthService({AuthCategory? amplifyAuth})
      : _amplifyAuth = amplifyAuth ?? Amplify.Auth;

  final AuthCategory _amplifyAuth;

  // Identity ID should always be present since Guest access has been enabled.
  Future<String?> getIdentityId() async {
    String? identityId;

    try {
      AuthSession res = await _amplifyAuth
          .fetchAuthSession(
            options: CognitoSessionOptions(getAWSCredentials: true),
          )
          .timeout(const Duration(seconds: 3));
      identityId = (res as CognitoAuthSession).identityId!;
    } on AuthException catch (_) {
      identityId = null;
    }

    return identityId;
  }
}
