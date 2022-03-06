import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:bigpay_app003/services/auth.dart';
import 'package:path_provider/path_provider.dart';

/// Wraps S3 storage methods
class Storage {
  Storage({StorageCategory? amplifyStorage, AuthService? authService})
      : _amplifyStorage = amplifyStorage ?? Amplify.Storage,
        _authService = authService ?? AuthService();

  final StorageCategory _amplifyStorage;
  final AuthService _authService;

  /// Lists files under storage [path]. Throws on error
  Future<List<StorageItem>> listFiles(String path) async {
    try {
      final ListResult result = await _amplifyStorage.list(path: path);
      return result.items;
    } catch (_) {
      rethrow;
    }
  }

  /// Upload file, throws on error
  Future<void> uploadFile(File file, String uploadPath,
      UploadFileOptions? uploadFileOptions) async {
    try {
      await Amplify.Storage.uploadFile(
          local: file, key: uploadPath, options: uploadFileOptions);
    } catch (e) {
      rethrow;
    }
  }

  /// Download file, throws on error
  Future<File> downloadFile(String path) async {
    try {
      final documentsDir = await getTemporaryDirectory();
      final filepath = documentsDir.path + path;
      final file = File(filepath);

      await Amplify.Storage.downloadFile(
        key: path,
        local: file,
      );
      return file;
    } catch (e) {
      rethrow;
    }
  }
}
