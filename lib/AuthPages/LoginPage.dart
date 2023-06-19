// ignore_for_file: use_build_context_synchronously
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ommer/CustomerPages/homePage.dart';
import 'package:ommer/DatabaseConnection.dart';
import 'package:ommer/Objects/User.dart';
import 'package:provider/provider.dart';


class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool _isConnected = false;
  @override
  void initState() {
    super.initState();
    checkInternetConnection();
  }
  Future<void> checkInternetConnection() async {
    try {
      final result = await Connectivity().checkConnectivity();
      setState(() {
        _isConnected = (result != ConnectivityResult.none);

      if (!_isConnected) {
        showDialog(
          barrierDismissible: false,
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Connection Error"),
                content: Text("You are not connected to internet. You have to be connected to login"),
                actions: [
                  ElevatedButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                      checkInternetConnection();
                    },
                  ),
                ],
              );
            });
      } else {
        print("Connected");
      }
      });
    } on PlatformException catch (e) {
      print('Couldn\'t check connectivity status Error $e');
      return;
    }
  }


  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login(BuildContext context) async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text;

    // Validate inputs
    if (email.isEmpty || password.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title:const Text('Error'),
            content: const Text('Please enter your email and password.'),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    // Connect to database
    final conn = await DatabaseConnection().connect();

    // Query database for user with matching email and password

        try{
      final results = await conn.query(
          'SELECT * FROM user WHERE mail = ? AND password = ?',
          [email, password]);

      // Close database connection
      await conn.close();
      var uid;
      var name;
      var role;
      for (var row in results) {
        uid = row['uid'];
        name = row['name'];
        role = row['role'];
      }


    // Check if user was found
    if (results.isNotEmpty) {
      isCheckedIn(context);
      context.read<User>().updateUserInfo(uid: uid, name: name,  mail: email,  password: password,  role: role);
      if (role==1)
        Navigator.pushReplacementNamed(context, '/home');
      else if (role==2)
        Navigator.pushReplacementNamed(context, '/panel');
      else
        print("Unknown user role");
    }
    else {
      // Show error message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Invalid email or password.'),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
        catch (e) {
          print("error ocurred: $e");
        }
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(2, 108, 174, 1),
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('asst/loginback.jpg'),fit: BoxFit.fitHeight),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: deviceSize.width/2,
              height: deviceSize.height/7,
              child: Image.asset('asst/ommer_logo.png'),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: deviceSize.height/10),
              width: deviceSize.width/1.3,
              height: deviceSize.height/1.8,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.black.withOpacity(0.38),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Text("Login",
                      style: TextStyle(color: Colors.white,fontSize: deviceSize.width/9,),textAlign: TextAlign.center,
                  ),
      ),
      Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 50),
        child: Text("Sign in to continue.",
          style: TextStyle(color: Colors.white,fontSize: deviceSize.width/25,),
        ),
      ),
      Container(
        alignment: Alignment.centerLeft,
        margin: const EdgeInsets.symmetric(vertical: 20,horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("E-Mail",
                          style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).textScaleFactor*15),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(color: Colors.white30, borderRadius: BorderRadius.circular(15)),
                          child: TextField(
                            onTapOutside: (evt){

                            },
                            controller: _emailController,
                            decoration: const InputDecoration(

                              alignLabelWithHint: true,
                              hintText: "E-Mail",
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text("Password",
                          style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).textScaleFactor*15),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(color: Colors.white30, borderRadius: BorderRadius.circular(15)),
                          child: TextField(
                            obscureText: true,
                            controller: _passwordController,
                            decoration: const InputDecoration(
                              alignLabelWithHint: true,
                              hintText: "Password",
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: deviceSize.height/26,
                          width: deviceSize.width/1.65,
                          child: ElevatedButton(
                            style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.blueAccent.shade700)),
                            child: Container(
                                decoration: const BoxDecoration(),
                                child: const Text('Login')),
                            onPressed: () {
                                checkInternetConnection();
                              if(_isConnected) {
                                _login(context);
                              }
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don't you Have an account?",style: TextStyle(color: Colors.white,fontSize: deviceSize.width/40,),),
                            TextButton(
                              child: const Text("Sign up",
                                style: TextStyle(
                                    decoration: TextDecoration.underline
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pushNamed('/register');
                              },
                            ),
                          ],
                        )
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

