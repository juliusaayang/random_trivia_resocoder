import 'package:dartz/dartz.dart';
import 'package:random_trivia_resocoder/core/error/failure.dart';
import 'package:random_trivia_resocoder/features/number_trivia/domain/entities/number_trivia_entity.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failure, NumberTriviaEntity>> getConcreteNumberTrivia({
    required int number,
  });

  Future<Either<Failure, NumberTriviaEntity>> getRandomNumberTrivia();
}
