import 'package:random_trivia_resocoder/core/error/exceptions.dart';
import 'package:random_trivia_resocoder/core/network/network_info.dart';
import 'package:random_trivia_resocoder/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:random_trivia_resocoder/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:random_trivia_resocoder/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:random_trivia_resocoder/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:random_trivia_resocoder/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:random_trivia_resocoder/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NetWorkInfo netWorkInfo;
  final NumberTriviaRemoteDatasource numberTriviaRemoteDatasource;
  final NumberTriviaLocalDatasource numberTriviaLocalDatasource;
  const NumberTriviaRepositoryImpl({
    required this.netWorkInfo,
    required this.numberTriviaRemoteDatasource,
    required this.numberTriviaLocalDatasource,
  });

  @override
  Future<Either<Failure, NumberTriviaEntity>> getConcreteNumberTrivia(
    int number,
  ) async {
    return await _getTrivia(
      () => numberTriviaRemoteDatasource.getConcreteNumberTrivia(number),
    );
  }

  @override
  Future<Either<Failure, NumberTriviaEntity>> getRandomNumberTrivia() async {
    return await _getTrivia(
      () => numberTriviaRemoteDatasource.getRandomNumberTrivia(),
    );
  }

  Future<Either<Failure, NumberTriviaEntity>> _getTrivia(
    Future<NumberTriviaModel> Function() getConcreteOrRandom,
  ) async {
    if (await netWorkInfo.isConnected) {
      try {
        final res = await getConcreteOrRandom();
        await numberTriviaLocalDatasource.cacheNumberTrivia(res);
        return Right(
          res,
        );
      } on ServerExcpetion {
        return Left(
          ServerFailure(),
        );
      }
    } else {
      try {
        final res = await numberTriviaLocalDatasource.getLastNumberTrivia();
        return Right(res);
      } on CacheException {
        return Left(
          CacheFailure(),
        );
      }
    }
  }
}
