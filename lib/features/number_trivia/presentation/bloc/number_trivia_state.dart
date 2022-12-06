part of 'number_trivia_bloc.dart';

abstract class NumberTriviaState extends Equatable {
  const NumberTriviaState();

  @override
  List<Object> get props => [];
}

class EmptyState extends NumberTriviaState {}

class LoadingState extends NumberTriviaState {}

class Loadedstate extends NumberTriviaState {
  final NumberTriviaEntity numberTriviaEntity;
  const Loadedstate({
    required this.numberTriviaEntity,
  });
}

class ErrorState extends NumberTriviaState {
  final String message;
  const ErrorState(this.message);
}
