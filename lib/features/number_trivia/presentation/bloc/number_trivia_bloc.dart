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
    on<NumberTriviaEvent>(mapEventToState);
  }

  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
    Emitter<NumberTriviaState> emit,
  ) async* {
    if (event is GetConcreteNumberTriviaEvent) {
      final inputEither =
          inputConverter.stringToUnassignedInteger(event.numberString);

      yield* inputEither.fold(
        (l) async* {
          yield ErrorState(INVALID_INPUT_FAILURE_MESSAGE);
        },
        (r) async* {
          yield LoadingState();
          final res = await getConcreteNumberTriviaUsecase(
            GetConcreteNumberTriviaParams(number: r),
          );
          yield* _eitherErrorOrLoaded(res);
        },
      );
    } else if (event is GetRandomNumberTriviaEvent) {
      print('d');
      yield LoadingState();
      final res = await getRandomNumberTriviaUsecase(
        NoParams(),
      );
      print(res);
      yield* _eitherErrorOrLoaded(res);
    }
  }

  Stream<NumberTriviaState> _eitherErrorOrLoaded(
      Either<Failure, NumberTriviaEntity> res) async* {
    yield res.fold(
      (l) => ErrorState(_mapFailureToMessage(l)),
      (r) => Loadedstate(numberTriviaEntity: r),
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
