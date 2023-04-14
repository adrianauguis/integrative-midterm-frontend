import 'package:flutter/material.dart';
import 'package:integrative_midterm/model/api_response.dart';
import 'package:integrative_midterm/model/user_model.dart';
import 'package:integrative_midterm/services/api_services.dart';
import 'package:integrative_midterm/widget_tree.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  int? userID;
  String? role;
  HomePage({Key? key, this.userID, this.role}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? Uid;
  int? NewUid;
  String? Role;
  String? NewRole;
  bool isItAdmin = false;
  Map<String, dynamic>? dataList;
  User user = User();
  ApiProvider apiProvider = ApiProvider();

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loggedIn', false);
    await prefs.setInt('userId', 0);
    await prefs.setString('role', "");
    print("successfully cleared shared preferences");
    // await apiProvider.logout();
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const widgetTree(loggedIn: false)));
  }

  // Future initApi() async {
  //   ApiResponse apiResponse = await apiProvider.getListJson("/user/${widget.userID}");
  //   if (apiResponse.data != null) {
  //     setState(() {
  //       user = apiResponse.data as User;
  //     });
  //   }
  // }

  Future getID()async{
    NewUid = await apiProvider.getUserID();
  }

  Future getRole()async{
    NewRole = await apiProvider.getUserRole();
  }

  Future initializeAPI()async{
    dataList = await apiProvider.getListJson("/user");
  }

  Widget buildDashboardAdmin(){
    return FutureBuilder(
        future: apiProvider.getListJson("/user"),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data['user'].length,
                itemBuilder: (context, index) {
                  var holder = snapshot.data['user'][index];
                  return ListTile(
                      title: Text("Email: ${holder['email']}"),
                      subtitle: Text("Role: ${holder['role']}"),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                                onPressed: () async {},
                                icon: const Icon(Icons.edit)),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.delete))
                          ],
                        ),
                      ));
                });
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return const Center(child: CircularProgressIndicator());
          }
          return const CircularProgressIndicator();
        });
  }

  Widget buildDashboardUser(){
    return FutureBuilder(
        future: apiProvider.getListJson("/user"),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data['user'].length,
                itemBuilder: (context, index) {
                  var holder = snapshot.data['user'][index];
                  return ListTile(
                      title: Text("Email: ${holder['email']}"),
                      subtitle: Text("Role: ${holder['role']}"),
                      // trailing: SizedBox(
                      //   width: 100,
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.end,
                      //     children: [
                      //       IconButton(
                      //           onPressed: () async {},
                      //           icon: const Icon(Icons.edit)),
                      //       IconButton(
                      //           onPressed: () {},
                      //           icon: const Icon(Icons.delete))
                      //     ],
                      //   ),
                      // )
                  );
                });
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return const Center(child: CircularProgressIndicator(),);
          }
          return const CircularProgressIndicator();
        });
  }

  @override
  void initState() {
    getID();
    getRole();
    initializeAPI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Uid = widget.userID??NewUid;
    Role = widget.role??NewRole;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Midterm Integrative"),
        centerTitle: true,
        leading: const Icon(Icons.account_circle_rounded),
        actions: [
          IconButton(
              onPressed: (){
                // if (role!.toLowerCase()=="admin"){
                //   isItAdmin=true;
                // }else{
                //   isItAdmin=false;
                // }
              },
              icon: const Icon(Icons.refresh_rounded))
        ],
      ),
      body: Role == "Admin" ? buildDashboardAdmin() : buildDashboardUser(),
      floatingActionButton: FloatingActionButton(
        onPressed: logout,
          // await apiProvider.logout();
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => const widgetTree(loggedIn: false)));
        tooltip: 'Logout',
        child: Icon(Icons.logout),
      ),
    );
  }
}
