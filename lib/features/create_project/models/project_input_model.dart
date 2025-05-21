class ProjectInputModel {
  final String title;
  final String? description;
  final bool hasImage;
  final List<String> itemTitles;

  ProjectInputModel({
    required this.title,
    this.description,
    required this.hasImage,
    required this.itemTitles,
  });
}