# NITAKU（二択）

![NITAKUアプリのデモ動画](docs/NITAKU_Demo.webp)
*開発中の画面*

## 概要

みんなでランキング表をつくろう！

## 必要条件

- Android XX以降
- iOS XX以降
- Chrome XX以降

※ 動作確認後、反映予定。

## 使用方法

記載予定。

## 参照

[ソートくりえいと](https://sreate.com/)（開発者：[@dachikabosu](https://x.com/dachikabosu)）を参考。

## 作者

[TakaakiU](https://x.com/takaakiu_81z)

## 要件

以降の内容は、[個人サイト](https://takaakiu.github.io)のプロジェクト管理に転載しREADMEでは削除する予定。

### 機能仕様

- **ランキング表を生成**
  - 総当たり比較を（2つの選択肢を何度も繰り返す）行い、最終的に評価対象のランキング表を生成。
  - ToC向け
- **ユーザー認証**
  - **Googleアカウントでのログイン:** Firebase Authentication を利用してユーザーがGoogleアカウントでログイン可能。~~プロフィール編集やユーザー操作履歴の参照が可能~~（現在、未実装）
  - **ゲストアカウント（匿名）でのログイン:** 匿名認証を利用し、ログインはできるがユーザー操作履歴は保存しない。
  - ~~**Appleアカウントでのログイン:**~~（現在未実装）
- **テーマ（プロジェクト）のマスター管理**
  - 総当たり比較をする対象テーマ（プロジェクト）は、**テキスト**または~~**テキスト＋画像**~~（現在、未実装）の形式で管理。
- ~~**画像管理**~~（現在、未実装）
  - ユーザーがアップロードする画像はFirebase Storageで管理。
  - 必要に応じてCloud Functionsで画像の圧縮やリサイズなどの処理を実施。

---

### 開発フロー

- **設計と要件定義**
  - 機能一覧（総当たり比較、ログイン認証、プロジェクト管理等）の整理。
  - 画面設計（ワイヤーフレーム、UI/UXデザイン）と使用技術（Firebase各種、Flutter）の選定。
- **環境構築**
  - Flutter（Dart）の開発環境をWindows環境でFlutter SDKを導入しVS Codeで開発
  - Flutter（Dart）の開発環境をMacOS環境でも構築（Docker for MacOSによるコンテナを使用）
  - Firebaseプロジェクトの作成および各種サービス（Authentication、Firestore、Storage、Functions）の初期設定。
  - 必要なFlutterパッケージ（`firebase_auth`, `cloud_firestore`, `firebase_storage`など）の導入。
- **ユーザー認証実装**
  - Firebase Authentication を利用したGoogleログインとAppleログインの実装。
    Web・Appleは、GoogleアカウントとAppleアカウント、ゲストログイン。AndroidではGoogleアカウントとゲストログイン。
  - 匿名（ゲスト）ログイン機能の実装と、ユーザー履歴を残さない設定。
- **総当たり比較機能の実装**
  - Firestoreにプロジェクトデータを保存する設計。
  - Firebase Functions やクライアント側ロジックで総当たり比較と順位付けのロジック処理。
- **画像アップロード機能の実装**
  - Flutter側での画像アップロードUIの構築と、Firebase Storageへの連携。
  - 必要に応じたCloud Functionsによる画像処理機能の追加。
- **テスト & デバッグ**
  - ユニットテスト・UIテストの実施で各機能の動作検証。
  - ゲストユーザー利用時の挙動（履歴の残らなさなど）の確認。
- **デプロイと運用**
  - Firebase HostingやApp Store/Play Storeへのリリース手順の整備。
  - Firebase AnalyticsやCrashlyticsを活用した運用・モニタリングの設計。

---

### 費用管理・無料プラン活用とアクセス制限

- **無料プラン活用**
  - Flutter（Dart）自体は無料。
  - Firebase Sparkプランの無料枠内で、**Authentication、Firestore、Storage、Functions、Hosting** を利用
- **課金発生時のアクセス制限**
  - **Firestoreセキュリティルール:** ユーザーの課金状況（フラグ管理？）に応じたデータの読み書き制御を実装。
  - **Firebase Functions:** ユーザーの課金状態をチェックし、無料プランの制限を超えた場合にエラーメッセージや処理停止を実施。
  - **Flutterアプリ側UI制御:** 課金が必要な機能については、UI上でアクセス制御し、無料ユーザーには表示しない・操作できない仕様を実装。

---

## 今後、実装すること

- UI/UXの見直し
    初期状態なので見た目をモダンにしたい。
- Appleアカウントでのログインを実装
    ※ Apple Developerの契約などが必要
- ユーザー管理機能
    プロフィール編集やユーザーの操作履歴参照、アカウント削除（削除後、ユーザーに紐づくデータ制御も）
- テーマ作成時の画像付与
    Firebase storageを活用して機能を実装したい。ちまたの情報だとSparkプランで可能との事だったが、
    コンソールをみると課金プランにアップグレードと表示されているため、課金が必要かも。
- 開発環境の移行
    現在、WindowsでFlutter SDKがインストールされた環境をメインに開発しているが、MacOS + Docker環境に移行したい。
- Firebase Hostingへの発行
- Google Store（Google Play）やApple Storeへの申請

---

### **1. 開発構成**

### **フロントエンド**

- **言語・フレームワーク:** Flutter（Dart）
- **UIコンポーネント:** `Material` または `Cupertino` ウィジェット
- **状態管理:** `Riverpod` / `Bloc`
- **パッケージ:**
  - `firebase_auth`（ユーザー認証）
  - `cloud_firestore`（順位付けデータ管理）
  - `firebase_storage`（画像管理）
  - `flutter_hooks`, `provider`（状態管理補助）

### **バックエンド**

- **認証:** Firebase Authentication
- **データベース:** Firestore
- **ストレージ:** Firebase Storage
- **クラウド処理:** Firebase Functions
- **コンテナ化:** Dockerを用いた開発環境の統一

---

### **2. Docker導入のポイント**

1. **Flutter開発環境のコンテナ化**
   - `flutter` の公式 Docker イメージ or カスタム環境を構築
   - **ローカル実行:** `Docker Compose` を活用し、アプリとバックエンドを管理
   - **CI/CD:** GitHub Actions で Docker によるビルドを統合
2. **Firebaseの開発**
   - `firebase-tools` を Docker イメージ内で管理
   - Firestore / Authentication のエミュレーター環境構築
3. **Flutterアプリのデプロイ**
   - **Web版:** `Firebase Hosting` へデプロイ（Dockerで開発管理）
   - **モバイル版:** `docker run` でビルドし、テスト実施
4. **バックエンドの統一**
   - **Node.jsベースの Firebase Functions** をコンテナ化し、ローカル環境構築
   - 画像処理は Cloud Functions 内で実行可能
