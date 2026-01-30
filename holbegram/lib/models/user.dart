import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  final String uid;
  final String email;
  final String username;
  final String bio;
  final String photoUrl;
  final List<dynamic> followers;
  final List<dynamic> following;
  final List<dynamic> posts;
  final List<dynamic> saved;
  final String searchKey;

  Users({
    required this.uid,
    required this.email,
    required this.username,
    required this.bio,
    required this.photoUrl,
    required this.followers,
    required this.following,
    required this.posts,
    required this.saved,
    required this.searchKey,
  });

  static Users fromSnap(DocumentSnapshot snap) {
    final data = snap.data();

    // ✅ If document missing / empty -> safe defaults (no crash)
    if (data == null) {
      return Users(
        uid: snap.id,
        email: '',
        username: '',
        bio: '',
        photoUrl: '',
        followers: const [],
        following: const [],
        posts: const [],
        saved: const [],
        searchKey: '',
      );
    }

    final snapshot = data as Map<String, dynamic>;

    return Users(
      uid: snapshot['uid'] ?? snap.id,
      email: snapshot['email'] ?? '',
      username: snapshot['username'] ?? '',
      bio: snapshot['bio'] ?? '',
      photoUrl: snapshot['photoUrl'] ?? '',
      followers: (snapshot['followers'] ?? []) as List<dynamic>,
      following: (snapshot['following'] ?? []) as List<dynamic>,
      posts: (snapshot['posts'] ?? []) as List<dynamic>,
      saved: (snapshot['saved'] ?? []) as List<dynamic>,
      searchKey: snapshot['searchKey'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final key = searchKey.isNotEmpty
        ? searchKey.substring(0, 1).toUpperCase()
        : '';

    return {
      'uid': uid,
      'email': email,
      'username': username,
      'bio': bio,
      'photoUrl': photoUrl,
      'followers': followers,
      'following': following,
      'posts': posts,
      'saved': saved,
      'searchKey': key,
    };
  }
}
