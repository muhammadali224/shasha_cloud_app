import 'package:dartz/dartz.dart';

import '../../../core/errors/failure.dart';
import '../../model/user_model/user_model.dart';

abstract class ClientRepository {
  // Future<Either<Failure, Success>> addClient(ClientModel client);

  // Future<Either<Failure, Success>> updateClient(ClientModel client);

  // Future<Either<Failure, Success>> deleteClient(String clientId);

  Stream<Either<Failure, List<UserModel>>> getClientsAsStream();

  Stream<Either<Failure, List<Map<String, dynamic>>>> getClientStream(
      {required String id});

  Future<Either<Failure, Success>> addClientScreen(String clientId);
  Future<Either<Failure, Success>> deleteClientScreen(
      {required String userId, required String screenId});
}
