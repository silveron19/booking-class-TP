import 'package:booking_class_tp_mobile/main.dart';
import 'package:flutter/material.dart';

class ClassroomPage extends StatefulWidget {
  const ClassroomPage({super.key});

  @override
  State<ClassroomPage> createState() => _ClassroomPageState();
}

class _ClassroomPageState extends State<ClassroomPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: paddings,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropdownMenu(
              inputDecorationTheme: InputDecorationTheme(
                  fillColor: indigoDye, focusColor: indigoDye),
              label: Text('Senin'),
              dropdownMenuEntries: <DropdownMenuEntry>[
                DropdownMenuEntry(value: 'value', label: 'Label')
              ])
        ],
      ),
    );
  }
}
