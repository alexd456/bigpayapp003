import 'dart:ui';

import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:bigpay_app003/cubit/welcome_screen/welcome_screen_cubit.dart';
import 'package:bigpay_app003/data/repository/snapshot_repository.dart';
import 'package:bigpay_app003/models/julia_set_viewer_params.dart';
import 'package:bigpay_app003/utils/complex.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'julia_set_viewer_state.dart';

class JuliaSetViewerCubit extends Cubit<JuliaSetViewerState> {
  final WelcomeScreenCubit _welcomeScreenCubit;
  final SnapshotRepository _snapshotRepository;

  JuliaSetViewerCubit(this._welcomeScreenCubit, this._snapshotRepository)
      : super(JuliaSetViewerInitial());

  /// Generates the points required for rendering the set
  Future<void> generatePoints(
      JuliaSetViewerParams params, double width, double height) async {
    final intHeight = height.toDouble();
    final intWidth = height.toDouble();
    Complex oldZ, newZ;

    final Map<int, List<Offset>> pointsPerIteration = {};

    for (int x = 0; x < intWidth + 1; x++) {
      // Initial real part of z based on pixel location and zoom/position
      double re0 = 1.5 * (x - intWidth / 2) / (0.5 * params.zoom * intWidth) +
          params.moveX;
      for (int y = 0; y < intHeight; y++) {
        // Initial imaginary part of z based on pixel location and zoom/position
        double im0 =
            1.3 * (y - intHeight / 2) / (0.5 * params.zoom * intHeight) +
                params.moveY;

        // Initialise z value
        newZ = Complex(re0, im0);
        int i = 0;

        while (i < params.iterations) {
          oldZ = newZ;
          //the actual iteration, the real and imaginary part are calculated
          newZ = (oldZ * oldZ) + params.c;
          //if the point is outside the circle with radius 2: stop
          if (newZ.abs() > 2) break;
          i++;
        }

        if (pointsPerIteration[i] == null) {
          pointsPerIteration[i] = [Offset(x.toDouble(), y.toDouble())];
        } else {
          pointsPerIteration[i]!.add(Offset(x.toDouble(), y.toDouble()));
        }
      }
    }

    emit(JuliaSetViewerRenderSuccess(params, pointsPerIteration));
  }

  Future<void> downloadSnapshot(
      StorageItem snapshot, double width, double height) async {
    emit(JuliaSetViewerDownloadInProgress());

    try {
      final juliaSetParams =
          await _snapshotRepository.getSnapshotParams(snapshot.key);
      generatePoints(juliaSetParams, width, height);
    } catch (_) {
      emit(JuliaSetViewerDownloadError());
    }
  }

  Future<void> saveSnapshot(JuliaSetViewerParams params,
      Map<int, List<Offset>> pointsPerIteration) async {
    emit(JuliaSetViewerUploadInProgress());

    try {
      await _snapshotRepository.uploadSnapshot(params);
      emit(JuliaSetViewerUploadSuccess());
      emit(JuliaSetViewerRenderSuccess(params, pointsPerIteration));
      // Update saved snapshots on welcome screen
      _welcomeScreenCubit.loadSnapshots();
    } catch (e) {
      emit(JuliaSetViewerUploadError());
      emit(JuliaSetViewerRenderSuccess(params, pointsPerIteration));
    }
  }
}
