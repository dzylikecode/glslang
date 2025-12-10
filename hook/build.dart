// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:code_assets/code_assets.dart';
import 'package:hooks/hooks.dart';
import 'package:logging/logging.dart';

final _logger = Logger('glslang hook');

Future<void> main(List<String> args) async {
  Logger.root
    ..level = Level.ALL
    ..onRecord.listen(
      (record) => print(
        '[${record.level.name}] [${record.loggerName}] ${record.time}: ${record.message}',
      ),
    );

  await build(args, (input, output) async {
    final builder = XmakeBuilder(
      sourceDir: input.packageRoot.resolveUri(.directory('src/')),
      installDir: input.packageRoot.resolveUri(.directory('src/dist/')),
      checkoutDir: input.packageRoot.resolveUri(
        .directory('src/dist/glslang/lib'),
      ),
      logger: _logger,
    );
    await builder.run();

    output.assets.code.add(
      CodeAsset(
        package: input.packageName,
        name: 'src/glslang_c_interface.g.dart',
        file: input.packageRoot
            .resolveUri(.directory('src/dist/glslang/lib'))
            .resolve(switch (input.config.code.targetOS) {
              .linux => 'libglslang.so',
              .macOS => 'libglslang.dylib',
              .windows => 'glslang.dll',
              .android => 'libglslang.so',
              _ => throw UnsupportedError(
                'Unsupported OS: ${input.config.code.targetOS}',
              ),
            }),
        linkMode: DynamicLoadingBundled(),
      ),
    );
  });
}

class XmakeBuilder {
  final Uri sourceDir;
  final Uri installDir;
  final Uri checkoutDir;
  final Logger? _logger;
  const XmakeBuilder({
    required this.sourceDir,
    required this.installDir,
    required this.checkoutDir,
    required Logger? logger,
  }) : _logger = logger;

  Future<void> buildDll() async {
    final result = await Process.run('xmake', [
      'build',
      '-y',
      'dart_dll',
    ], workingDirectory: sourceDir.toFilePath());
    if (result.exitCode != 0) {
      throw ProcessException(
        'xmake',
        ['build', '-y', 'dart_dll'],
        'Failed to build with xmake: ${result.stderr}',
        result.exitCode,
      );
    }
  }

  Future<void> installDll() async {
    final result = await Process.run('xmake', [
      'install',
      '-y',
      '-o',
      installDir.toFilePath(),
    ], workingDirectory: sourceDir.toFilePath());
    if (result.exitCode != 0) {
      throw ProcessException(
        'xmake',
        ['install', '-y', '-o', installDir.toFilePath()],
        'Failed to install with xmake: ${result.stderr}',
        result.exitCode,
      );
    }
  }

  Future<bool> isInstalled() async {
    return Directory.fromUri(checkoutDir).exists();
  }

  Future<void> run() async {
    if (await isInstalled()) {
      _logger?.info('xmake project already built at $installDir');
      return;
    }

    _logger?.info('Building xmake project at $sourceDir');
    await buildDll();
    _logger?.info('Installing xmake project to $installDir');
    await installDll();
  }
}
