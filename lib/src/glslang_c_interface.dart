import 'dart:convert';
import 'dart:ffi' as ffi;
import 'dart:typed_data';
import 'package:ffi/ffi.dart';

import 'glslang_c_interface.g.dart' as c;

class glslang_version_s {
  final int major;
  final int minor;
  final int patch;
  final String flavor;

  const glslang_version_s(this.major, this.minor, this.patch, this.flavor);

  @override
  String toString() => '$major.$minor.$patch';
}

glslang_version_s glslang_get_version() {
  final versionPtr = calloc<c.glslang_version_s>();
  try {
    c.glslang_get_version(versionPtr);
    final version = versionPtr.ref;
    return glslang_version_s(
      version.major,
      version.minor,
      version.patch,
      version.flavor.cast<Utf8>().toDartString(),
    );
  } finally {
    calloc.free(versionPtr);
  }
}
