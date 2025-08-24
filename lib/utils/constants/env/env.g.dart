// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'env.dart';

// **************************************************************************
// EnviedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// generated_from: properties.env
final class _Env {
  static const List<int> _enviedkeytest = <int>[
    3459090527,
    2552522199,
    3179909375,
    1137741632,
  ];

  static const List<int> _envieddatatest = <int>[
    3459090443,
    2552522130,
    3179909292,
    1137741588,
  ];

  static final String test = String.fromCharCodes(
    List<int>.generate(
      _envieddatatest.length,
      (int i) => i,
      growable: false,
    ).map((int i) => _envieddatatest[i] ^ _enviedkeytest[i]),
  );
}
