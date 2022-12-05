import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:random_trivia_resocoder/core/network/network_info.dart';
import 'package:random_trivia_resocoder/core/utils/input_converter.dart';
import 'package:random_trivia_resocoder/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:random_trivia_resocoder/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:random_trivia_resocoder/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:random_trivia_resocoder/features/number_trivia/domain/usecases/get_concreate_number_trivia_usecase.dart';
import 'package:random_trivia_resocoder/features/number_trivia/domain/usecases/get_random_number_trivia_usecase.dart';
import 'package:random_trivia_resocoder/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'features/number_trivia/data/datasources/number_trivia_local_datasource.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Feautres  - Number Trivia
  // Bloc
  sl.registerFactory(
    () => NumberTriviaBloc(
      getConcreteNumberTriviaUsecase: sl(),
      getRandomNumberTriviaUsecase: sl(),
      inputConverter: sl(),
    ),
  );

  // usecases
  sl.registerLazySingleton(
      () => GetConcreteNumberTriviaUsecase(numberTriviaRepository: sl()));
  sl.registerLazySingleton(
      () => GetRandomNumberTriviaUsecase(numberTriviaRepository: sl()));

  // repositories
  sl.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      netWorkInfo: sl(),
      numberTriviaRemoteDatasource: sl(),
      numberTriviaLocalDatasource: sl(),
    ),
  );

  // datasource
  sl.registerLazySingleton<NumberTriviaRemoteDatasource>(
    () => NumberTriviaRemoteDatasourceImpl(
      client: sl(),
    ),
  );

  sl.registerLazySingleton<NumberTriviaLocalDatasource>(
    () => NumberTriviaLocalDataSourceImpl(
      sharedPreferences: sl(),
    ),
  );

  //! core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetWorkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => DataConnectionChecker());
  sl.registerLazySingleton(() => http.Client());
}
