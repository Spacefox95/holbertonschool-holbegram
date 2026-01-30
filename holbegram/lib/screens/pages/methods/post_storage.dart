import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:holbegram/models/post.dart';
import 'package:holbegram/screens/auth/methods/user_storage.dart';
import 'package:uuid/uuid.dart';

class PostStorage {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(
    String caption,
    String uid,
    String username,
    String profImage,
    Uint8List image,
  ) async {
    String res = "Some error occurred";
    try {
      // Uload
      String postUrl = await StorageMethods().uploadImageToStorage(
        true,
        'posts',
        image,
      );

      String postId = const Uuid().v1();

      // Create
      Post post = Post(
        caption: caption,
        uid: uid,
        username: username,
        likes: [],
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: postUrl,
        profImage: profImage,
      );

      // Save
      await _firestore.collection('posts').doc(postId).set(post.toJson());

      await _firestore.collection('users').doc(uid).update({
        'posts': FieldValue.arrayUnion([postId]),
      });

      res = "Ok";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Delete
  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (err) {
      print(err.toString());
    }
  }

  Future<String> addToFavorite({
    required String uid,
    required String postId,
  }) async {
    String res = "Some error occurred";
    try {
      DocumentSnapshot snap = await _firestore
          .collection('users')
          .doc(uid)
          .get();
      List saved = (snap.data()! as dynamic)['saved'];
      if (saved.contains(postId)) {
        await _firestore.collection('users').doc(uid).update({
          'saved': FieldValue.arrayRemove([postId]),
        });
        res = "Post removed from favorites";
      } else {
        await _firestore.collection('users').doc(uid).update({
          'saved': FieldValue.arrayUnion([postId]),
        });
        res = "Post saved to favorites";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
