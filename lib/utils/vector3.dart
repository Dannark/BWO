// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

//part of vector_math;

import 'dart:math' as math;
import 'dart:typed_data';

import 'vector.dart';

/// 3D column vector.
class Vector3 implements Vector {
  final Float32List _v3storage;

  /// The components of the vector.
  @override
  Float32List get storage => _v3storage;

  /// Set the values of [result] to the minimum of [a] and [b] for each line.
  static void min(Vector3 a, Vector3 b, Vector3 result) {
    result
      ..x = math.min(a.x, b.x)
      ..y = math.min(a.y, b.y)
      ..z = math.min(a.z, b.z);
  }

  /// Set the values of [result] to the maximum of [a] and [b] for each line.
  static void max(Vector3 a, Vector3 b, Vector3 result) {
    result
      ..x = math.max(a.x, b.x)
      ..y = math.max(a.y, b.y)
      ..z = math.max(a.z, b.z);
  }

  /// Interpolate between [min] and [max] with the amount of [a] using a linear
  /// interpolation and store the values in [result].
  static void mix(Vector3 min, Vector3 max, double a, Vector3 result) {
    result
      ..x = min.x + a * (max.x - min.x)
      ..y = min.y + a * (max.y - min.y)
      ..z = min.z + a * (max.z - min.z);
  }

  /// Construct a new vector with the specified values.
  factory Vector3(double x, double y, double z) =>
      Vector3.zero()
        ..setValues(x, y, z);

  /// Initialized with values from [array] starting at [offset].
  factory Vector3.array(List<double> array, [int offset = 0]) =>
      Vector3.zero()
        ..copyFromArray(array, offset);

  /// Zero vector.
  Vector3.zero() : _v3storage = Float32List(3);

  /// Splat [value] into all lanes of the vector.
  factory Vector3.all(double value) =>
      Vector3.zero()
        ..splat(value);

  /// Copy of [other].
  factory Vector3.copy(Vector3 other) =>
      Vector3.zero()
        ..setFrom(other);

  /// Set the values of the vector.
  void setValues(double x, double y, double z) {
    _v3storage[0] = x;
    _v3storage[1] = y;
    _v3storage[2] = z;
  }

  /// Copies elements from [array] into this starting at [offset].
  void copyFromArray(List<double> array, [int offset = 0]) {
    _v3storage[2] = array[offset + 2];
    _v3storage[1] = array[offset + 1];
    _v3storage[0] = array[offset + 0];
  }

  /// Zero vector.
  void setZero() {
    _v3storage[2] = 0.0;
    _v3storage[1] = 0.0;
    _v3storage[0] = 0.0;
  }

  /// Set the values by copying them from [other].
  void setFrom(Vector3 other) {
    final otherStorage = other._v3storage;
    _v3storage[0] = otherStorage[0];
    _v3storage[1] = otherStorage[1];
    _v3storage[2] = otherStorage[2];
  }

  /// Splat [arg] into all lanes of the vector.
  void splat(double arg) {
    _v3storage[2] = arg;
    _v3storage[1] = arg;
    _v3storage[0] = arg;
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
      _v3storage[0] *= l;
      _v3storage[1] *= l;
      _v3storage[2] *= l;
    }
  }

  /// Access the component of the vector at the index [i].
  double operator [](int i) => _v3storage[i];

  /// Set the component of the vector at the index [i].
  void operator []=(int i, double v) {
    _v3storage[i] = v;
  }

  /// Length.
  double get length => math.sqrt(length2);

  /// Length squared.
  double get length2 {
    double sum;
    sum = _v3storage[0] * _v3storage[0];
    sum += _v3storage[1] * _v3storage[1];
    sum += _v3storage[2] * _v3storage[2];
    return sum;
  }

  /// Normalizes this.
  double normalize() {
    final l = length;
    if (l == 0.0) {
      return 0.0;
    }
    final d = 1.0 / l;
    _v3storage[0] *= d;
    _v3storage[1] *= d;
    _v3storage[2] *= d;
    return l;
  }

  /// Normalize this. Returns length of vector before normalization.
  /// DEPRCATED: Use [normalize].
  @Deprecated('Use normalize() insteaed.')
  double normalizeLength() => normalize();

  /// Normalizes copy of this.
  Vector3 normalized() => Vector3.copy(this)..normalize();

  /// Normalize vector into [out].
  Vector3 normalizeInto(Vector3 out) {
    out
      ..setFrom(this)
      ..normalize();
    return out;
  }

  /// Distance from this to [arg]
  double distanceTo(Vector3 arg) => math.sqrt(distanceToSquared(arg));

  /// Squared distance from this to [arg]
  double distanceToSquared(Vector3 arg) {
    final argStorage = arg._v3storage;
    final dx = _v3storage[0] - argStorage[0];
    final dy = _v3storage[1] - argStorage[1];
    final dz = _v3storage[2] - argStorage[2];

    return dx * dx + dy * dy + dz * dz;
  }

  /// Returns the angle between this vector and [other] in radians.
  double angleTo(Vector3 other) {
    final otherStorage = other._v3storage;
    if (_v3storage[0] == otherStorage[0] &&
        _v3storage[1] == otherStorage[1] &&
        _v3storage[2] == otherStorage[2]) {
      return 0.0;
    }

    final d = dot(other) / (length * other.length);

    return math.acos(d.clamp(-1.0, 1.0));
  }

  /// Returns the signed angle between this and [other] around [normal]
  /// in radians.
  double angleToSigned(Vector3 other, Vector3 normal) {
    final angle = angleTo(other);
    final c = cross(other);
    final d = c.dot(normal);

    return d < 0.0 ? -angle : angle;
  }


  /// Inner product.
  double dot(Vector3 other) {
    final otherStorage = other._v3storage;
    double sum;
    sum = _v3storage[0] * otherStorage[0];
    sum += _v3storage[1] * otherStorage[1];
    sum += _v3storage[2] * otherStorage[2];
    return sum;
  }



  /// Cross product.
  Vector3 cross(Vector3 other) {
    final _x = _v3storage[0];
    final _y = _v3storage[1];
    final _z = _v3storage[2];
    final otherStorage = other._v3storage;
    final ox = otherStorage[0];
    final oy = otherStorage[1];
    final oz = otherStorage[2];
    return Vector3(_y * oz - _z * oy, _z * ox - _x * oz, _x * oy - _y * ox);
  }

  /// Cross product. Stores result in [out].
  Vector3 crossInto(Vector3 other, Vector3 out) {
    final x = _v3storage[0];
    final y = _v3storage[1];
    final z = _v3storage[2];
    final otherStorage = other._v3storage;
    final ox = otherStorage[0];
    final oy = otherStorage[1];
    final oz = otherStorage[2];
    final outStorage = out._v3storage;
    outStorage[0] = y * oz - z * oy;
    outStorage[1] = z * ox - x * oz;
    outStorage[2] = x * oy - y * ox;
    return out;
  }

  set x(double arg) => _v3storage[0] = arg;
  set y(double arg) => _v3storage[1] = arg;
  set z(double arg) => _v3storage[2] = arg;
  double get x => _v3storage[0];
  double get y => _v3storage[1];
  double get z => _v3storage[2];
}