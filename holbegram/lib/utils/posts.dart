import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:holbegram/screens/pages/methods/post_storage.dart';
import 'package:provider/provider.dart';
import 'package:holbegram/providers/user_provider.dart';

class Posts extends StatefulWidget {
  const Posts({super.key});

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).getUser;
    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('posts').snapshots(),
      builder:
          (
            context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
          ) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("No posts yet"));
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (ctx, index) {
                final data = snapshot.data!.docs[index].data();

                return SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    height: 540,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Column(
                      children: [
                        // HEADER
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    data['profImage'],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                data['username'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(Icons.more_horiz),
                                onPressed: () async {
                                  await PostStorage().deletePost(
                                    data['postId'],
                                  );
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Post Deleted"),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),

                        // CAPTION
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            data['caption'] ?? "",
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // IMAGE
                        Container(
                          width: 350,
                          height: 350,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            image: DecorationImage(
                              image: NetworkImage(data['postUrl']),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        // FOOTER
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10.0,
                            left: 20,
                            right: 20,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.favorite_border, size: 28),
                                  SizedBox(width: 20),
                                  Icon(Icons.chat_bubble_outline, size: 28),
                                  SizedBox(width: 20),
                                  Icon(Icons.send_outlined, size: 28),
                                ],
                              ),

                              IconButton(
                                onPressed: () async {
                                  await PostStorage().addToFavorite(
                                    uid: user.uid,
                                    postId: data['postId'],
                                  );
                                  if (context.mounted) {
                                    await Provider.of<UserProvider>(
                                      context,
                                      listen: false,
                                    ).refreshUser();
                                  }
                                },
                                icon: Icon(
                                  user.saved.contains(data['postId'])
                                      ? Icons.bookmark
                                      : Icons.bookmark_border,
                                  size: 28,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
    );
  }
}
