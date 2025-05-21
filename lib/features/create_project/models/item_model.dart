import 'package:cloud_firestore/cloud_firestore.dart';
class ProjectModel {
  final String projectId;
  final String title;
  final String? description;
  final bool hasImage;
  final bool isDeleted;
  final DateTime createdAt;
  final String? createdBy;
  final DateTime updatedAt;
  final String? updatedBy;
  final DateTime? deletedAt;
  final String? deletedBy;

  ProjectModel({
    required this.projectId,
    required this.title,
    this.description,
    this.hasImage = false,
    this.isDeleted = false,
    required this.createdAt,
    this.createdBy,
    required this.updatedAt,
    this.updatedBy,
    this.deletedAt,
    this.deletedBy,
  });

  Map<String, dynamic> toMap() {
    return {
      'projectId': projectId,
      'title': title,
      'description': description,
      'hasImage': hasImage,
      'isDeleted': isDeleted,
      'createdAt': Timestamp.fromDate(createdAt),
      'createdBy': createdBy,
      'updatedAt': Timestamp.fromDate(updatedAt),
      'updatedBy': updatedBy,
      'deletedAt': deletedAt != null ? Timestamp.fromDate(deletedAt!) : null,
      'deletedBy': deletedBy,
    };
  }

  factory ProjectModel.fromMap(Map<String, dynamic> map) {
    return ProjectModel(
      projectId: map['projectId'],
      title: map['title'],
      description: map['description'],
      hasImage: map['hasImage'] ?? false,
      isDeleted: map['isDeleted'] ?? false,
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      createdBy: map['createdBy'],
      updatedAt: map['updatedAt'] != null
          ? (map['updatedAt'] as Timestamp).toDate()
          : DateTime.now(),
      updatedBy: map['updatedBy'],
      deletedAt: map['deletedAt'] != null
          ? (map['deletedAt'] as Timestamp).toDate()
          : null,
      deletedBy: map['deletedBy'],
    );
  }

  ProjectModel copyWith({
    String? projectId,
    String? title,
    String? description,
    bool? hasImage,
    bool? isDeleted,
    DateTime? createdAt,
    String? createdBy,
    DateTime? updatedAt,
    String? updatedBy,
    DateTime? deletedAt,
    String? deletedBy,
  }) {
    return ProjectModel(
      projectId: projectId ?? this.projectId,
      title: title ?? this.title,
      description: description ?? this.description,
      hasImage: hasImage ?? this.hasImage,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      deletedAt: deletedAt ?? this.deletedAt,
      deletedBy: deletedBy ?? this.deletedBy,
    );
  }
}

class ItemModel {
  final String itemId;
  final DocumentReference projectRef;
  final String title;
  final String? imageUrl;

  ItemModel({
    required this.itemId,
    required this.projectRef,
    required this.title,
    this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      'projectRef': projectRef,
      'title': title,
      'imageUrl': imageUrl,
    };
  }

  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      itemId: map['itemId'],
      projectRef: map['projectRef'],
      title: map['title'],
      imageUrl: map['imageUrl'],
    );
  }
}