import 'package:booking_class_tp_mobile/main.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  double profileOpacity = 0.5;
  @override
  Widget build(BuildContext context) {
    var titleStyle = TextStyle(color: grey, fontWeight: FontWeight.bold);
    var subtitleStyle =
        TextStyle(color: customBlack, fontWeight: FontWeight.bold);
    return Scaffold(
        body: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              color: indigoDye,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16))),
          height: 240,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                alignment: Alignment.centerLeft,
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Symbols.close),
                color: customWhite,
                iconSize: 32,
              ),
              SizedBox(
                height: 96,
              ),
              Column(
                children: [
                  Stack(alignment: Alignment.center, children: [
                    CircleAvatar(
                      backgroundColor: dimGrey,
                      radius: 64,
                    ),
                    Container(
                      child: Positioned(
                        right: 1,
                        bottom: 1,
                        child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: customWhite,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(color: dimGrey, blurRadius: 8)
                                ]),
                            child: InkWell(
                              child: Icon(
                                Symbols.edit_square,
                                size: 24,
                              ),
                            )),
                      ),
                    ),
                  ]),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                'Nama Pengguna',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: indigoDye),
              ),
              SizedBox(
                height: 12,
              ),
              Column(children: [
                Card(
                  elevation: 2,
                  child: Container(
                    width: 360,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(8)),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'Personal Information: ',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Divider(
                            height: 4,
                            color: dimGrey,
                          ),
                          Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      'Nomor Induk Mahasiswa (NIM)',
                                      style: titleStyle,
                                    ),
                                    Text(
                                      'Silverter Kristian Martin',
                                      style: subtitleStyle,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      'Program Studi',
                                      style: titleStyle,
                                    ),
                                    Text(
                                      'Teknik Informatika - S1',
                                      style: subtitleStyle,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      'Semester',
                                      style: titleStyle,
                                    ),
                                    Text(
                                      'Semester 4',
                                      style: subtitleStyle,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ]),
                  ),
                ),
              ])
            ],
          ),
        )
      ],
    ));
  }
}
