import 'dart:ffi';
import 'package:ffi/ffi.dart' as ffi;

import 'glslang_c_interface.g.dart' as c;

class glslang_version_s {
  final int major;
  final int minor;
  final int patch;

  const glslang_version_s(this.major, this.minor, this.patch);

  @override
  String toString() => '$major.$minor.$patch';
}

glslang_version_s glslang_get_version() {
  final versionPtr = ffi.calloc<c.glslang_version_s>();
  try {
    c.glslang_get_version(versionPtr);
    final version = versionPtr.ref;
    return glslang_version_s(version.major, version.minor, version.patch);
  } finally {
    ffi.calloc.free(versionPtr);
  }
}
