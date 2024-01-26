import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:seniorconnect/config/colors.dart';
import 'package:seniorconnect/config/constants.dart';

import 'package:seniorconnect/widgets/authWidget/background.dart';
// import 'package:seniorconnect/rubbish/responsive.dart';

// firebase object yang managed by firebase SDK
final _firebase = FirebaseAuth.instance;

class loginSignup extends StatefulWidget {
  loginSignup({super.key});

  @override
  State<loginSignup> createState() => _loginSignupState();
}

class _loginSignupState extends State<loginSignup> {
  final _form = GlobalKey<FormState>();
  List<bool> isSelected = [false, true];

  // indicator untuk ubah ui
  var _isLogin = false;
  var _isAuthenticating = false;

  //user input
  var _enterEmail = '';
  var _enterPassword = '';
  var _enterRole = 'Elderly';
  var _enterUsername = '';

  void _submit() async {
    // nak validate ikut syarat2 yg dah tetap
    final isValid = _form.currentState!.validate();

    // kalau tak valid takyah proceed utk simpan dalam database
    if (!isValid) {
      return;
    }

    //lepas valid baru save form
    _form.currentState!.save();
    //debug process
    print(_enterUsername);
    print(_enterEmail);
    print(_enterPassword);
    print(_enterRole);

    try {
      // nak tukar ui kasi keluar circular indicator
      setState(() {
        _isAuthenticating = true;
      });

      if (_isLogin) {
        final UserCredential = _firebase.signInWithEmailAndPassword(
            email: _enterEmail, password: _enterPassword);
        // nnti status trus dikira log in
        print('User Credential : ${UserCredential}');
      } else {
        final UserCredential = await _firebase.createUserWithEmailAndPassword(
            email: _enterEmail, password: _enterPassword);
        print('User Credential : ${UserCredential}');

        //nak simpan jenis role dengan username
        await FirebaseFirestore.instance
            .collection('users')
            .doc(UserCredential.user!.uid)
            .set({
          'userid' : UserCredential.user!.uid,
          'username': _enterUsername,
          'email': _enterEmail,
          'password': _enterPassword,
          'role': _enterRole,
        });
      }

      // kalau dah xde circular maksudnya dah send to database
      setState(() {
        _isAuthenticating = false;
      });


    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
        //...
      }
      // kalau ada error nnti die akan show snackbar dekat bahagian bawah dgn error apa yang ada
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authentication failed'),
        ),
      );
    }
  }

  bool _isObscured = true;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Background(
      child: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            //margin: const EdgeInsets.all(defaultPadding),
            width: double.infinity,
            height: _isLogin ? 400 : 300,
            child: Image.asset('lib/assets/images/login_icon.png'),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Container(
              child: Form(
                key: _form,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //username
                    if (_isLogin == false)
                      TextFormField(
                        decoration: const InputDecoration(
                            hintText: 'Username',
                            prefixIcon: Padding(
                              padding: EdgeInsets.all(defaultPadding),
                              child: Icon(
                                Icons.abc_sharp,
                              ),
                            )),
                        keyboardType: TextInputType.name,
                        autocorrect: false,
                        textCapitalization: TextCapitalization.none,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a valid Username';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          _enterUsername = newValue!;
                        },
                      ),
      
                    SizedBox(
                      height: 15,
                    ),
      
                    //Email Address
                    TextFormField(
                      decoration: const InputDecoration(
                          hintText: 'Email Address',
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(defaultPadding),
                            child: Icon(Icons.person),
                          )),
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty ||
                            !value.contains('@')) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _enterEmail = newValue!;
                      },
                    ),
      
                    SizedBox(
                      height: 15,
                    ),
      
                    //password
                    TextFormField(
                      decoration: InputDecoration(
                          hintText: 'Password',
                          prefixIcon: const Padding(
                            padding: EdgeInsets.all(defaultPadding),
                            child: Icon(Icons.lock),
                          ),
                          suffixIcon: IconButton(onPressed: () {
                            setState(() {
                               _isObscured = !_isObscured;
                            });
                          }, icon: Icon(Icons.remove_red_eye))
                          ),
                      obscureText: _isObscured,
                      keyboardType: TextInputType.visiblePassword,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _enterPassword = newValue!;
                      },
                    ),
      
                    SizedBox(
                      height: 15,
                    ),
      
                    if (_isLogin == false)
                      Row(
                        children: [
                          Spacer(),
                          Text(
                            'Role :',
                            style: TextStyle(
                                fontSize: 18,
                                color: const Color.fromARGB(155, 0, 0, 0)),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          ToggleButtons(
                            selectedColor: hitam,
                            fillColor: tiffany_blue,
                            splashColor: Colors.lightBlue,
                            highlightColor: Colors.lightBlue,
                            borderColor: tiffany_blue,
                            selectedBorderColor: tiffany_blue,
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            // nak set tinggi n lebar
                            constraints: const BoxConstraints(
                              minHeight: 50,
                              minWidth: 100,
                            ),
                            children: const [
                              Text(
                                'Elderly',
                                style: TextStyle(
                                    color: Color.fromARGB(155, 0, 0, 0)),
                              ),
                              Text('Caregiver',
                                  style: TextStyle(
                                      color: Color.fromARGB(155, 0, 0, 0))),
                            ],
                            isSelected: isSelected,
                            onPressed: (int index) {
                              setState(() {
                                for (int indexBtn = 0;
                                    indexBtn < isSelected.length;
                                    indexBtn++) {
                                  isSelected[indexBtn] = (indexBtn == index);
                                  if (isSelected[indexBtn] == true) {
                                    if (indexBtn == 0) {
                                      _enterRole = 'elderly';
                                    } else {
                                      _enterRole = 'caregiver';
                                    }
                                  }
                                }
                              });
                            },
                          ),
                          Spacer(),
                        ],
                      ),
                    SizedBox(
                      height: 15,
                    ),
      
                    if (_isAuthenticating == true)
                      const CircularProgressIndicator(),
      
                    if (_isAuthenticating == false)
                      ElevatedButton(
                        onPressed: _submit,
                        child: Text(_isLogin ? 'Log In' : 'Sign Up', style: TextStyle(color: Colors.white),),
                      ),
      
                    SizedBox(
                      height: 15,
                    ),
      
                    if (_isAuthenticating == false)
                      TextButton(
                          onPressed: () {
                            setState(() {
                              _isLogin = !_isLogin;
                              print(_isLogin);
                            });
                          },
                          child: Text(_isLogin
                              ? 'Create an Account'
                              : 'I already have an account. Login')),
                  ],
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
