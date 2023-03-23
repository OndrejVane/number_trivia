import 'package:dartz/dartz.dart';

import '../error/failure.dart';

class InputConvertor {

  Either<InvalidInputFailure, int> stringToUnsignedInteger(String str) {
    try {
      final intParsed = int.parse(str);
      if (intParsed < 0) throw const FormatException();
      return Right(intParsed);
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {
  @override
  List<Object?> get props => [];
}