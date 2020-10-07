// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

//part of vector_math;

import 'dart:math' as math;
import 'dart:typed_data';

import 'vector.dart';

/// 2D column vector.
class Vector2 implements Vector {
  final Float32List _v2storage;

  /// The components of the vector.
  @override
  Float32List get storage => _v2storage;

  /// Set the values of [result] to the minimum of [a] and [b] for each line.
  static void min(Vector2 a, Vector2 b, Vector2 result) {
    result
      ..x = math.min(a.x, b.x)
      ..y = math.min(a.y, b.y);
  }

  /// Set the values of [result] to the maximum of [a] and [b] for each line.
  static void max(Vector2 a, Vector2 b, Vector2 result) {
    result
      ..x = math.max(a.x, b.x)
      ..y = math.max(a.y, b.y);
  }

  /// Interpolate between [min] and [max] with the amount of [a] using a linear
  /// interpolation and store the values in [result].
  static void mix(Vector2 min, Vector2 max, double a, Vector2 result) {
    result
      ..x = min.x + a * (max.x - min.x)
      ..y = min.y + a * (max.y - min.y);
  }

  /// Construct a new vector with the specified values.
  factory Vector2(double x, double y) =>
      Vector2.zero()
        ..setValues(x, y);

  /// Initialized with values from [array] starting at [offset].
  factory Vector2.array(List<double> array, [int offset = 0]) =>
      Vector2.zero()
        ..copyFromArray(array, offset);

  /// Zero vector.
  Vector2.zero() : _v2storage = Float32List(2);

  /// Splat [value] into all lanes of the vector.
  factory Vector2.all(double value) =>
      Vector2.zero()
        ..splat(value);

  /// Copy of [other].
  factory Vector2.copy(Vector2 other) =>
      Vector2.zero()
        ..setFrom(other);

  /// Set the values of the vector.
  void setValues(double x_, double y_) {
    _v2storage[0] = x_;
    _v2storage[1] = y_;
  }

  /// Zero the vector.
  void setZero() {
    _v2storage[0] = 0.0;
    _v2storage[1] = 0.0;
  }

  /// Copies elements from [array] into this starting at [offset].
  void copyFromArray(List<double> array, [int offset = 0]) {
    _v2storage[1] = array[offset + 1];
    _v2storage[0] = array[offset + 0];
  }

  /// Clone of this.
  Vector2 clone() => Vector2.copy(this);

  /// Set the values by copying them from [other].
  void setFrom(Vector2 other) {
    final otherStorage = other._v2storage;
    _v2storage[1] = otherStorage[1];
    _v2storage[0] = otherStorage[0];
  }

  /// Splat [arg] into all lanes of the vector.
  void splat(double arg) {
    _v2storage[0] = arg;
    _v2storage[1] = arg;
  }

  /// Returns a printable string
  @override
  String toString() => '[${_v2storage[0]},${_v2storage[1]}]';

  /// Check if two vectors are the same.
//  @override
//  bool operator ==(Object? other) =>
//      (other is Vector2) &&
//          (_v2storage[0] == other._v2storage[0]) &&
//          (_v2storage[1] == other._v2storage[1]);

  /// Negate.
  Vector2 operator -() => clone()..negate();

  /// Subtract two vectors.
  Vector2 operator -(Vector2 other) => clone()..sub(other);

  /// Add two vectors.
  Vector2 operator +(Vector2 other) => clone()..add(other);

  /// Scale.
  Vector2 operator /(double scale) => clone()..scale(1.0 / scale);

  /// Scale.
  Vector2 operator *(double scale) => clone()..scale(scale);

  /// Access the component of the vector at the index [i].
  double operator [](int i) => _v2storage[i];

  /// Set the component of the vector at the index [i].
  void operator []=(int i, double v) {
    _v2storage[i] = v;
  }


  /// Set the length of the vector. A negative [value] will change the vectors
  /// orientation and a [value] of zero will set the vector to zero.
  set length(double value) {
    if (value == 0.0) {
      setZero();
    } else {
      var l = length;
      if (l == 0.0) {
        return;
      }
      l = value / l;
      _v2storage[0] *= l;
      _v2storage[1] *= l;
    }
  }

  /// Length.
  double get length => math.sqrt(length2);

  /// Length squared.
  double get length2 {
    double sum;
    sum = _v2storage[0] * _v2storage[0];
    sum += _v2storage[1] * _v2storage[1];
    return sum;
  }

  /// Normalize this.
  double normalize() {
    final l = length;
    if (l == 0.0) {
      return 0.0;
    }
    final d = 1.0 / l;
    _v2storage[0] *= d;
    _v2storage[1] *= d;
    return l;
  }


  /// Normalize this. Returns length of vector before normalization.
  /// DEPRECATED: Use [normalize].
  @Deprecated('Use normalize() insteaed.')
  double normalizeLength() => normalize();

  /// Normalized copy of this.
  Vector2 normalized() => clone()..normalize();

  /// Normalize vector into [out].
  Vector2 normalizeInto(Vector2 out) {
    out
      ..setFrom(this)
      ..normalize();
    return out;
  }

  /// Distance from this to [arg]
  double distanceTo(Vector2 arg) => math.sqrt(distanceToSquared(arg));

  /// Squared distance from this to [arg]
  double distanceToSquared(Vector2 arg) {
    final dx = x - arg.x;
    final dy = y - arg.y;

    return dx * dx + dy * dy;
  }

  /// Returns the angle between this vector and [other] in radians.
  double angleTo(Vector2 other) {
    final otherStorage = other._v2storage;
    if (_v2storage[0] == otherStorage[0] && _v2storage[1] == otherStorage[1]) {
      return 0.0;
    }

    final d = dot(other) / (length * other.length);

    return math.acos(d.clamp(-1.0, 1.0));
  }

  /// Returns the signed angle between this and [other] in radians.
  double angleToSigned(Vector2 other) {
    final otherStorage = other._v2storage;
    if (_v2storage[0] == otherStorage[0] && _v2storage[1] == otherStorage[1]) {
      return 0.0;
    }

    final s = cross(other);
    final c = dot(other);

    return math.atan2(s, c);
  }

  /// Inner product.
  double dot(Vector2 other) {
    final otherStorage = other._v2storage;
    double sum;
    sum = _v2storage[0] * otherStorage[0];
    sum += _v2storage[1] * otherStorage[1];
    return sum;
  }

  /// Cross product.
  double cross(Vector2 other) {
    final otherStorage = other._v2storage;
    return _v2storage[0] * otherStorage[1] - _v2storage[1] * otherStorage[0];
  }

  /// Add [arg] to this.
  void add(Vector2 arg) {
    final argStorage = arg._v2storage;
    _v2storage[0] = _v2storage[0] + argStorage[0];
    _v2storage[1] = _v2storage[1] + argStorage[1];
  }

  /// Add [arg] scaled by [factor] to this.
  void addScaled(Vector2 arg, double factor) {
    final argStorage = arg._v2storage;
    _v2storage[0] = _v2storage[0] + argStorage[0] * factor;
    _v2storage[1] = _v2storage[1] + argStorage[1] * factor;
  }

  /// Subtract [arg] from this.
  void sub(Vector2 arg) {
    final argStorage = arg._v2storage;
    _v2storage[0] = _v2storage[0] - argStorage[0];
    _v2storage[1] = _v2storage[1] - argStorage[1];
  }

  /// Scale this by [arg].
  void scale(double arg) {
    _v2storage[1] = _v2storage[1] * arg;
    _v2storage[0] = _v2storage[0] * arg;
  }

  /// Return a copy of this scaled by [arg].
  Vector2 scaled(double arg) => clone()..scale(arg);

  /// Negate.
  void negate() {
    _v2storage[1] = -_v2storage[1];
    _v2storage[0] = -_v2storage[0];
  }


  set t(double arg) => y = arg;
  set x(double arg) => _v2storage[0] = arg;
  set y(double arg) => _v2storage[1] = arg;

  double get t => y;
  double get x => _v2storage[0];
  double get y => _v2storage[1];
}