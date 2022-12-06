import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_trivia_resocoder/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:random_trivia_resocoder/features/number_trivia/presentation/widgets/widgets.dart';
import 'package:random_trivia_resocoder/injection_container.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Number Trivia',
        ),
      ),
      body: SingleChildScrollView(
        child: buildBody(context),
      ),
    );
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider<NumberTriviaBloc>(
      create: (context) => sl<NumberTriviaBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              // first half
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (context, state) {
                  print(state);
                  if (state is EmptyState) {
                    return MessageDisplay(
                      message: 'Start Searching',
                    );
                  } else if (state is ErrorState) {
                    return MessageDisplay(
                      message: state.message,
                    );
                  } else if (state is Loadedstate) {
                    return TriviaWidget(
                      numberTriviaEntity: state.numberTriviaEntity,
                    );
                  } else if (state is LoadingState) {
                    return Loadingwidget();
                  } else {
                    return MessageDisplay(
                      message: 'Start Searching',
                    );
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              // bottom half
              TriviaControlls(),
            ],
          ),
        ),
      ),
    );
  }
}
