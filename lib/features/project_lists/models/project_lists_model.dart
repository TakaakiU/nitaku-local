class RankingProjectModel {
  final String projectId;
  final String title;
  final String description;
  final bool hasImage;
  final String displayName;
  final String createdBy;
  final DateTime? createdAt;
  final List<ProjectItemModel> items;

  RankingProjectModel({
    required this.projectId,
    required this.title,
    required this.description,
    required this.hasImage,
    required this.displayName,
    required this.createdBy,
    this.createdAt,
    required this.items,
  });
}

class ProjectItemModel {
  final String itemId;
  final String title;
  final String? imageUrl;

  ProjectItemModel({
    required this.itemId,
    required this.title,
    this.imageUrl,
  });
}