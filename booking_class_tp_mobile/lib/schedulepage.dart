import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'main.dart';

TextStyle myTileTrailingStyle =
    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, wordSpacing: 12);

TextStyle myTileLeadingStyle =
    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold);

TextStyle myDayStyle =
    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

TextStyle bottomSheetText =
    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16);

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  int? selectedIndex;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: paddings,
        child: ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Senin',
                    style: myDayStyle,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  ListTile(
                    textColor:
                        selectedIndex == index ? customWhite : customBlack,
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                      scheduleModalBottomSheet(
                          context,
                          'Rekayasa Perangkat Lunak',
                          'Wednesday, 07:30 - 10:00',
                          'Nama Dosen',
                          '30 Minutes Before',
                          'CR 201');
                    },
                    tileColor: selectedIndex == index ? indigoDye : customWhite,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: indigoDye, width: 2)),
                    title: Text(
                      'CR 201',
                      style: myTileLeadingStyle,
                    ),
                    trailing: Text(
                      'Rekayasa Perangkat Lunak',
                      style: myTileTrailingStyle,
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                ],
              );
            }));
  }

  Future<dynamic> scheduleModalBottomSheet(BuildContext context, String nama,
      String tanggal, String namaDosen, String notifikasi, String kapasitas) {
    return showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            side: BorderSide(),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12))),
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.all(18),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 50,
                    child: Divider(
                      height: 3,
                      color: grey,
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Symbols.calendar_month,
                      color: Colors.black,
                      size: 32,
                    ),
                    title: Text(
                      nama,
                      style: myTileTrailingStyle,
                    ),
                    subtitle: Text(
                      tanggal,
                      style: bottomSheetText,
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Symbols.location_on,
                      color: Colors.black,
                      size: 32,
                    ),
                    title: Text(
                      kapasitas,
                      style: bottomSheetText,
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Symbols.school,
                      color: Colors.black,
                      size: 32,
                    ),
                    title: Text(
                      namaDosen,
                      style: bottomSheetText,
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Symbols.groups,
                      color: Colors.black,
                      size: 32,
                    ),
                    title: Text(
                      kapasitas,
                      style: bottomSheetText,
                    ),
                  ),
                ]),
          );
        });
  }
}
