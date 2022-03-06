import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';

import 'package:bigpay_app003/amplifyconfiguration.dart';
import 'package:flutter/widgets.dart';

class AppConfig {
  static AppConfig? _instance;

  factory AppConfig() {
    _instance ??= AppConfig._();
    return _instance!;
  }

  AppConfig._();

  static AppConfig? get instance => _instance;

  Future<void> initialiseApp() async {
    WidgetsFlutterBinding.ensureInitialized();

    await _configureAmplify();
  }

  Future<void> _configureAmplify() async {
    try {
      // Add the following line to add Auth plugin to your app.
      await Amplify.addPlugins([AmplifyAuthCognito(), AmplifyStorageS3()]);

      // call Amplify.configure to use the initialized categories in your app
      await Amplify.configure(amplifyconfig);
    } on Exception catch (e) {
      print('An error occurred configuring Amplify: $e');
    }
  }
}
