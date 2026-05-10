import 'package:cloud_firestore/cloud_firestore.dart';
class DatabaseMethods{
  Future addUserInfo(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .set(userInfoMap);
  }

  Future addUserUploadItem(Map<String, dynamic> userInfoMap, String id, String itemid) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("Items")
        .doc(itemid)
        .set(userInfoMap);
  }

  Future addAdminItem(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("Requests")
        .doc(id)
        .set(userInfoMap);
  }

  Future<Stream<QuerySnapshot>> getAdminApproval() async{
    return await FirebaseFirestore.instance.collection("Requests").where("Status", isEqualTo: "Pending").snapshots();
  }

  Future<Stream<QuerySnapshot>> getUserPendingRequests(String id) async{
    return await FirebaseFirestore.instance.collection("users")
        .doc(id)
        .collection("Items").where("Status", isEqualTo: "Pending")
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getAdminReedemApproval() async{
    return await FirebaseFirestore.instance.collection("Reedem").where("Status", isEqualTo: "Pending").snapshots();
  }

  
  
  Future<Stream<QuerySnapshot>> getUserTransactions(String id) async{
    return await FirebaseFirestore.instance
        .collection("users").doc(id).collection("Reedem")
       .snapshots();
  }

  Future updateAdminRequest(
      String id, ) async {
    return await FirebaseFirestore.instance
        .collection("Requests")
        .doc(id)
        .update({"Status": "Approved"});
  }

  Future updateUserRequest(

      String id,
      String itemid,)
  async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id).collection("Items").doc(itemid)
        .update({"Status": "Approved"});
  }

  Future updateAdminReedemRequest(
      String id, ) async {
    return await FirebaseFirestore.instance
        .collection("Reedem")
        .doc(id)
        .update({"Status": "Approved"});
  }

  Future updateUserReedemRequest(

      String id,
      String itemid,)
  async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id).collection("Reedem").doc(itemid)
        .update({"Status": "Approved"});
  }

  Future addUserReedemPoints(Map<String, dynamic> userInfoMap, String id, String reedemid) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id).collection("Reedem").doc(reedemid)
        .set(userInfoMap);
  }

  Future addAdminReedemRequests(
      Map<String, dynamic> userInfoMap,
       String reedemid,)
  async {
    return await FirebaseFirestore.instance
        .collection("Reedem")
        .doc(reedemid)
        .set(userInfoMap);
  }

  Future updateUserPoints(

      String id,
      String points,)
  async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .update({"Points": points,
    });
  }
}