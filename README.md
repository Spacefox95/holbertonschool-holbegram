# Holbegram

Holbegram est une application mobile developpee avec Flutter. Elle reprend les principes d'un reseau social centre sur le partage d'images : creation de compte, connexion, profil utilisateur, fil de publications, ajout d'images et favoris.

Le projet utilise Firebase pour l'authentification et la base de donnees, ainsi que Cloudinary pour le stockage distant des images.

## Fonctionnalites

- Inscription avec email, mot de passe, nom d'utilisateur et photo de profil.
- Connexion et deconnexion avec Firebase Authentication.
- Redirection automatique selon l'etat de session de l'utilisateur.
- Affichage d'un fil de publications.
- Ajout d'une publication avec image et legende.
- Stockage des publications dans Cloud Firestore.
- Upload des images vers Cloudinary.
- Profil utilisateur avec photo, nom, biographie, nombre de posts, abonnes et abonnements.
- Affichage des publications de l'utilisateur sous forme de grille.
- Ajout et retrait de publications dans les favoris.
- Navigation principale avec barre de navigation inferieure.

## Stack technique

- **Flutter / Dart** : application mobile et interface utilisateur.
- **Firebase Core** : initialisation de Firebase dans l'application.
- **Firebase Authentication** : gestion des comptes et des sessions.
- **Cloud Firestore** : stockage des utilisateurs, publications et favoris.
- **Cloudinary** : stockage des images de profil et des publications.
- **Provider** : gestion de l'etat utilisateur.
- **Image Picker** : selection d'images depuis l'appareil.
- **HTTP** : envoi des images vers Cloudinary via requetes multipart.
- **UUID** : generation d'identifiants uniques.

## Architecture du projet

```text
lib/
+-- main.dart
+-- firebase_options.dart
+-- methods/
|   +-- auth_methods.dart
+-- models/
|   +-- post.dart
|   +-- user.dart
+-- providers/
|   +-- user_provider.dart
+-- screens/
|   +-- home.dart
|   +-- login_screen.dart
|   +-- signup_screen.dart
|   +-- upload_image_screen.dart
|   +-- auth/
|   |   +-- methods/
|   |       +-- user_storage.dart
|   +-- pages/
|       +-- add_image.dart
|       +-- favorite.dart
|       +-- feed.dart
|       +-- profile_screen.dart
|       +-- search.dart
|       +-- methods/
|           +-- post_storage.dart
+-- utils/
|   +-- posts.dart
+-- widgets/
    +-- bottom_nav.dart
    +-- text_field.dart
```

L'application est organisee en plusieurs couches :

- **Presentation** : ecrans Flutter et widgets reutilisables.
- **Etat applicatif** : provider utilisateur.
- **Logique metier** : authentification, gestion des posts et favoris.
- **Modeles** : representation des utilisateurs et publications.
- **Services distants** : Firebase Authentication, Firestore et Cloudinary.

## Securite

Le projet s'appuie sur Firebase Authentication pour eviter de gerer directement les mots de passe dans l'application. L'etat de connexion est controle au demarrage avec `authStateChanges`, ce qui limite l'acces aux ecrans principaux aux utilisateurs connectes.

Les donnees applicatives sont stockees dans Firestore avec des identifiants utilisateurs et publications uniques. Les images sont envoyees vers Cloudinary et l'application conserve les URL HTTPS retournees par le service.

> Important : les regles de securite Firebase et la configuration Cloudinary doivent etre configurees cote console avant une utilisation en production.

## Prerequis

- Flutter SDK installe.
- Dart compatible avec le SDK defini dans `pubspec.yaml`.
- Un projet Firebase configure.
- Une application Android Firebase avec le fichier `google-services.json`.
- Un compte Cloudinary avec un cloud name et un upload preset.

## Installation

Clonez le projet puis installez les dependances :

```bash
flutter pub get
```

Verifiez les appareils disponibles :

```bash
flutter devices
```

Lancez l'application :

```bash
flutter run
```

## Configuration Firebase

Le projet contient une configuration Firebase generee pour Flutter :

- `firebase.json`
- `lib/firebase_options.dart`
- `android/app/google-services.json`

Si vous utilisez votre propre projet Firebase, regenerez la configuration avec FlutterFire CLI :

```bash
flutterfire configure
```

Activez ensuite les services necessaires dans la console Firebase :

- Authentication avec la connexion email/mot de passe.
- Cloud Firestore pour les collections `users` et `posts`.

## Configuration Cloudinary

Les uploads d'images utilisent Cloudinary dans :

- `lib/screens/auth/methods/user_storage.dart`
- `lib/methods/auth_methods.dart`

Renseignez les valeurs Cloudinary avant d'utiliser l'upload :

```dart
final String cloudinaryUrl =
    "https://api.cloudinary.com/v1_1/<cloud-name>/image/upload";
final String cloudinaryPreset = "<upload-preset>";
```

Pour une application en production, evitez de laisser des secrets ou parametres sensibles directement dans le code source. Utilisez une configuration adaptee a l'environnement de deploiement.

## Donnees principales

### Utilisateur

Un utilisateur contient notamment :

- `uid`
- `email`
- `username`
- `bio`
- `photoUrl`
- `followers`
- `following`
- `posts`
- `saved`
- `searchKey`

### Publication

Une publication contient notamment :

- `caption`
- `uid`
- `username`
- `likes`
- `postId`
- `datePublished`
- `postUrl`
- `profImage`

## Commandes utiles

Analyser le projet :

```bash
flutter analyze
```

Lancer les tests :

```bash
flutter test
```

Mettre a jour les dependances :

```bash
flutter pub upgrade
```

## Statut

Holbegram est un projet d'apprentissage permettant de mettre en pratique le developpement d'une application mobile multicouche connectee a des services cloud.
