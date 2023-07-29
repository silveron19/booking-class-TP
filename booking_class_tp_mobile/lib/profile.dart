import 'package:booking_class_tp_mobile/main.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'Entities/entities.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.currentUser});
  final User? currentUser;

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
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16))),
          height: 240,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                alignment: Alignment.centerLeft,
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Symbols.close),
                color: customWhite,
                iconSize: 32,
              ),
              const SizedBox(
                height: 96,
              ),
              Column(
                children: [
                  Stack(alignment: Alignment.center, children: [
                    CircleAvatar(
                      backgroundColor: dimGrey,
                      radius: 64,
                    ),
                    Positioned(
                      right: 1,
                      bottom: 1,
                      child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: customWhite,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(color: dimGrey, blurRadius: 8)
                              ]),
                          child: const InkWell(
                            child: Icon(
                              Symbols.edit_square,
                              size: 24,
                            ),
                          )),
                    ),
                  ]),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                widget.currentUser!.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: indigoDye),
              ),
              const SizedBox(
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
                          const Padding(
                            padding: EdgeInsets.all(16.0),
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
                            padding: const EdgeInsets.all(16.0),
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
                                      widget.currentUser!.id,
                                      style: subtitleStyle,
                                    ),
                                  ],
                                ),
                                const SizedBox(
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
                                      '${widget.currentUser!.department} - S1',
                                      style: subtitleStyle,
                                    ),
                                  ],
                                ),
                                const SizedBox(
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
                                      'Semester ${widget.currentUser!.semester}',
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
