import 'package:flutter/material.dart';
import 'package:integrative_midterm/services/api_services.dart';
import 'package:integrative_midterm/widget_tree.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ApiProvider apiProvider = ApiProvider();

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loggedIn', false);
    print("successfully cleared shared preferences");
    // await apiProvider.logout();
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const widgetTree(loggedIn: false)));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Integrative Midterm'),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: apiProvider.getListJson("/"),
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
              return const CircularProgressIndicator();
            }
            return const CircularProgressIndicator();
          }),
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
