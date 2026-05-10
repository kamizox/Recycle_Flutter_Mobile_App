import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_project/home_admin.dart';
import 'package:first_project/widget_support.dart';
import 'package:flutter/material.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  TextEditingController usernamecontroller = TextEditingController();
  TextEditingController userpasswordcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Image.asset(
                "images/login.png",
                height: 220,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20),
            Text("Admin Login", style: AppWidget.headlinetextstyle(26.0)),
            SizedBox(height: 20.0),
            Container(
              height: 380,
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text(
                        "Username",
                        style: AppWidget.normaltextstyle(22.0),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      margin: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Material(
                        elevation: 3.0,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          margin: EdgeInsets.only(left: 20.0, right: 20.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                            controller: usernamecontroller,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Enter Username",
                              hintStyle: AppWidget.normaltextstyle(22.0),
                              prefixIcon: Icon(
                                Icons.person,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text(
                        "Password",
                        style: AppWidget.normaltextstyle(22.0),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      margin: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Material(
                        elevation: 3.0,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          margin: EdgeInsets.only(left: 20.0, right: 20.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                            controller: userpasswordcontroller,
                            obscureText: true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Enter Password",
                              hintStyle: AppWidget.normaltextstyle(22.0),
                              prefixIcon: Icon(
                                Icons.password,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 50.0),
                    GestureDetector(
                      onTap: () {
                        LoginAdmin();
                      },
                      child: Center(
                        child: Container(
                          height: 55,
                          width: 200,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              "LogIn",
                              style: AppWidget.whitetextstyle(25.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  LoginAdmin() {
    FirebaseFirestore.instance.collection("Admin").get().then((snapshot) {
      // Added curly brace
      bool adminFound = false;

      for (var result in snapshot.docs) {
        if (result.data()['id'] == usernamecontroller.text.trim() &&
            result.data()['password'] == userpasswordcontroller.text.trim()) {
          adminFound = true;
          break;
        }
      }

      if (adminFound) {
        Route route = MaterialPageRoute(
          builder: (context) => const HomeAdmin(),
        );
        Navigator.pushReplacement(context, route);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "Invalid Username or Password",
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }
    });
  }
}
