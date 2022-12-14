import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:random_trivia_resocoder/core/error/failure.dart';
import 'package:random_trivia_resocoder/core/usecase/usecase.dart';
import 'package:random_trivia_resocoder/core/utils/input_converter.dart';
import 'package:random_trivia_resocoder/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:random_trivia_resocoder/features/number_trivia/domain/usecases/get_concreate_number_trivia_usecase.dart';
import 'package:random_trivia_resocoder/features/number_trivia/domain/usecases/get_random_number_trivia_usecase.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTriviaUsecase getConcreteNumberTriviaUsecase;
  final GetRandomNumberTriviaUsecase getRandomNumberTriviaUsecase;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required this.getConcreteNumberTriviaUsecase,
    required this.getRandomNumberTriviaUsecase,
    required this.inputConverter,
  }) : super(EmptyState()) {
    on<NumberTriviaEvent>(
      (event, emit) async {
        await trivia(event, emit);
      },
    );
  }

  // thissss
  
  FutureOr<void> trivia(
    NumberTriviaEvent event,
    Emitter<NumberTriviaState> emit,
  ) async {
    if (event is GetConcreteNumberTriviaEvent) {
      final inputEither =
          inputConverter.stringToUnassignedInteger(event.numberString);

      await inputEither.fold(
        (l) {
          emit(ErrorState(INVALID_INPUT_FAILURE_MESSAGE));
        },
        (r) async {
          emit(LoadingState());
          final res = await getConcreteNumberTriviaUsecase(
            GetConcreteNumberTriviaParams(number: r),
          );
          _eitherErrorOrLoaded(res, emit);
        },
      );
    } else if (event is GetRandomNumberTriviaEvent) {
      emit(LoadingState());
      final res = await getRandomNumberTriviaUsecase(
        NoParams(),
      );
      _eitherErrorOrLoaded(res, emit);
    }
  }

  _eitherErrorOrLoaded(
    Either<Failure, NumberTriviaEntity> res,
    Emitter<NumberTriviaState> emit,
  ) async {
    return res.fold(
      (l) => emit(
        ErrorState(_mapFailureToMessage(l)),
      ),
      (r) => emit(
        Loadedstate(numberTriviaEntity: r),
      ),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zere';
