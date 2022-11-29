import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:random_trivia_resocoder/core/error/failure.dart';
import 'package:random_trivia_resocoder/core/usecase/usecase.dart';
import 'package:random_trivia_resocoder/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:random_trivia_resocoder/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetConcreteNumberTriviaUsecase
    extends Usecase<NumberTriviaEntity, GetConcreteNumberTriviaParams> {
  final NumberTriviaRepository numberTriviaRepository;
  GetConcreteNumberTriviaUsecase({
    required this.numberTriviaRepository,
  });

  @override
  Future<Either<Failure, NumberTriviaEntity>> call(
      GetConcreteNumberTriviaParams params) {
    return numberTriviaRepository.getConcreteNumberTrivia(params.number);
  }
}

class GetConcreteNumberTriviaParams extends Equatable {
  final int number;
  const GetConcreteNumberTriviaParams({
    required this.number,
  });

  @override
  List<Object> get props => [number];
}
