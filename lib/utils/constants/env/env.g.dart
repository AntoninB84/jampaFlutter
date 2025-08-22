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
    3303973587,
    4051319393,
    580886871,
    1158482537,
  ];

  static const List<int> _envieddatatest = <int>[
    3303973511,
    4051319332,
    580886788,
    1158482493,
  ];

  static final String test = String.fromCharCodes(
    List<int>.generate(
      _envieddatatest.length,
      (int i) => i,
      growable: false,
    ).map((int i) => _envieddatatest[i] ^ _enviedkeytest[i]),
  );
}
