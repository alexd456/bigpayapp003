part of 'julia_set_viewer_cubit.dart';

abstract class JuliaSetViewerState extends Equatable {
  const JuliaSetViewerState();

  @override
  List<Object> get props => [];
}

class JuliaSetViewerInitial extends JuliaSetViewerState {}

class JuliaSetViewerDownloadInProgress extends JuliaSetViewerState {}

class JuliaSetViewerDownloadError extends JuliaSetViewerState {}

class JuliaSetViewerUploadInProgress extends JuliaSetViewerState {}

class JuliaSetViewerUploadSuccess extends JuliaSetViewerState {}

class JuliaSetViewerUploadError extends JuliaSetViewerState {}

/// The render state contains:
/// 1) A map of type {int, List<Offset>} the list of points (Offests) is keyed by the
/// number of iterations after which the points lie beyond the circle of radius 2 from the origin.
/// 2) The params for this Julia set.
/// 3) The width and height of the viewer
class JuliaSetViewerRenderSuccess extends JuliaSetViewerState {
  final JuliaSetViewerParams viewerParams;
  final Map<int, List<Offset>> pointsPerIteration;

  const JuliaSetViewerRenderSuccess(this.viewerParams, this.pointsPerIteration);

  @override
  List<Object> get props => [
        viewerParams.c.real,
        viewerParams.c.imaginary,
        viewerParams.iterations,
        viewerParams.zoom,
        viewerParams.moveX,
        viewerParams.moveY,
      ];
}
