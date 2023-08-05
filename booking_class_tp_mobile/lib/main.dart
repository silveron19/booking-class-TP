import 'package:booking_class_tp_mobile/Connection/database_connetion.dart';
import 'package:booking_class_tp_mobile/mainpage.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'Entities/entities.dart';

Color indigoDye = const Color(0xff004267);
Color grey = const Color(0xff7B7B7B);
Color dimGrey = const Color(0xff616265);
Color customWhite = const Color(0xFFFFFFFF);
Color customBlack = const Color(0xff000000);
Color antiFlashWhite = const Color(0xffEEEEEE);

const paddings = EdgeInsets.all(32);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Montserrat'),
      title: 'Class Booking App',
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool rememberMe = false;
  bool obscurePassword = true;
  bool isAuthenticating = false;

  User? currentUser;

  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _password = TextEditingController();

  void iniState() {
    super.initState();
  }

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  Future showPopUp(String popUpText) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SizedBox(
              height: 120,
              width: 80,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Symbols.mail,
                    size: 64,
                  ),
                  Text(popUpText),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * .8,
          height: MediaQuery.of(context).size.height * .7,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selamat Datang',
                    style: TextStyle(
                        color: indigoDye,
                        fontSize: 48,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    'Silahkan Masuk',
                    style: TextStyle(color: grey, fontSize: 18),
                  ),
                ],
              ),
              Form(
                key: _formKey,
                child: Column(children: [
                  TextFormField(
                    controller: _username,
                    validator: (value) {
                      if (currentUser == null) {
                        return 'NIM Tidak terdaftar';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: 'NIM',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8))),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  TextFormField(
                    controller: _password,
                    decoration: InputDecoration(
                        hintText: 'Password',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.visibility),
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                        )),
                    obscureText: obscurePassword,
                    validator: (value) {
                      if (currentUser != null) {
                        if (currentUser?.password != value) {
                          return 'Password salah';
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          showPopUp('Password bisa diminta ke admin');
                        },
                        child: Text(
                          'Lupa Password?',
                          style: TextStyle(
                              color: indigoDye, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ]),
              ),
              SizedBox(
                height: 56,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: indigoDye),
                    onPressed: () async {
                      FocusScopeNode currentFocus = FocusScope.of(context);

                      setState(() {
                        isAuthenticating = true;
                      });

                      var response = await loginAuthentication(_username.text);

                      if (response == null) {
                        currentUser = null;
                      } else {
                        currentUser = User(
                            response['_id'],
                            response['name'],
                            response['password'],
                            response['department'],
                            response['semester'],
                            response['role']);
                      }

                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }

                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          obscurePassword = true;
                        });
                        await getSessionFromDatabase();
                        await getRequestFromDatabase();
                        await getClassroomFromDatabase();
                        await getSubjectsFromDatabase();
                        await getUserFromDatabase();

                        _username.clear();
                        _password.clear();

                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return MainPage(currentUser: currentUser);
                        }));

                        setState(() {
                          isAuthenticating = false;
                        });
                      }
                    },
                    child: isAuthenticating
                        ? const CircularProgressIndicator()
                        : const Text('LOGIN',
                            style:
                                TextStyle(color: Colors.white, fontSize: 14))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
