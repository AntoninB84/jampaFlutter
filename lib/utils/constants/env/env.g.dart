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
    3287152296,
    3159951412,
    1916911927,
    3100671202,
  ];

  static const List<int> _envieddatatest = <int>[
    3287152380,
    3159951473,
    1916911972,
    3100671158,
  ];

  static final String test = String.fromCharCodes(
    List<int>.generate(
      _envieddatatest.length,
      (int i) => i,
      growable: false,
    ).map((int i) => _envieddatatest[i] ^ _enviedkeytest[i]),
  );
}
