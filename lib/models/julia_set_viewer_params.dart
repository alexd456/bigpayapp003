import 'package:equatable/equatable.dart';

import '../utils/complex.dart';

class JuliaSetViewerParams extends Equatable {
  /// Value of the constant in the Julia set calculation
  final Complex c;
  final double zoom;
  final double moveX;
  final double moveY;
  final int iterations;

  const JuliaSetViewerParams(
      {required this.c,
      required this.zoom,
      required this.moveX,
      required this.moveY,
      required this.iterations});

  @override
  List<Object> get props => [c, zoom, moveX, moveY, iterations];

  toJson() {
    return {
      'reC': c.real,
      'imC': c.imaginary,
      'zoom': zoom,
      'moveX': moveX,
      'moveY': moveY,
      'iterations': iterations,
    };
  }

  factory JuliaSetViewerParams.fromMap(Map<String, dynamic> data) =>
      JuliaSetViewerParams(
          c: Complex(data['reC'], data['imC']),
          zoom: data['zoom'],
          moveX: data['moveX'],
          moveY: data['moveY'],
          iterations: data['iterations']);
}
