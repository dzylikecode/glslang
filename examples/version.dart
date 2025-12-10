import 'package:glslang/glslang.dart';

void main() {
  final version = glslang_get_version();
  print('glslang version: $version');
}
