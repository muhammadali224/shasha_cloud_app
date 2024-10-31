import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/dio_exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../model/user_model/user_model.dart';
import '../../../repository/client_repo/client.repo.dart';

class ClientData implements ClientRepository {
  final FirebaseFirestore _firebaseFirestore;

  ClientData({required FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore;

  @override
  Stream<Either<Failure, List<UserModel>>> getClientsAsStream() async* {
    try {
      yield* _firebaseFirestore.collection('users').snapshots().map(
        (querySnapshot) {
          final users = querySnapshot.docs.map((doc) {
            return UserModel.fromDocumentSnapshot(doc);
          }).toList();

          return right(users);
        },
      );
    } catch (e) {
      yield left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<Map<String, dynamic>>>> getClientStream(
      {required String id}) async* {
    try {
      yield* _firebaseFirestore
          .collection('users')
          .doc(id)
          .collection('screens')
          .orderBy("dateCreated", descending: true)
          .snapshots()
          .map((querySnapshot) {
        final List<Map<String, dynamic>> screens =
            querySnapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return data;
        }).toList();

        return right(screens);
      });
    } catch (e) {
      yield left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Success>> addClientScreen(String clientId) async {
    try {
      final data = _firebaseFirestore
          .collection('users')
          .doc(clientId)
          .collection("screens")
          .doc();
      await data.set({
        'dateCreated': DateTime.now(),
        'mediaList': [],
      });

      final screenData =
          _firebaseFirestore.collection('all_screens').doc(data.id);
      await screenData.set({'id': clientId});

      // await clientDocRef.update({
      //   'mediaList': FieldValue.arrayUnion([media.toJson()])
      // });

      return right(ServiceSuccess(message: 'Media uploaded successfully'));
    } catch (e) {
      if (e is FirebaseException) {
        return left(ServerFailure.fromFirebase(e));
      }
      return left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Success>> deleteClientScreen(
      {required String userId, required String screenId}) async {
    try {
      final data = _firebaseFirestore
          .collection('users')
          .doc(userId)
          .collection("screens")
          .doc(screenId);
      await data.delete();

      final screenData =
          _firebaseFirestore.collection('all_screens').doc(screenId);
      await screenData.delete();

      return right(ServiceSuccess(message: 'Media uploaded successfully'));
    } catch (e) {
      if (e is FirebaseException) {
        return left(ServerFailure.fromFirebase(e));
      }
      return left(ServerFailure(message: e.toString()));
    }
  }
}
