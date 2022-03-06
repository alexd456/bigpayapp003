import 'dart:convert';
import 'dart:io';

import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:bigpay_app003/data/storage.dart';
import 'package:bigpay_app003/models/julia_set_viewer_params.dart';
import 'package:bigpay_app003/services/auth.dart';
import 'package:path_provider/path_provider.dart';

class SnapshotRepository {
  SnapshotRepository({Storage? storage, AuthService? authService})
      : _storage = storage ?? Storage(),
        _authService = authService ?? AuthService();

  final Storage _storage;
  final AuthService _authService;

  /// Get list of Julia set snapshot for user. Throws on error
  Future<List<StorageItem>> getSnapshotList() async {
    try {
      final identityId = await _authService.getIdentityId();

      if (identityId == null) {
        throw Exception();
      }
      final itemList = await _storage.listFiles(identityId);
      return itemList;
    } catch (e) {
      rethrow;
    }
  }

  /// Get viewer params for snapshot. Throw on error
  Future<JuliaSetViewerParams> getSnapshotParams(String path) async {
    try {
      final paramsFile = await _storage.downloadFile(path);

      final paramsJsonString = paramsFile.readAsStringSync();

      final viewerParams =
          JuliaSetViewerParams.fromMap(jsonDecode(paramsJsonString));

      return viewerParams;
    } catch (e) {
      rethrow;
    }
  }

  /// Upload snapshot params as JSON file to S£. Throw on error
  Future<void> uploadSnapshot(JuliaSetViewerParams juliaSetParams) async {
    try {
      final identityId = await _authService.getIdentityId();

      if (identityId == null) {
        throw Exception();
      }

      final nowTimestamp = DateTime.now().millisecondsSinceEpoch;
      final juliaSetParamsString = jsonEncode(juliaSetParams);
      final tempDir = await getTemporaryDirectory();
      final juliaSetParamsFile = File(tempDir.path + '/$nowTimestamp.json')
        ..createSync()
        ..writeAsStringSync(juliaSetParamsString);
      final uploadPath =
          '$identityId/${DateTime.now().millisecondsSinceEpoch}.json';
      await _storage.uploadFile(
          juliaSetParamsFile,
          uploadPath,
          UploadFileOptions(
            accessLevel: StorageAccessLevel.guest,
            contentType: 'application/json',
          ));
    } catch (e) {
      rethrow;
    }
  }
}
