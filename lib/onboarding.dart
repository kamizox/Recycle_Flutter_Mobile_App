import 'package:first_project/admin_login.dart';
import 'package:first_project/login.dart';
import 'package:first_project/widget_support.dart';
import 'package:flutter/material.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 30.0),
              Image.asset(
                "images/onboard.png",
                height: MediaQuery.of(context).size.height * 0.35,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 30.0),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Text(
                  "Recycle Your Waste Products!",
                  style: AppWidget.headlinetextstyle(30.0),
                ),
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Text(
                  "Easily collect household waste and generate less waste",
                  style: AppWidget.normaltextstyle(18.0),
                ),
              ),
              SizedBox(height: 50.0),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LogIn()),
                  );
                },
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(40),
                  child: Container(
                    height: 65,
                    width: MediaQuery.of(context).size.width / 1.5,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Center(
                      child: Text(
                        "Get Started",
                        style: AppWidget.whitetextstyle(22.0),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AdminLogin()),
                  );
                },
                child: Text(
                  "Admin Login",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16.0,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
