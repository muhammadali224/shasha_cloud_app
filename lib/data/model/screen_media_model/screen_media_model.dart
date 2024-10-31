import 'package:cloud_firestore/cloud_firestore.dart';

import '../media_model/media_model.dart';

class ScreenMediaModel {
  final String id;
  final List<MediaModel> mediaList;
  final DateTime dateCreated;

  ScreenMediaModel({
    required this.mediaList,
    required this.id,
    required this.dateCreated,
  });

  Map<String, dynamic> toJson() {
    return {
      'dateCreated': dateCreated,
      'mediaList': mediaList.map((media) => media.toJson()).toList(),
    };
  }

  factory ScreenMediaModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ScreenMediaModel(
      id: doc.id,
      dateCreated: (data['dateCreated'] as Timestamp).toDate(),
      mediaList: (data['mediaList'] as List<dynamic>)
          .map((item) => MediaModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  String toString() {
    return '''
      "Id": $id
      "Media List ": ${mediaList.toString()},
      "date created: $dateCreated
  ''';
  }
}
