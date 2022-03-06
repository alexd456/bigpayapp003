import 'dart:ui' as ui;

import 'package:bigpay_app003/cubit/julia_set_viewer/julia_set_viewer_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JuliaSetView extends StatelessWidget {
  final double viewWidth, viewHeight;
  const JuliaSetView(
      {Key? key, required this.viewWidth, required this.viewHeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JuliaSetViewerCubit, JuliaSetViewerState>(
      buildWhen: (previous, current) =>
          current is JuliaSetViewerInitial ||
          current is JuliaSetViewerRenderSuccess ||
          current is JuliaSetViewerDownloadInProgress ||
          current is JuliaSetViewerDownloadError,
      builder: (context, state) {
        if (state is JuliaSetViewerInitial) {
          return SizedBox(
            width: viewWidth,
            height: viewHeight,
            child: const Image(
              image: AssetImage('assets/initial_julia_set.png'),
              fit: BoxFit.cover,
            ),
          );
        } else if (state is JuliaSetViewerDownloadInProgress) {
          return SizedBox(
            width: viewWidth,
            height: viewHeight,
            child: Container(
              color: Colors.grey,
              child: const Center(child: CupertinoActivityIndicator()),
            ),
          );
        } else if (state is JuliaSetViewerDownloadError) {
          return SizedBox(
            width: viewWidth,
            height: viewHeight,
            child: Container(
              color: Colors.grey,
              child: const Center(child: Text('Error opening snapshot')),
            ),
          );
        } else {
          final renderState = state as JuliaSetViewerRenderSuccess;
          return CustomPaint(
            size: Size(viewWidth, viewHeight),
            painter: MandelbrotPainter(renderState.pointsPerIteration,
                renderState.viewerParams.iterations),
          );
        }
      },
    );
  }
}

class MandelbrotPainter extends CustomPainter {
  Map<int, List<Offset>> pointsPerIteration;
  int maxIterations;

  MandelbrotPainter(this.pointsPerIteration, this.maxIterations);

  @override
  void paint(Canvas canvas, Size size) async {
    // Define a paint object with 1.5 pixel stroke width (1 pixel gives ugly grid-like view)
    final paint = Paint()
      ..strokeWidth =
          1.5; //real and imaginary part of the constant c, determinate shape of the Julia Set

    pointsPerIteration.forEach((iter, offsetList) {
      paint.color = iter == maxIterations
          ? const Color(0xFF000000)
          : HSVColor.fromAHSV(1, 360 * iter / maxIterations, .9, .6).toColor();
      canvas.drawPoints(ui.PointMode.points, offsetList, paint);
    });
  }

  @override
  bool shouldRepaint(MandelbrotPainter oldDelegate) => true;
}
