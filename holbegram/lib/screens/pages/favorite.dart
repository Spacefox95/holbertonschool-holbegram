import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:holbegram/providers/user_provider.dart';
import 'package:provider/provider.dart';

class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).getUser;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Favorites",
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Billabong',
            fontSize: 32,
          ),
        ),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder:
            (
              context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
            ) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (user.saved.isEmpty) {
                return const Center(child: Text("No favorite posts yet"));
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text("No posts available"));
              }

              final savedPosts = snapshot.data!.docs.where((doc) {
                return user.saved.contains(doc.data()['postId']);
              }).toList();

              if (savedPosts.isEmpty) {
                return const Center(child: Text("No favorite posts found"));
              }

              return MasonryGridView.count(
                crossAxisCount: 2,
                itemCount: savedPosts.length,
                itemBuilder: (context, index) {
                  final post = savedPosts[index].data();
                  return Image.network(post['postUrl'], fit: BoxFit.cover);
                },
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
              );
            },
      ),
    );
  }
}
