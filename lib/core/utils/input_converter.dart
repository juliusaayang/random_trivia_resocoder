import 'package:dartz/dartz.dart';
import 'package:random_trivia_resocoder/core/error/failure.dart';

class InputConverter {
  Either<Failure, int> stringToUnassignedInteger(String str) {
    try {
      final integer = int.parse(str);
      if (integer < 0) throw InvalidInputFailure();

      return Right(integer);
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {
  @override
  List<Object?> get props => [];
}
