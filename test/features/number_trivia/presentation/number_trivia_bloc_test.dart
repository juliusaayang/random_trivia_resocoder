import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:random_trivia_resocoder/core/error/failure.dart';
import 'package:random_trivia_resocoder/core/usecase/usecase.dart';
import 'package:random_trivia_resocoder/core/utils/input_converter.dart';
import 'package:random_trivia_resocoder/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:random_trivia_resocoder/features/number_trivia/domain/usecases/get_concreate_number_trivia_usecase.dart';
import 'package:random_trivia_resocoder/features/number_trivia/domain/usecases/get_random_number_trivia_usecase.dart';
import 'package:random_trivia_resocoder/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

import 'number_trivia_bloc_test.mocks.dart';

@GenerateMocks([
  GetConcreteNumberTriviaUsecase,
  GetRandomNumberTriviaUsecase,
  InputConverter
])
void main() {
  late NumberTriviaBloc numberTriviaBloc;
  late MockGetConcreteNumberTriviaUsecase mockGetConcreteNumberTriviaUsecase;
  late MockGetRandomNumberTriviaUsecase mockGetRandomNumberTriviaUsecase;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTriviaUsecase = MockGetConcreteNumberTriviaUsecase();
    mockGetRandomNumberTriviaUsecase = MockGetRandomNumberTriviaUsecase();
    mockInputConverter = MockInputConverter();
    numberTriviaBloc = NumberTriviaBloc(
      getConcreteNumberTriviaUsecase: mockGetConcreteNumberTriviaUsecase,
      getRandomNumberTriviaUsecase: mockGetRandomNumberTriviaUsecase,
      inputConverter: mockInputConverter,
    );
  });

  group(
    'GetConcreteNumberTrivia',
    () {
      final tNumberString = '1';
      final tNumberParsed = 1;
      final tNumberTriviaEntity = NumberTriviaEntity(
        text: 'test',
        number: 1,
      );

      void mockInputCoverterSuccess() =>
          when(mockInputConverter.stringToUnassignedInteger(any))
              .thenReturn(Right(tNumberParsed));

      test(
        'should call the input conveter to convert and validate string',
        () async* {
          // arrange
          mockInputCoverterSuccess();
          // act
          numberTriviaBloc.add(GetConcreteNumberTriviaEvent(tNumberString));
          await untilCalled(mockInputConverter.stringToUnassignedInteger(any));
          // assert
          verify(mockInputConverter.stringToUnassignedInteger(tNumberString));
        },
      );

      test(
        'should emit [Error] when the input is invalid',
        () async* {
          // arrange
          when(mockInputConverter.stringToUnassignedInteger(any)).thenReturn(
            Left(
              InvalidInputFailure(),
            ),
          );

          // assert later
          final expected = [
            EmptyState(),
            ErrorState(INVALID_INPUT_FAILURE_MESSAGE),
          ];
          expectLater(numberTriviaBloc.state, emitsInOrder(expected));

          // act
          numberTriviaBloc.add(GetConcreteNumberTriviaEvent(tNumberString));
        },
      );

      test(
        'should get from the data [GetConcreteNumberTriviaUsecase] class',
        () async* {
          // arrange
          mockInputCoverterSuccess();
          when(mockGetConcreteNumberTriviaUsecase(any)).thenAnswer(
            (realInvocation) => Future.value(
              Right(tNumberTriviaEntity),
            ),
          );

          // act
          numberTriviaBloc.add(GetConcreteNumberTriviaEvent(tNumberString));
          await untilCalled(mockGetConcreteNumberTriviaUsecase(any));

          // assert
          verify(
            numberTriviaBloc.getConcreteNumberTriviaUsecase.call(
              GetConcreteNumberTriviaParams(
                number: tNumberParsed,
              ),
            ),
          );
        },
      );

      test(
        'should emit [Loading, Loaded] state, when data is gotten successfully',
        () async* {
          // arrange
          mockInputCoverterSuccess();
          when(mockGetConcreteNumberTriviaUsecase(any)).thenAnswer(
            (realInvocation) => Future.value(
              Right(tNumberTriviaEntity),
            ),
          );

          // assert later
          final expectedStates = [
            EmptyState(),
            LoadingState(),
            Loadedstate(numberTriviaEntity: tNumberTriviaEntity),
          ];
          expectLater(numberTriviaBloc.state, emitsInOrder(expectedStates));

          // act
          numberTriviaBloc.add(GetConcreteNumberTriviaEvent(tNumberString));
        },
      );

      test(
        'should emit [Loading, Error] state, when getting data failed',
        () async* {
          // arrange
          mockInputCoverterSuccess();
          when(mockGetConcreteNumberTriviaUsecase(any)).thenAnswer(
            (realInvocation) => Future.value(
              Left(ServerFailure()),
            ),
          );

          // assert later
          final expectedStates = [
            EmptyState(),
            LoadingState(),
            ErrorState(SERVER_FAILURE_MESSAGE),
          ];
          expectLater(numberTriviaBloc.state, emitsInOrder(expectedStates));

          // act
          numberTriviaBloc.add(GetConcreteNumberTriviaEvent(tNumberString));
        },
      );

      test(
        'should emit [Loading, Error] state, with a proper message for the erro when getting dat fails',
        () async* {
          // arrange
          mockInputCoverterSuccess();
          when(mockGetConcreteNumberTriviaUsecase(any)).thenAnswer(
            (realInvocation) => Future.value(
              Left(CacheFailure()),
            ),
          );

          // assert later
          final expectedStates = [
            EmptyState(),
            LoadingState(),
            ErrorState(CACHE_FAILURE_MESSAGE),
          ];
          expectLater(numberTriviaBloc.state, emitsInOrder(expectedStates));

          // act
          numberTriviaBloc.add(GetConcreteNumberTriviaEvent(tNumberString));
        },
      );
      
    },
  );

   group(
    'GetRandomNumberTrivia',
    () {
      final tNumberTriviaEntity = NumberTriviaEntity(
        text: 'test',
        number: 1,
      );

     
      test(
        'should get from the data [GetRandomNumberTriviaUsecase] class',
        () async* {
          // arrange
          when(mockGetRandomNumberTriviaUsecase(any)).thenAnswer(
            (realInvocation) => Future.value(
              Right(tNumberTriviaEntity),
            ),
          );

          // act
          numberTriviaBloc.add(GetRandomNumberTriviaEvent());
          await untilCalled(mockGetRandomNumberTriviaUsecase(any));

          // assert
          verify(
            numberTriviaBloc.getRandomNumberTriviaUsecase.call(
              NoParams(),
            ),
          );
        },
      );

      test(
        'should emit [Loading, Loaded] state, when data is gotten successfully',
        () async* {
          // arrange
          when(mockGetRandomNumberTriviaUsecase(any)).thenAnswer(
            (realInvocation) => Future.value(
              Right(tNumberTriviaEntity),
            ),
          );

          // assert later
          final expectedStates = [
            EmptyState(),
            LoadingState(),
            Loadedstate(numberTriviaEntity: tNumberTriviaEntity),
          ];
          expectLater(numberTriviaBloc.state, emitsInOrder(expectedStates));

          // act
          numberTriviaBloc.add(GetRandomNumberTriviaEvent());
        },
      );

      test(
        'should emit [Loading, Error] state, when getting data failed',
        () async* {
          // arrange
          when(mockGetRandomNumberTriviaUsecase(any)).thenAnswer(
            (realInvocation) => Future.value(
              Left(ServerFailure()),
            ),
          );

          // assert later
          final expectedStates = [
            EmptyState(),
            LoadingState(),
            ErrorState(SERVER_FAILURE_MESSAGE),
          ];
          expectLater(numberTriviaBloc.state, emitsInOrder(expectedStates));

          // act
          numberTriviaBloc.add(GetRandomNumberTriviaEvent());
        },
      );

      test(
        'should emit [Loading, Error] state, with a proper message for the erro when getting dat fails',
        () async* {
          // arrange
          when(mockGetRandomNumberTriviaUsecase(any)).thenAnswer(
            (realInvocation) => Future.value(
              Left(CacheFailure()),
            ),
          );

          // assert later
          final expectedStates = [
            EmptyState(),
            LoadingState(),
            ErrorState(CACHE_FAILURE_MESSAGE),
          ];
          expectLater(numberTriviaBloc.state, emitsInOrder(expectedStates));

          // act
          numberTriviaBloc.add(GetRandomNumberTriviaEvent());
        },
      );
      
    },
  );
}
