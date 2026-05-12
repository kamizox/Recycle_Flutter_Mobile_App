import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_project/database.dart';
import 'package:first_project/widget_support.dart';
import 'package:flutter/material.dart';

class AdminApproval extends StatefulWidget {
  const AdminApproval({super.key});

  @override
  State<AdminApproval> createState() => _AdminApprovalState();
}

class _AdminApprovalState extends State<AdminApproval> {
  Stream? approvalStream;

  getontheload() async {
    approvalStream = await DatabaseMethods().getAdminApproval();
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  // ✅ FIX: Safe points fetch - String aur Number dono handle karta hai
  Future<int> getUserPointsSafe(String docId) async {
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(docId)
          .get();
      if (docSnapshot.exists) {
        var data = docSnapshot.data() as Map<String, dynamic>;
        var points = data["Points"];
        if (points == null) return 0;
        // String ho ya int - dono safely parse hoga
        return int.tryParse(points.toString()) ?? 0;
      }
      return 0;
    } catch (e) {
      print("Error fetching points: $e");
      return 0;
    }
  }

  Widget allApprovals() {
    return StreamBuilder(
      stream: approvalStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return Container(
                    margin: EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                      bottom: 15.0,
                    ),
                    child: Material(
                      elevation: 2.0,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black45,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Image.asset(
                                "images/coca.png",
                                height: 120,
                                width: 120,
                                fit: BoxFit.contain,
                              ),
                            ),
                            SizedBox(width: 10.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.person,
                                        color: Colors.green,
                                        size: 28.0,
                                      ),
                                      SizedBox(width: 6.0),
                                      Expanded(
                                        child: Text(
                                          ds["Name"],
                                          style: AppWidget.normaltextstyle(
                                            18.0,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4.0),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        color: Colors.green,
                                        size: 28.0,
                                      ),
                                      SizedBox(width: 6.0),
                                      Expanded(
                                        child: Text(
                                          ds["Address"],
                                          style: AppWidget.normaltextstyle(
                                            18.0,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4.0),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.inventory,
                                        color: Colors.green,
                                        size: 28.0,
                                      ),
                                      SizedBox(width: 6.0),
                                      Expanded(
                                        child: Text(
                                          ds["Quantity"],
                                          style: AppWidget.normaltextstyle(
                                            18.0,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.0),
                                  // ✅ APPROVE BUTTON - FIXED
                                  GestureDetector(
                                    onTap: () async {
                                      try {
                                        // ✅ Safe int fetch - crash nahi hoga
                                        int currentPoints =
                                            await getUserPointsSafe(
                                              ds["UserId"],
                                            );
                                        int updatedPoints = currentPoints + 100;

                                        print(
                                          "Current points: $currentPoints → Updated: $updatedPoints",
                                        );

                                        // ✅ Points update karo
                                        await DatabaseMethods()
                                            .updateUserPoints(
                                              ds["UserId"],
                                              updatedPoints.toString(),
                                            );

                                        // ✅ Request status update karo
                                        await DatabaseMethods()
                                            .updateAdminRequest(ds.id);
                                        await DatabaseMethods()
                                            .updateUserRequest(
                                              ds["UserId"],
                                              ds.id,
                                            );

                                        print(
                                          "✅ Points updated successfully to $updatedPoints",
                                        );

                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "✅ Approved! +100 points added",
                                            ),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                      } catch (e) {
                                        print("❌ Error approving: $e");
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text("Error: $e"),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    },
                                    child: Container(
                                      height: 40,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Approve",
                                          style: AppWidget.whitetextstyle(20.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
            : Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 40.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Material(
                      elevation: 3.0,
                      borderRadius: BorderRadius.circular(60),
                      child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(60),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 30.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width / 7),
                  Text(
                    "Admin Approval",
                    style: AppWidget.headlinetextstyle(25.0),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  color: Color.fromARGB(255, 233, 233, 249),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.0),
                    Expanded(child: allApprovals()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
