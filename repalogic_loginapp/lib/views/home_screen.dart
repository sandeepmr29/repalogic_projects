import 'package:flutter/material.dart';
import 'login_screen.dart';

const Color primaryRed = Color(0xFFBF2424);
const Color lightRed = Color(0xFFFDEAEA);

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightRed,
      appBar: AppBar(
        backgroundColor: primaryRed,
        elevation: 0,
        title: const Text(
          'Home',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          tooltip: 'Logout',
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => LoginView()),
            );
          },
        ),
      ),
      body: Center(
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 24),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                /// Success Icon
                Icon(
                  Icons.check_circle_rounded,
                  size: 90,
                  color: primaryRed,
                ),

                SizedBox(height: 20),

                /// Success Text
                Text(
                  'Login Successful ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: primaryRed,
                  ),
                ),

                SizedBox(height: 8),

                Text(
                  'Welcome to Repalogic',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
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
