// lib/features/authentication/controllers/auth_controller.dart

import 'dart:convert';
import 'dart:math';
import 'dart:io' show Platform;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:crypto/crypto.dart';
import '../../../shared/utils/logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// --- Nonce生成用の関数群 ---
  /// 指定した長さのランダムな文字列（nonce）を生成する
  String _generateNonce([int length = 32]) {
    const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  }

  /// 入力文字列の SHA256 ハッシュ値（16進数文字列）を返す
  String _sha256OfString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // --- Google アカウントによるサインイン ---
  Future<User?> signInWithGoogle() async {
    try {
      User? user;
      if (kIsWeb) {
        // Webの場合：signInWithPopup を利用
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider.addScope('https://www.googleapis.com/auth/contacts.readonly');
        googleProvider.setCustomParameters({'login_hint': 'user@example.com'});
        UserCredential userCredential = await _auth.signInWithPopup(googleProvider);
        user = userCredential.user;
      } else {
        // モバイルの場合：google_sign_in を利用
        final GoogleSignIn googleSignIn = GoogleSignIn();
        final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
        if (googleUser == null) return null; // ユーザーキャンセル
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        UserCredential userCredential = await _auth.signInWithCredential(credential);
        user = userCredential.user;
      }
      if (user != null) {
        await saveUserToFirestore(user);
      }
      return user;
    } catch (e, stack) {
      logError("Google ログインエラー: ${e.toString()}");
      logError(stack.toString());
      return null;
    }
  }

  // --- Apple アカウントによるサインイン（Web・iOS両対応） ---
  Future<User?> signInWithApple() async {
    try {
      String rawNonce = _generateNonce();
      String hashedNonce = _sha256OfString(rawNonce);

      User? user;
      if (kIsWeb) {
        final appleCredential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          webAuthenticationOptions: WebAuthenticationOptions(
            clientId: dotenv.env['APPLE_WEB_CLIENT_ID']!,
            redirectUri: Uri.parse(dotenv.env['APPLE_WEB_REDIRECT_URI']!),
          ),
          nonce: hashedNonce,
        );
        final oauthCredential = OAuthProvider("apple.com").credential(
          idToken: appleCredential.identityToken,
          rawNonce: rawNonce,
        );
        UserCredential userCredential = await _auth.signInWithCredential(oauthCredential);
        user = userCredential.user;
      } else if (Platform.isIOS) {
        final appleCredential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          nonce: hashedNonce,
        );
        final oauthCredential = OAuthProvider("apple.com").credential(
          idToken: appleCredential.identityToken,
          rawNonce: rawNonce,
        );
        UserCredential userCredential = await _auth.signInWithCredential(oauthCredential);
        user = userCredential.user;
      } else {
        logError("Apple Sign In is available only on Web or iOS devices.");
        return null;
      }

      if (user != null) {
        await saveUserToFirestore(user);
      }
      return user;
    } catch (e, stack) {
      logError("Apple ログインエラー: ${e.toString()}");
      logError(stack.toString());
      return null;
    }
  }

  // --- ゲスト（匿名）サインイン ---
  Future<User?> signInAnonymously() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      return userCredential.user;
    } catch (e, stack) {
      logError("ゲスト ログインエラー: ${e.toString()}");
      logError(stack.toString());
      return null;
    }
  }

  // Firestoreにユーザー情報を保存（初回のみ）
  Future<void> saveUserToFirestore(User user) async {
    final userDoc = _firestore.collection('users').doc(user.uid);
    final docSnapshot = await userDoc.get();

    if (!docSnapshot.exists) {
      await userDoc.set({
        'uid': user.uid,
        'displayName': user.displayName,
        'email': user.email,
        'photoUrl': user.photoURL,
        'createdAt': FieldValue.serverTimestamp(),
        'isAnonymous': user.isAnonymous,
        'isDeleted': false,
      });
    }
  }

  // サインアウト処理
  Future<void> signOut() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        // プロバイダーIDを取得
        final providerId = user.providerData.isNotEmpty
            ? user.providerData[0].providerId
            : null;

        // Googleの場合はGoogleSignInを実行
        if (providerId == 'google.com') {
          try {
            await GoogleSignIn().signOut();
          } catch (_) {
            // GoogleSignIn未使用時は何もしない
          }
        }
        // Appleや匿名はFirebaseAuthのsignOutのみ
      }
      await _auth.signOut();
    } catch (e, stack) {
      logError("サインアウトエラー: ${e.toString()}");
      logError(stack.toString());
    }
  }
}
