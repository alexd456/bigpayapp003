import 'dart:math' as math;

import 'package:equatable/equatable.dart';

// A utility for representing complex numbers. Copied from https://medium.com/flutter-community/life-is-a-mandelbrot-in-flutter-59dbee6a00be
class Complex extends Equatable {
  /// A complex number representing "NaN + NaNi"
  static const NAN = Complex._(double.nan, double.nan);

  /// A complex number representing "+INF + INFi"
  static const INFINITY = Complex._(double.infinity, double.infinity);

  final double _imaginary, _real;

  /// The imaginary part.
  double get imaginary => _imaginary;

  /// The real part.
  double get real => _real;

  /// Create a complex number given the real part and optionally the imaginary
  /// part.
  Complex(num real, [num imaginary = 0])
      : _real = real.toDouble(),
        _imaginary = imaginary.toDouble();

  const Complex._(this._real, [this._imaginary = 0.0]);

  /// True if the real and imaginary parts are finite; otherwise, false.
  bool get isFinite => !isNaN && _real.isFinite && _imaginary.isFinite;

  /// True if the real and imaginary parts are positive infinity or negative
  /// infinity; otherwise, false.
  bool get isInfinite => !isNaN && (_real.isInfinite || _imaginary.isInfinite);

  /// True if the real and imaginary parts are the double Not-a-Number value;
  /// otherwise, false.
  bool get isNaN => _real.isNaN || _imaginary.isNaN;

  /// Return the absolute value of this complex number.
  /// Returns `NaN` if either real or imaginary part is `NaN`
  /// and `double.INFINITY` if neither part is `NaN`,
  /// but at least one part is infinite.
  double abs() {
    if (isNaN) {
      return double.nan;
    }
    if (isInfinite) {
      return double.infinity;
    }
    if (_real.abs() < _imaginary.abs()) {
      if (_real == 0.0) {
        return _imaginary.abs();
      }
      double q = _real / _imaginary;
      return _imaginary.abs() * math.sqrt(1 + q * q);
    } else {
      if (_imaginary == 0.0) {
        return _real.abs();
      }
      double q = _imaginary / _real;
      return _real.abs() * math.sqrt(1 + q * q);
    }
  }

  /// Returns a `Complex` whose value is
  /// `(this + addend)`.
  /// Uses the definitional formula
  ///
  ///     (a + bi) + (c + di) = (a+c) + (b+d)i
  ///
  /// If either `this` or [addend] has a `NaN` value in
  /// either part, [NaN] is returned; otherwise `Infinite`
  /// and `NaN` values are returned in the parts of the result
  /// according to the rules for [double] arithmetic.
  Complex operator +(Object addend) {
    if (addend is Complex) {
      if (isNaN || addend.isNaN) {
        return Complex.NAN;
      }
      return Complex._(_real + addend.real, _imaginary + addend.imaginary);
    } else if (addend is num) {
      if (isNaN || addend.isNaN) {
        return Complex.NAN;
      }
      return Complex._(_real + addend, _imaginary);
    } else {
      throw ArgumentError('factor must be a num or a Complex');
    }
  }

  /// Returns a `Complex` whose value is `this * factor`.
  /// Implements preliminary checks for `NaN` and infinity followed by
  /// the definitional formula:
  ///
  ///     (a + bi)(c + di) = (ac - bd) + (ad + bc)i
  ///
  /// Returns [NAN] if either `this` or `factor` has one or
  /// more `NaN` parts.
  ///
  /// Returns [INFINITY] if neither `this` nor `factor` has one
  /// or more `NaN` parts and if either `this` or `factor`
  /// has one or more infinite parts (same result is returned regardless of
  /// the sign of the components).
  ///
  /// Returns finite values in components of the result per the definitional
  /// formula in all remaining cases.
  Complex operator *(Object factor) {
    if (factor is Complex) {
      if (isNaN || factor.isNaN) {
        return NAN;
      }
      if (_real.isInfinite ||
          _imaginary.isInfinite ||
          factor._real.isInfinite ||
          factor._imaginary.isInfinite) {
        // we don't use isInfinite to avoid testing for NaN again
        return INFINITY;
      }
      return Complex._(_real * factor._real - _imaginary * factor._imaginary,
          _real * factor._imaginary + _imaginary * factor._real);
    } else if (factor is num) {
      if (isNaN || factor.isNaN) {
        return NAN;
      }
      if (_real.isInfinite || _imaginary.isInfinite || factor.isInfinite) {
        // we don't use isInfinite to avoid testing for NaN again
        return INFINITY;
      }
      return Complex._(_real * factor, _imaginary * factor);
    } else {
      throw ArgumentError('factor must be a num or a Complex');
    }
  }

  /// Negate operator. Returns a `Complex` whose value is `-this`.
  /// Returns `NAN` if either real or imaginary
  /// part of this complex number equals `double.nan`.
  Complex operator -() {
    if (isNaN) {
      return NAN;
    }

    return Complex._(-_real, -_imaginary);
  }

  /// Returns a `Complex` whose value is
  /// `this - subtrahend`.
  /// Uses the definitional formula
  ///
  ///     (a + bi) - (c + di) = (a-c) + (b-d)i
  ///
  /// If either `this` or `subtrahend` has a `NaN` value in either part,
  /// [NAN] is returned; otherwise infinite and `NaN` values are
  /// returned in the parts of the result according to the rules for
  /// [double] arithmetic.
  Complex operator -(Object subtrahend) {
    if (subtrahend is Complex) {
      if (isNaN || subtrahend.isNaN) {
        return NAN;
      }

      return Complex._(
          real - subtrahend._real, imaginary - subtrahend._imaginary);
    } else if (subtrahend is num) {
      if (isNaN || subtrahend.isNaN) {
        return NAN;
      }
      return Complex._(real - subtrahend, imaginary);
    } else {
      throw ArgumentError('factor must be a num or a Complex');
    }
  }

  @override
  List<Object> get props => [_real, _imaginary];

  @override
  String toString() {
    return "($real, $imaginary)";
  }
}
