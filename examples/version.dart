import 'package:glslang/glslang.dart';

void main() {
  final version = glslang_get_version();
  print('glslang version: $version');
  print("flavor: ${version.flavor}");
}
