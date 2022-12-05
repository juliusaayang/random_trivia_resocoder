import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_trivia_resocoder/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

class TriviaControlls extends StatefulWidget {
  const TriviaControlls({
    Key? key,
  }) : super(key: key);

  @override
  State<TriviaControlls> createState() => _TriviaControllsState();
}

class _TriviaControllsState extends State<TriviaControlls> {
  late String inputStr;
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          onChanged: (value) {
            inputStr = value;
          },
          onSubmitted: (_) => dispatchConcrete(),
          keyboardType: TextInputType.number,
          controller: _controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Input a number',
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  dispatchConcrete();
                },
                child: Text(
                  'Search',
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
                child: TextButton(
              onPressed: () {
                dispatchRandom();
              },
              child: Text(
                'Random',
              ),
            )),
          ],
        ),
      ],
    );
  }

  void dispatchConcrete() {
    _controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context).add(
      GetConcreteNumberTriviaEvent(inputStr),
    );
  }

  void dispatchRandom() {
    BlocProvider.of<NumberTriviaBloc>(context).add(
      GetRandomNumberTriviaEvent(),
    );
  }
}
