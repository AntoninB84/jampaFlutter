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
    1914300076,
    4090209882,
    2888805835,
    420651870,
  ];

  static const List<int> _envieddatatest = <int>[
    1914300152,
    4090209823,
    2888805784,
    420651786,
  ];

  static final String test = String.fromCharCodes(
    List<int>.generate(
      _envieddatatest.length,
      (int i) => i,
      growable: false,
    ).map((int i) => _envieddatatest[i] ^ _enviedkeytest[i]),
  );
}
