import 'package:booking_class_tp_mobile/Connection/database_connetion.dart';
import 'package:booking_class_tp_mobile/mainpage.dart';
import 'package:flutter/material.dart';

import 'Entities/entities.dart';

Color indigoDye = const Color(0xff004267);
Color grey = const Color(0xff7B7B7B);
Color dimGrey = const Color(0xff616265);
Color customWhite = const Color(0xFFFFFFFF);
Color customBlack = const Color(0xff000000);
Color antiFlashWhite = const Color(0xffEEEEEE);

const paddings = EdgeInsets.all(32);

Map user = {
  'Nama': {'Password': '12345', 'role': 'admin'},
  'Nama1': {'Password': '12345', 'role': 'mahasiswa'},
  'Nama2': {'Password': '12345', 'role': 'ketua kelas'},
};

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

  List errors = [];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
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
                  Column(
                      children: List.generate(
                          errors.length, (index) => Text(errors[index]))),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(
                              value: rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  rememberMe = value!;
                                });
                              }),
                          Text(
                            'Simpan Password',
                            style: TextStyle(color: grey),
                          )
                        ],
                      ),
                      Text(
                        'Lupa Password?',
                        style: TextStyle(
                            color: indigoDye, fontWeight: FontWeight.bold),
                      ),
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

                      isAuthenticating = false;

                      if (_formKey.currentState!.validate()) {
                        setState(() {});
                        _username.clear();
                        _password.clear();
                        if (context.mounted) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return MainPage(currentUser: currentUser);
                          }));
                        }
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
