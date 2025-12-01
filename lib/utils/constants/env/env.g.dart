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
    121305991,
    253895095,
    268765592,
    607490082,
  ];

  static const List<int> _envieddatatest = <int>[
    121306067,
    253895154,
    268765643,
    607490166,
  ];

  static final String test = String.fromCharCodes(
    List<int>.generate(
      _envieddatatest.length,
      (int i) => i,
      growable: false,
    ).map((int i) => _envieddatatest[i] ^ _enviedkeytest[i]),
  );
}
