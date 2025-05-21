import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ゲスト（匿名）ログイン
  Future<UserModel?> signInAnonymously() async {
    final result = await _auth.signInAnonymously();
    return _userFromFirebase(result.user);
  }

  // Googleログイン
  Future<UserModel?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null;

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final result = await _auth.signInWithCredential(credential);
    return _userFromFirebase(result.user);
  }

  // サインアウト
  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
  }

  // Firebase User から UserModel へ変換
  UserModel? _userFromFirebase(User? user) {
    if (user == null) return null;
    return UserModel(
      uid: user.uid,
      displayName: user.displayName,
      email: user.email,
      photoUrl: user.photoURL,
      isAnonymous: user.isAnonymous,
    );
  }

  // 現在のユーザー取得
  UserModel? get currentUser => _userFromFirebase(_auth.currentUser);
}