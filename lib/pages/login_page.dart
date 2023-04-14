import 'package:flutter/material.dart';
import 'package:integrative_midterm/model/api_response.dart';
import 'package:integrative_midterm/model/user_model.dart';
import 'package:integrative_midterm/pages/home_page.dart';
import 'package:integrative_midterm/pages/registration_page.dart';
import 'package:integrative_midterm/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class loginPage extends StatefulWidget {
  const loginPage({Key? key}) : super(key: key);

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  ApiProvider apiProvider = ApiProvider();
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  String? errorMessage = '';
  bool isLogin = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  // Widget _submitButton(BuildContext context, String email, String password){
  //   return Container(
  //       child: ElevatedButton(
  //         onPressed: ()async{
  //           if (_formKey.currentState!.validate()) {
  //             var res = await apiProvider.login(email, password);
  //             if (res == 200){
  //               Navigator.push(context,
  //                   MaterialPageRoute(builder: (context) => const HomePage()));
  //             }else{
  //               throw Exception('Failed to login');
  //             }
  //           }
  //         },
  //         child: Text('Login'.toUpperCase(),
  //             style: const TextStyle(
  //               fontSize: 20,
  //               fontWeight: FontWeight.bold,
  //               color: Colors.white,
  //             )
  //         ),
  //       )
  //   );
  // }

  Widget _loginOrRegisterButton(){
    return TextButton(
        onPressed: (){
          setState(() {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const registrationPage()));
          });
        },
        child: const Text("Register Instead")
    );
  }

  Widget _errorMessage(){
    return Text (errorMessage == '' ? '' : "Hmmmmm? $errorMessage");
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loggedIn', false);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: const Color(0xFFEDF1D6),
          body: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(25, 40, 25, 10),
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Form(
                        key:_formKey,
                        child: Column(
                          children: [
                            const SizedBox(height: 30,),
                            const SizedBox(height: 30,),
                            const SizedBox(height: 30,),
                            const SizedBox(
                              height: 300,
                              width: 300,
                              child: InkWell(
                                child: Image(
                                  image: AssetImage("assets/logo.png"),
                                ),
                              ),
                            ),
                            const SizedBox(height: 30,),
                            Container(
                              child: TextFormField(
                                controller: _controllerEmail,
                                decoration: InputDecoration(
                                    labelText: 'Email',
                                    hintText: 'Enter your email',
                                    fillColor: Colors.white,
                                    filled: true,
                                    contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100.0), borderSide: const BorderSide(color: Colors.grey)),
                                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100.0), borderSide: BorderSide(color: Colors.grey.shade400)),
                                    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100.0), borderSide: const BorderSide(color: Colors.red, width: 2.0)),
                                    focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100.0), borderSide: const BorderSide(color: Colors.red, width: 2.0))),
                                validator: (val) {
                                  if(val == ''){
                                    return 'Please enter your email';
                                  }else if(!(val!.isEmpty) && !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(val)){
                                    return "Enter a valid email address";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 30,),
                            Container(
                              child: TextFormField(
                                obscureText: !_passwordVisible,
                                controller: _controllerPassword,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  hintText: 'Enter your password',
                                  fillColor: Colors.white,
                                  filled: true,
                                  contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100.0), borderSide: const BorderSide(color: Colors.grey)),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100.0), borderSide: BorderSide(color: Colors.grey.shade400)),
                                  errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100.0), borderSide: const BorderSide(color: Colors.red, width: 2.0)),
                                  focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100.0), borderSide: const BorderSide(color: Colors.red, width: 2.0)),
                                  // Here is key idea
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      // Based on passwordVisible state choose the icon
                                      _passwordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Theme.of(context).primaryColorDark,
                                    ),
                                    onPressed: () {
                                      // Update the state i.e. toogle the state of passwordVisible variable
                                      setState(() {
                                        _passwordVisible = !_passwordVisible;
                                      });
                                    },
                                  ),
                                ),
                                validator: (val){
                                  if(val == ''){
                                    return 'Please enter your password';
                                  }else{
                                    return null;
                                  }
                                },
                              ),
                            ),
                            const SizedBox(height: 20,),
                            _errorMessage(),
                          Container(
                              child: ElevatedButton(
                                onPressed: ()async{

                                  void saveToken(User user) async{
                                    SharedPreferences pref = await SharedPreferences.getInstance();
                                    await pref.setInt('userId', user.id ??  0 );
                                    print("userId saved: ${user.id}");
                                    await pref.setString('role', user.role??"User");
                                    print("userRole saved: ${user.role}");
                                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> HomePage(userID: user.id,role: user.role)), (route) => false);
                                  }

                                  if (_formKey.currentState!.validate()) {
                                    ApiResponse apiResponse = await apiProvider.login(_controllerEmail.text, _controllerPassword.text);
                                    if(apiResponse.error == null){
                                      saveToken(apiResponse.data as User);
                                    }
                                    else{
                                      //debugPrint(response.);
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${apiResponse.error}')));
                                    }

                                    // if (res == 200){
                                    //   Navigator.push(context,
                                    //       MaterialPageRoute(builder: (context) => const HomePage()));
                                    // }else{
                                    //   throw Exception('Failed to login');
                                    // }
                                  }
                                },
                                child: Text('Login'.toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    )
                                ),
                              )
                            ),
                            // _submitButton(context, _controllerEmail.text,_controllerPassword.text),
                            _loginOrRegisterButton(),
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
