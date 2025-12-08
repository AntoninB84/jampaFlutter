import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: 'properties.env')
abstract class Env {
  @EnviedField(varName: "API_URL_DEV", obfuscate: true)
  static final String apiUrlDev = _Env.apiUrlDev;

  @EnviedField(varName: "API_URL_PROD", obfuscate: true)
  static final String apiUrlProd = _Env.apiUrlProd;

  @EnviedField(varName: "API_KEY", obfuscate: true)
  static final String apiKey = _Env.apiKey;
}