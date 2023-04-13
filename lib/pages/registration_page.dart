import 'package:flutter/material.dart';
import 'package:integrative_midterm/pages/home_page.dart';
import 'package:integrative_midterm/services/api_services.dart';

class registrationPage extends StatefulWidget {
  const registrationPage({Key? key}) : super(key: key);

  @override
  State<registrationPage> createState() => _registrationPageState();
}

class _registrationPageState extends State<registrationPage> {
  ApiProvider apiProvider = ApiProvider();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerRole = TextEditingController();
  final TextEditingController _controllerStatus = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: const Color(0xFFEDF1D6),
          body: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(25, 0, 25, 10),
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const SizedBox(height: 30,),
                            const SizedBox(height: 30,),
                            const SizedBox(height: 30,),
                            SizedBox(
                              height: 150,
                              width: 150,
                              child: InkWell(
                                child: Container(
                                  child: const Image(
                                    image: AssetImage("assets/logo.png"),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 30,),
                            Container(
                              child: TextFormField(
                                controller: _controllerEmail,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    label: Text("Email")
                                ),
                                validator: (val) {
                                  if(!(val!.isEmpty) && !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(val)){
                                    return "Enter a valid email address";
                                  }
                                },
                              ),

                            ),
                            const SizedBox(height: 10,),
                            Container(
                              child: TextFormField(
                                controller: _controllerPassword,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    label: Text("Password")
                                ),
                                validator: (value) {
                                  return (value == '') ? 'Please enter your password' : null;
                                },
                              ),
                            ),
                            const SizedBox(height: 10,),
                            Container(
                              child: TextFormField(
                                controller: _controllerRole,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    label: Text("Role")),
                                validator: (value) {
                                  return (value == '') ? 'Please enter your name' : null;
                                },
                              ),

                            ),
                            const SizedBox(height: 10,),
                            Container(
                              child: TextFormField(
                                controller: _controllerStatus,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    label: Text("Status")),
                                validator: (value) {
                                  return (value == '') ? 'Please enter your id' : null;
                                },
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            Container(
                              child: ElevatedButton(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                                  child: Text(
                                    "Register".toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                onPressed: () async{
                                  if (_formKey.currentState!.validate()){
                                    var res = await apiProvider.register(_controllerEmail.text, _controllerPassword.text, _controllerRole.text, _controllerStatus.text);
                                    if (res == 200){
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) => const HomePage()));
                                    }else{
                                      throw Exception('Failed to register');
                                    }
                                  }
                                },
                              ),
                            ),
                          ],
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
}
