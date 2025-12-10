import 'dart:io';

import 'package:ffigen/ffigen.dart';

void main() {
  final packageRoot = Platform.script.resolve('../');
  FfiGenerator(
    output: .new(
      dartFile: packageRoot.resolve('lib/src/glslang_c_interface.g.dart'),
    ),
    headers: .new(
      entryPoints: [
        packageRoot.resolve(
          'src/glslang/glslang/Include/glslang_c_interface.h',
        ),
      ],
      include: (header) => header.path.contains('glslang'),
    ),
    structs: .includeAll,
    functions: .includeAll,
    typedefs: .includeAll,
    macros: .includeAll,
    enums: .includeAll,
  ).generate();
}
