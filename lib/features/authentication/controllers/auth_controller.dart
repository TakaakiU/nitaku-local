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
import 'package:flutter_dotenv/flutter_dotenv.dart'; // 環境変数の読み込み

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
      if (kIsWeb) {
        // Webの場合：signInWithPopup を利用
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider.addScope('https://www.googleapis.com/auth/contacts.readonly');
        googleProvider.setCustomParameters({'login_hint': 'user@example.com'});
        UserCredential userCredential = await _auth.signInWithPopup(googleProvider);
        return userCredential.user;
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
        return userCredential.user;
      }
    } catch (e, stack) {
      logError("Google ログインエラー: ${e.toString()}");
      logError(stack.toString());
      return null;
    }
  }

  // --- Apple アカウントによるサインイン（Web・iOS両対応） ---
  Future<User?> signInWithApple() async {
    try {
      // nonce を自前生成
      String rawNonce = _generateNonce();
      String hashedNonce = _sha256OfString(rawNonce);

      if (kIsWeb) {
        // Webの場合：webAuthenticationOptions が必要
        final appleCredential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          webAuthenticationOptions: WebAuthenticationOptions(
            clientId: dotenv.env['APPLE_WEB_CLIENT_ID']!, // ← .envから取得
            redirectUri: Uri.parse(dotenv.env['APPLE_WEB_REDIRECT_URI']!), // ← .envから取得
          ),
          nonce: hashedNonce, // ハッシュ化した nonce を渡す
        );
        final oauthCredential = OAuthProvider("apple.com").credential(
          idToken: appleCredential.identityToken,
          rawNonce: rawNonce, // 生成した rawNonce を渡す
        );
        UserCredential userCredential = await _auth.signInWithCredential(oauthCredential);
        return userCredential.user;
      } else if (Platform.isIOS) {
        // iOSの場合
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
        return userCredential.user;
      } else {
        logError("Apple Sign In is available only on Web or iOS devices.");
        return null;
      }
    } catch (e, stack) {
      logError("Apple ログインエラー: ${e.toString()}");
      logError(stack.toString());
      return null;
    }
  }

  // --- 匿名（ゲスト）サインイン ---
  Future<User?> signInAnonymously() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      return userCredential.user;
    } catch (e, stack) {
      logError("匿名ログインエラー: ${e.toString()}");
      logError(stack.toString());
      return null;
    }
  }
}
