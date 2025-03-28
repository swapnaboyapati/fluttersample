import 'package:flutter/material.dart';

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Welcome",
          style: TextStyle(color: Colors.red),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.red),
      ),
      body: Center(
        child: Image.asset('assets/img.jpg', height: 300),
      ),
    );
  }
}
