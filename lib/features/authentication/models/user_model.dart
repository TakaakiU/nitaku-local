class UserModel {
  final String uid;
  final String? displayName;
  final String? email;
  final String? photoUrl;
  final bool isAnonymous;
  final bool isDeleted;

  UserModel({
    required this.uid,
    this.displayName,
    this.email,
    this.photoUrl,
    this.isAnonymous = false,
    this.isDeleted = false,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      displayName: map['displayName'],
      email: map['email'],
      photoUrl: map['photoUrl'],
      isAnonymous: map['isAnonymous'] ?? false,
      isDeleted: map['isDeleted'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'photoUrl': photoUrl,
      'isAnonymous': isAnonymous,
      'isDeleted': isDeleted,
    };
  }
}