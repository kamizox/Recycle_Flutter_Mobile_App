import 'package:flutter/material.dart';
import 'package:first_project/onboarding.dart'; //
import 'package:first_project/auth.dart'; //
import 'package:first_project/shared_pref.dart'; //
import 'package:first_project/widget_support.dart'; //

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? id, name, email, image; //

  // Shared preferences se data nikalne ke liye
  getthesharedpref() async {
    id = await SharedPreferenceHelper().getUserId(); //
    name = await SharedPreferenceHelper().getUserName(); //
    email = await SharedPreferenceHelper().getUserEmail(); //
    image = await SharedPreferenceHelper().getUserImage(); //
    setState(() {});
  }

  ontheload() async {
    await getthesharedpref(); //
    setState(() {});
  }

  @override
  void initState() {
    ontheload(); //
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: name == null
          ? const Center(child: CircularProgressIndicator()) //
          : Container(
              margin: const EdgeInsets.only(top: 60.0),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      "Profile Page",
                      style: AppWidget.headlinetextstyle(28.0), //
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 233, 233, 249), //
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 20.0),
                            Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(80),
                                child: image != null
                                    ? Image.network(
                                        image!,
                                        height: 120,
                                        width: 120,
                                        fit: BoxFit.cover,
                                      )
                                    : Container(
                                        height: 120,
                                        width: 120,
                                        color: Colors.teal,
                                        child: Center(
                                          child: Text(
                                            name![0].toUpperCase(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 50.0,
                                            ),
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            // Name Card
                            buildProfileInfoCard(Icons.person, "Name", name!),
                            const SizedBox(height: 20.0),
                            // Email Card
                            buildProfileInfoCard(Icons.email, "Email", email!),
                            const SizedBox(height: 25.0),
                            // LogOut Button
                            buildActionButton(Icons.logout, "LogOut", () async {
                              await AuthMethods().signOut();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Onboarding(),
                                ),
                              );
                            }),
                            const SizedBox(height: 20.0),
                            // Delete Account Button
                            buildActionButton(
                              Icons.delete,
                              "Delete Account",
                              () async {
                                await AuthMethods().deleteUser();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Onboarding(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ), // SingleChildScrollView
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // Profile Info Cards (Name/Email) ke liye helper widget
  Widget buildProfileInfoCard(IconData icon, String title, String value) {
    return Material(
      elevation: 3.0,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xff4da9ba), size: 35.0),
            const SizedBox(width: 15.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.black45,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
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

  // Action Buttons (Logout/Delete) ke liye helper widget
  Widget buildActionButton(IconData icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Material(
        elevation: 3.0,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xff4da9ba), size: 35.0),
              const SizedBox(width: 15.0),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios, color: Colors.black45),
            ],
          ),
        ),
      ),
    );
  }
}
