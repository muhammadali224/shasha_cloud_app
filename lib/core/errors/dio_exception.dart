import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';

import '../constant/app_strings.dart';
import 'failure.dart';

class ServerFailure extends Failure {
  ServerFailure({required super.message});

  factory ServerFailure.fromDioError(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.cancel:
        return ServerFailure(message: AppStrings.cancelRequest);

      case DioExceptionType.connectionTimeout:
        return ServerFailure(message: AppStrings.connectionTimeOut);

      case DioExceptionType.receiveTimeout:
        return ServerFailure(message: AppStrings.receiveTimeOut);

      case DioExceptionType.badResponse:
        return ServerFailure.fromResponse(
          dioException.response?.statusCode,
          dioException.response?.data,
        );

      case DioExceptionType.sendTimeout:
        return ServerFailure(message: AppStrings.sendTimeOut);

      case DioExceptionType.connectionError:
        return ServerFailure(message: AppStrings.socketException);

      default:
        return ServerFailure(message: AppStrings.unknownError);
    }
  }

  factory ServerFailure.fromResponse(int? statusCode, dynamic error) {
    switch (statusCode) {
      case 400:
        return ServerFailure(message: AppStrings.badRequest);
      case 401:
        return ServerFailure(message: AppStrings.unauthorized);
      case 403:
        return ServerFailure(message: AppStrings.forbidden);
      case 404:
        return ServerFailure(message: AppStrings.notFound);
      case 422:
        return ServerFailure(message: AppStrings.duplicateEmail);
      case 500:
        return ServerFailure(message: AppStrings.internalServerError);
      case 502:
        return ServerFailure(message: AppStrings.badGateway);
      default:
        return ServerFailure(message: AppStrings.unknownError);
    }
  }

  factory ServerFailure.fromFirebase(FirebaseException exception) {
    switch (exception.code) {
      case "user-not-found":
        return ServerFailure(message: AppStrings.userNotFound);
      case "email-already-in-use":
        return ServerFailure(message: AppStrings.emailAlreadyInUse);
      case "wrong-password":
        return ServerFailure(message: AppStrings.wrongPassword);
      case "invalid-email":
        return ServerFailure(message: AppStrings.invalidEmail);
      case "weak-password":
        return ServerFailure(message: AppStrings.weakPassword);
      case "account-exists-with-different-credential":
        return ServerFailure(message: AppStrings.accountExistsWithDifferent);
      case "invalid-credential":
        return ServerFailure(message: AppStrings.unknownError);

      default:
        return ServerFailure(
            message: "${AppStrings.unknownError} : $exception");
    }
  }

  @override
  String toString() => message;
}

class ServiceSuccess extends Success {
  ServiceSuccess({required super.message});

  @override
  String toString() => message;
}
