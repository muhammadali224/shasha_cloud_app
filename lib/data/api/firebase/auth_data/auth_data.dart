import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/constant/app_strings.dart';
import '../../../../core/errors/dio_exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../../main.dart';
import '../../../model/user_model/user_model.dart';
import '../../../repository/login_repo/auth.repo.dart';

class AuthData implements AuthRepository {
  final FirebaseAuth _firebaseAuth;

  final FirebaseFirestore _firebaseFirestore;

  AuthData(
      {required FirebaseAuth firebaseAuth,
      required FirebaseFirestore firebaseFirestore})
      : _firebaseAuth = firebaseAuth,
        _firebaseFirestore = firebaseFirestore;

  @override
  Future<Either<Failure, UserModel?>> login(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      final result = await _firebaseFirestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();
      logger.d(result);
      if (result.exists) {
        final UserModel user = UserModel.fromDocumentSnapshot(result);
        logger.d(user.toString());

        return right(user);
      } else {
        return left(ServerFailure(message: AppStrings.userNotFound));
      }
    } catch (e) {
      logger.e(e);

      if (e is FirebaseException) {
        return left(ServerFailure.fromFirebase(e));
      }
      return left(ServerFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, String?>> getUser({required String screenId}) async {
    try {
      final result = await _firebaseFirestore
          .collection('all_screens')
          .doc(screenId)
          .get();
      logger.d(result);
      if (result.exists) {
        return right(result['id']);
      } else {
        return left(ServerFailure(message: AppStrings.userNotFound));
      }
    } catch (e) {
      logger.e(e);

      if (e is FirebaseException) {
        return left(ServerFailure.fromFirebase(e));
      }
      return left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel?>> register({
    required String email,
    required String name,
    required String password,
    required String role,
  }) async {
    try {
      UserCredential? userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      final user = UserModel(
        id: userCredential.user!.uid,
        email: email,
        role: role,
        dateCreated: DateTime.now(),
        name: name,
      );

      await _firebaseFirestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(user.toJson());
      logger.d(user.toString());
      return right(user);
    } catch (e) {
      logger.e(e);
      if (e is FirebaseException) {
        return left(ServerFailure.fromFirebase(e));
      }
      return left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Success>> resetPassword(
      {required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return right(ServiceSuccess(message: 'Password reset email sent'));
    } catch (e) {
      logger.e(e);

      if (e is FirebaseException) {
        return left(ServerFailure.fromFirebase(e));
      }
      return left(ServerFailure(
          message: 'Failed to send password reset email: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Success>> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return right(ServiceSuccess(message: 'Successfully signed out'));
    } catch (e) {
      logger.e(e);

      if (e is FirebaseException) {
        return left(ServerFailure.fromFirebase(e));
      }
      return left(
          ServerFailure(message: 'Failed to sign out: ${e.toString()}'));
    }
  }
}
