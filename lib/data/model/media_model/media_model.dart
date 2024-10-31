import 'package:cloud_firestore/cloud_firestore.dart';

class MediaModel {
  final String id;
  final String name;
  final String type;
  final String url;
  final int sequenceNo;
  final int displayDuration;
  final DateTime dateCreated;

  MediaModel({
    required this.dateCreated,
    required this.id,
    required this.name,
    required this.type,
    required this.url,
    required this.sequenceNo,
    required this.displayDuration,
  });

  factory MediaModel.fromJson(Map<String, dynamic> json) {
    return MediaModel(
      name: json['name'],
      type: json['type'],
      url: json['url'],
      sequenceNo: json['sequenceNo'],
      displayDuration: json['displayDuration'],
      id: json['id'],
      dateCreated: (json['dateCreated'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'url': url,
      'sequenceNo': sequenceNo,
      'displayDuration': displayDuration,
      'dateCreated': dateCreated,
    };
  }

  factory MediaModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MediaModel(
      id: doc.id,
      name: data['name'],
      type: data['type'],
      url: data['url'],
      sequenceNo: data['sequenceNo'],
      displayDuration: data['displayDuration'],
      dateCreated: (data['dateCreated'] as Timestamp).toDate(),
    );
  }

  MediaModel copyWith({
    String? id,
    String? name,
    String? type,
    String? url,
    int? sequenceNo,
    int? displayDuration,
    DateTime? dateCreated,
  }) {
    return MediaModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      url: url ?? this.url,
      sequenceNo: sequenceNo ?? this.sequenceNo,
      displayDuration: displayDuration ?? this.displayDuration,
      dateCreated: dateCreated ?? this.dateCreated,
    );
  }

  @override
  String toString() {
    return '''
      id: $id,
      name: $name,
      type: $type,
      url: $url,
      sequenceNo: $sequenceNo,
      displayDuration: $displayDuration,
      dateCreated: $dateCreated,
    ''';
  }
}
