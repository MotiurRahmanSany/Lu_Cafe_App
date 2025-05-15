import 'package:fpdart/fpdart.dart';
import 'package:lu_cafe/core/failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureEitherVoid = FutureEither<void>;
