import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: 'properties.env')
abstract class Env {
  @EnviedField(varName: "TEST", obfuscate: true)
  static final String test = _Env.test;
}