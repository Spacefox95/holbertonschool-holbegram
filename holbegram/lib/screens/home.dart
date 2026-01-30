import 'package:flutter/material.dart';
import 'package:holbegram/widgets/bottom_nav.dart';
import 'package:provider/provider.dart';
import 'package:holbegram/providers/user_provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<UserProvider>(context, listen: false).refreshUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: BottomNav());
  }
}
