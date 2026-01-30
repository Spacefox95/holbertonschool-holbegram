import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:holbegram/providers/user_provider.dart';
import 'package:holbegram/screens/home.dart';
import 'package:holbegram/screens/pages/methods/post_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddImage extends StatefulWidget {
  const AddImage({super.key});

  @override
  State<AddImage> createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  Uint8List? _image;
  bool _isLoading = false;
  final TextEditingController _captionController = TextEditingController();

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  void selectImageFromGallery() async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    final bytes = await picked.readAsBytes();
    setState(() => _image = bytes);
  }

  void selectImageFromCamera() async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: ImageSource.camera);
    if (picked == null) return;

    final bytes = await picked.readAsBytes();
    setState(() => _image = bytes);
  }

  Future<void> _post() async {
    final user = Provider.of<UserProvider>(context, listen: false).getUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User not loaded yet. Try again in a second.'),
        ),
      );
      return;
    }

    if (_image == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select an image")));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final res = await PostStorage().uploadPost(
      _captionController.text.trim(),
      user.uid,
      user.username,
      user.photoUrl,
      _image!,
    );
    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (res == 'Ok') {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Post uploaded")));

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const Home()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).getUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator())
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "New Post",
          style: TextStyle(fontFamily: "Billabong", fontSize: 32),
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _post,
            child: _isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(
                    "Post",
                    style: TextStyle(
                      color: Color.fromARGB(218, 226, 37, 24),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 74,
                backgroundImage: _image != null ? MemoryImage(_image!) : null,
                child: _image == null
                    ? const Icon(Icons.image, size: 64)
                    : null,
              ),
              const SizedBox(height: 14),
              Text(
                user.username,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 18),
              TextField(
                controller: _captionController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: "Write a caption...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: 44,
                    onPressed: selectImageFromCamera,
                    icon: const Icon(Icons.camera_alt),
                  ),
                  const SizedBox(width: 24),
                  IconButton(
                    iconSize: 44,
                    onPressed: selectImageFromGallery,
                    icon: const Icon(Icons.photo_library),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _post,
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      const Color.fromARGB(218, 226, 37, 24),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                          "Post",
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
