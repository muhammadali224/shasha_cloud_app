import 'package:dartz/dartz.dart';

import '../../../core/errors/failure.dart';
import '../../model/user_model/user_model.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserModel?>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserModel?>> register({
    required String email,
    required String name,
    required String password,
    required String role,
  });

  Future<Either<Failure, Success>> signOut();

  Future<Either<Failure, Success>> resetPassword({required String email});
}
