import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:holbegram/methods/auth_methods.dart';
import 'package:holbegram/screens/home.dart';
import 'package:image_picker/image_picker.dart';

class AddPicture extends StatefulWidget {
  final String email;
  final String password;
  final String username;

  const AddPicture({
    super.key,
    required this.email,
    required this.password,
    required this.username,
  });

  @override
  State<AddPicture> createState() => _AddPictureState();
}

class _AddPictureState extends State<AddPicture> {
  Uint8List? _image;
  bool _isLoading = false;

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

  Future<void> _signUp() async {
    if (_isLoading) return;

    // Optional: force picture selection
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a profile picture")),
      );
      return;
    }

    setState(() => _isLoading = true);

    final res = await AuthMethode().signUpUser(
      email: widget.email.trim(),
      password: widget.password.trim(),
      username: widget.username.trim(),
      file: _image,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (res == "success") {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Account created")));

      // ✅ Go to home (and remove auth screens from stack)
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const Home()),
        (route) => false,
      );
    } else {
      // ✅ Show why it failed (ex: email already in use)
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 28),
                const Text(
                  'Holbegram',
                  style: TextStyle(fontFamily: 'Billabong', fontSize: 50),
                ),
                Image.asset('assets/images/logo.webp', width: 80, height: 60),

                const SizedBox(height: 28),
                Text(
                  'Hello, ${widget.username} Welcome to Holbegram.',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                const Text(
                  'Choose an image from your gallery or take a new one.',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),

                _image == null
                    ? Image.asset(
                        'assets/images/user_icon.png',
                        width: 200,
                        height: 200,
                      )
                    : CircleAvatar(
                        radius: 100,
                        backgroundImage: MemoryImage(_image!),
                      ),

                const SizedBox(height: 28),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.image,
                        size: 50,
                        color: Color.fromARGB(218, 226, 37, 24),
                      ),
                      onPressed: _isLoading ? null : selectImageFromGallery,
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.camera_alt,
                        size: 50,
                        color: Color.fromARGB(218, 226, 37, 24),
                      ),
                      onPressed: _isLoading ? null : selectImageFromCamera,
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                SizedBox(
                  height: 48,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        const Color.fromARGB(218, 226, 37, 24),
                      ),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                    ),
                    onPressed: _isLoading ? null : _signUp,
                    child: _isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Next',
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
