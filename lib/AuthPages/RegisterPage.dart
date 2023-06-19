import 'package:flutter/material.dart';
import 'package:ommer/DatabaseConnection.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _email;
  late String _password;
  @override
  Widget build(BuildContext context) {
    bool regpressed=false;
    var backcolor =Color.fromRGBO(23, 70, 142, 1);
    var deviceSize=MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backcolor,
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20,horizontal: 60),
        margin: EdgeInsets.all(5),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(bottom:30),
              child: SizedBox(
                width: deviceSize.width/2.5,
                height: deviceSize.height/10,
                child: Image.asset('asst/ommer_logo.png'),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Text("Sign Up",
                style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).textScaleFactor*50,),textAlign: TextAlign.center,
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20,horizontal: 30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white12
                    ),
                    child: Column(
                      children: [
                        TextFormField(
                          onChanged: (value){regpressed=false;_formKey.currentState!.validate();},
                          style: TextStyle(color: Colors.white54),
                          decoration: InputDecoration(
                              label: Text("Name Surname",
                                  style: TextStyle(
                                      color: Colors.white
                                  )
                              ),
                              errorStyle: TextStyle(color: Colors.red.shade300),
                          ),
                          validator: (value) {
                            if (value!.isEmpty && regpressed) {
                              return 'Please enter your name.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _name = value!;
                          },
                        ),
                        TextFormField(
                          onChanged: (value){regpressed=false;_formKey.currentState!.validate();},
                          style: TextStyle(color: Colors.white54),
                          decoration: InputDecoration(
                            label: Text("E-Mail",
                                style: TextStyle(
                                    color: Colors.white
                                )
                            ),
                            errorStyle: TextStyle(color: Colors.red.shade300),
                          ),
                          validator: (value) {
                            if (value!.isEmpty && regpressed) {
                              return 'Please enter your email';
                            }
                            if (((!value.contains('@')) || (!value.contains('.'))) && value.isNotEmpty) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _email = value!;
                          },
                        ),
                        TextFormField(
                          onChanged: (value){regpressed=false;_formKey.currentState!.validate();},
                          style: TextStyle(color: Colors.white54),
                          decoration: InputDecoration(
                            label: Text("Password",
                                style: TextStyle(
                                    color: Colors.white
                                )
                            ),
                            errorStyle: TextStyle(color: Colors.red.shade300),
                            errorMaxLines: 2,
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value!.isEmpty && regpressed) {
                              return 'Please enter a password';
                            }
                            else if (value!.length < 6 && value.isNotEmpty) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _password = value!;
                          },
                        ),
                        SizedBox(height: 20.0),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    child: Text('Register'),
                    onPressed: () {
                      regpressed=true;
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        registerUser(_name,_password,_email);
                      }
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already Have an account?",style: TextStyle(color: Colors.white),),
                      TextButton(
                        child: Text("Sign in.",
                          style: TextStyle(
                              decoration: TextDecoration.underline
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
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
    );
  }



  Future<void> registerUser(String username, String password, String email) async {
    final conn = await DatabaseConnection().connect();
    try {
      final results = await conn.query("Select * from user where mail = ?", [email]);
      if (results.isNotEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title:Text('Error'),
              content: Text('Email is Already Registered.'),
              actions: <Widget>[
                ElevatedButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
      else {
        try {
          final results = await conn.query(
            'INSERT INTO user (uid ,name, password, mail) VALUES (uuid(),?, ?, ?)',
            [username, password, email],
          );
          conn.close();
          if (results.affectedRows == 1) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(

                  title:Container(alignment: Alignment.center, child: Text('Success')),
                  content: Text('Email Registered Succesfully'),
                  actions: <Widget>[
                    ElevatedButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          }
          else {
            print('Failed to register user.');
          }
        } catch (e) {
      print('Error registering user: $e ');
    } finally {
      await conn.close();
    }
      }
    }
    catch (e) {
      print('Error registering user: $e');
    }
    finally{
      await conn.close();
    }


  }
}