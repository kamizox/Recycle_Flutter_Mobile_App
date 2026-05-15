import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_project/database.dart';
import 'package:first_project/widget_support.dart';
import 'package:flutter/material.dart';

class AdminReedem extends StatefulWidget {
  const AdminReedem({super.key});

  @override
  State<AdminReedem> createState() => _AdminReedemState();
}

class _AdminReedemState extends State<AdminReedem> {
  Stream? reedemStream;
  getontheload() async {
    reedemStream = await DatabaseMethods().getAdminReedemApproval();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getontheload();
  }

  Widget allApprovals() {
    return StreamBuilder(
      stream: reedemStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(left: 20.0, right: 20.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        SizedBox(height: 20.0),
                        Container(
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.only(left: 20.0, right: 20.0),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            ds["Date"],
                            textAlign: TextAlign.center,
                            style: AppWidget.whitetextstyle(22.0),
                          ),
                        ),
                        SizedBox(width: 20.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.person,
                                    color: Colors.green,
                                    size: 25.0,
                                  ),
                                  SizedBox(width: 10.0),
                                  Text(
                                    ds["Name"],
                                    style: AppWidget.normaltextstyle(18.0),
                                  ),
                                ],
                              ),

                              Row(
                                children: [
                                  Icon(
                                    Icons.point_of_sale,
                                    color: Colors.green,
                                    size: 25.0,
                                  ),
                                  SizedBox(width: 10.0),
                                  Expanded(
                                    child: Text(
                                      "Points Reedem: " + ds["Points"],
                                      style: AppWidget.normaltextstyle(18.0),
                                    ),
                                  ),
                                ],
                              ),

                              Row(
                                children: [
                                  Icon(
                                    Icons.monetization_on,
                                    color: Colors.green,
                                    size: 25.0,
                                  ),
                                  SizedBox(width: 10.0),
                                  Expanded(
                                    child: Text(
                                      "Acc No:" + ds["UPI"],
                                      style: AppWidget.normaltextstyle(18.0),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5.0),
                              GestureDetector(
                                onTap: () async {
                                  await DatabaseMethods()
                                      .updateAdminReedemRequest(ds.id);
                                  await DatabaseMethods()
                                      .updateUserReedemRequest(
                                        ds["UserId"],
                                        ds.id,
                                      );
                                },
                                child: Container(
                                  height: 40,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Approved",
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
                    "Reedem Approval",
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
                    Container(
                      height: MediaQuery.of(context).size.height / 1.5,
                      child: allApprovals(),
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
}
