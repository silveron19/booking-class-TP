import 'package:booking_class_tp_mobile/mainpage.dart';
import 'package:flutter/material.dart';

Color indigoDye = const Color(0xff004267);
Color grey = const Color(0xff7B7B7B);
Color dimGrey = const Color(0xff616265);
Color customWhite = const Color(0xFFFFFFFF);
Color customBlack = const Color(0xff000000);

const paddings = EdgeInsets.all(32);

Map user = {
  'Nama': {'Password': '12345'},
  'Nama1': {'Password': '12345'},
  'Nama2': {'Password': '12345'},
};

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Class Booking App',
      home: LoginPage(),
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

  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _password = TextEditingController();

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
                  TextFormField(
                    controller: _username,
                    validator: (value) {
                      if (!user.containsKey(value)) {
                        return 'Username tidak tersedia';
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
                      if (_username.text.isEmpty) {
                        return 'Akun tidak tersedia';
                      } else if (_password.text.isEmpty) {
                        return 'Password tidak boleh kosong';
                      } else if (value != user[_username.text]['Password']) {
                        return 'Password salah';
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
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        FocusScopeNode currentFocus = FocusScope.of(context);

                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return MainPage();
                        }));
                      }
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (BuildContext context) {
                      //   return MainPage();
                      // }));
                    },
                    child: const Text('LOGIN',
                        style: TextStyle(color: Colors.white, fontSize: 14))),
              )
            ],
          ),
        ),
      ),
    );
  }
}
