import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'SuccessPage.dart';
import 'package:http/http.dart' as http;


class EmployeeLoginPage extends StatefulWidget {
  const EmployeeLoginPage({super.key});

  @override
  _EmployeeLoginPageState createState() => _EmployeeLoginPageState();
}

class _EmployeeLoginPageState extends State<EmployeeLoginPage> {
  String pin = "";
  final String apiUrl = "http://192.168.137.1:3000/api/user/login";
  int _currentImageIndex = 0;
  final List<String> _imagePaths = [
    'assets/logo.png',
    'assets/image.png',
    'assets/imagee.png',
  ];

  @override
  void initState() {
    super.initState();
    _startImageSlideshow();
  }

  void _startImageSlideshow() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentImageIndex = (_currentImageIndex + 1) % _imagePaths.length;
      });
    });
  }

  void _onKeyPressed(String value) {
    setState(() {
      if (value == "C") {
        pin = "";
      } else if (value == "⌫" && pin.isNotEmpty) {
        pin = pin.substring(0, pin.length - 1);
      } else if (pin.length < 6 && value != "C" && value != "⌫") {
        pin += value;
      }
    });
  }

  Future<void> _login() async {
    if (pin.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("PIN must be 6 digits")),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"pin": pin}),
      );

      final responseData = jsonDecode(response.body);

      // ✅ Print response for debugging
      print("Response: ${response.body}");

      if (response.statusCode == 200 && responseData["message"] == "Login successful") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SuccessPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData["message"] ?? "Invalid PIN")),
        );
      }
    } catch (error) {
      print("Error: $error"); // ✅ Print error for debugging
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Server error. Try again later.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Image.asset(
                _imagePaths[_currentImageIndex],
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/img.jpg', height: 80),
                  const SizedBox(height: 10),
                  const Text(
                    'Employee Login',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Please input your PIN to validate yourself',
                    style: TextStyle(fontSize: 16, color: Color(0xFF00008B)),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 260,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(6, (index) {
                        return Container(
                          width: 35,
                          height: 35,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black26, width: 2),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            index < pin.length ? "*" : "",
                            style: const TextStyle(fontSize: 24),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(width: 260, child: _buildNumberPad()),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 260,
                    child: ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text("Login", style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberPad() {
    List<String> keys = [
      "1", "2", "3",
      "4", "5", "6",
      "7", "8", "9",
      "C", "0", "⌫",
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.5,
      ),
      itemCount: keys.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _onKeyPressed(keys[index]),
          child: Container(
            margin: const EdgeInsets.all(6),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(color: Colors.black26, blurRadius: 2, offset: const Offset(2, 2)),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              keys[index],
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }
}