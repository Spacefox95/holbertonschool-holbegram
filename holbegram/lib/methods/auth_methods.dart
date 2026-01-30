import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:holbegram/screens/auth/methods/user_storage.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';

class AuthMethode {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> login({
    required String email,
    required String password,
  }) async {
    String res = "Some error occured";

    try {
      if (email.isEmpty || password.isEmpty) {
        return 'Please fill all the fields';
      }

      await _auth.signInWithEmailAndPassword(email: email, password: password);
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    Uint8List? file,
  }) async {
    String res = "Some error occured";

    try {
      if (email.isEmpty || password.isEmpty || username.isEmpty) {
        return 'Please fill all the fields';
      }

      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      final User? user = userCredential.user;
      if (user == null) return 'Could not create user';

      String photoUrl =
          'https://assets.stickpng.com/images/585e4beacb11b227491c3399.png';
      if (file != null) {
        photoUrl = await StorageMethods().uploadImageToStorage(
          false,
          "profilePics",
          file,
        );
      }

      final Users users = Users(
        uid: user.uid,
        email: email,
        username: username,
        bio: "",
        photoUrl: photoUrl,
        followers: [],
        following: [],
        posts: [],
        saved: [],
        searchKey: username.isEmpty
            ? ""
            : username.substring(0, 1).toUpperCase(),
      );

      await _firestore.collection('users').doc(user.uid).set(users.toJson());

      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> uploadImageToCloudinary(Uint8List file) async {
    const cloudName = '';
    const uploadPreset = '';

    final uri = Uri.parse(
      "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
    );

    final request = http.MultipartRequest("POST", uri)
      ..fields["upload_preset"] = uploadPreset
      ..files.add(
        http.MultipartFile.fromBytes("file", file, filename: "profile.jpg"),
      );

    final response = await request.send();
    final body = await response.stream.bytesToString();

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    } else {
      throw Exception(body);
    }
  }

  Future<Users> getUserDetails() async {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception("No user logged in");
    }

    final ref = _firestore.collection("users").doc(currentUser.uid);
    final snap = await ref.get();

    // ✅ If user doc missing -> create it once
    if (!snap.exists || snap.data() == null) {
      final Users users = Users(
        uid: currentUser.uid,
        email: currentUser.email ?? '',
        username: currentUser.displayName ?? '',
        bio: '',
        photoUrl:
            'https://assets.stickpng.com/images/585e4beacb11b227491c3399.png',
        followers: [],
        following: [],
        posts: [],
        saved: [],
        searchKey: (currentUser.displayName ?? '').isNotEmpty
            ? (currentUser.displayName ?? '').substring(0, 1).toUpperCase()
            : '',
      );

      await ref.set(users.toJson());
      return users;
    }

    return Users.fromSnap(snap);
  }
}
