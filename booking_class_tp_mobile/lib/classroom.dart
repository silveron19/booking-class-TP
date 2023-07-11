import 'package:booking_class_tp_mobile/main.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class ClassroomPage extends StatefulWidget {
  const ClassroomPage({super.key});

  @override
  State<ClassroomPage> createState() => _ClassroomPageState();
}

class _ClassroomPageState extends State<ClassroomPage> {
  final List<String> items = [
    'Item1',
    'Item2',
    'Item3',
    'Item4',
  ];

  final List<String> lantai = ['Ground', 'Lt.1', 'Lt.2', 'Lt.3'];

  final List<String> daftarKelas = [
    'G01',
    'G02',
    'G03',
    'G04',
    'G05',
    'G06',
    'G01',
    'G02',
    'G03',
    'G04',
    'G05',
    'G06',
  ];

  String? selectedValue;

  String selectedButton = 'Ground';

  String? selectedCapacity = 'Kapasitas 50';
  final List<String> kapasitas = ['Kapasitas 50', 'Kapasitas 100'];

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: paddings,
        child: Column(
          children: [
            Center(
              child: DropdownButtonHideUnderline(
                child: DropdownButton2<String>(
                  isExpanded: true,
                  hint: Text(
                    'Select Item',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  items: items
                      .map((String item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ))
                      .toList(),
                  value: selectedValue,
                  onChanged: (String? value) {
                    setState(() {
                      selectedValue = value;
                    });
                  },
                  buttonStyleData: ButtonStyleData(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      height: 52,
                      width:
                          MediaQuery.of(context).size.width - paddings.left * 2,
                      decoration: BoxDecoration(
                          color: indigoDye,
                          borderRadius: BorderRadius.circular(8))),
                  dropdownStyleData: DropdownStyleData(
                      decoration: BoxDecoration(
                          color: indigoDye,
                          borderRadius: BorderRadius.circular(8))),
                  iconStyleData: IconStyleData(
                      icon: Icon(
                    Symbols.keyboard_arrow_down,
                    color: Colors.white,
                  )),
                  menuItemStyleData: const MenuItemStyleData(
                    height: 40,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: selectedButton == 'Ground'
                                ? indigoDye
                                : customWhite,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: indigoDye),
                                borderRadius: BorderRadius.circular(8))),
                        onPressed: () {
                          setState(() {
                            selectedButton = 'Ground';
                          });
                        },
                        child: Text(
                          'Ground',
                          style: TextStyle(
                              color: selectedButton == 'Ground'
                                  ? customWhite
                                  : indigoDye),
                        ))),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: selectedButton == 'Lt.1'
                                ? indigoDye
                                : customWhite,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: indigoDye),
                                borderRadius: BorderRadius.circular(8))),
                        onPressed: () {
                          setState(() {
                            selectedButton = 'Lt.1';
                          });
                        },
                        child: Text(
                          'Lt.1',
                          style: TextStyle(
                              color: selectedButton == 'Lt.1'
                                  ? customWhite
                                  : indigoDye),
                        ))),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: selectedButton == 'Lt.2'
                                ? indigoDye
                                : customWhite,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: indigoDye),
                                borderRadius: BorderRadius.circular(8))),
                        onPressed: () {
                          setState(() {
                            selectedButton = 'Lt.2';
                          });
                        },
                        child: Text('Lt.2',
                            style: TextStyle(
                                color: selectedButton == 'Lt.2'
                                    ? customWhite
                                    : indigoDye)))),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: selectedButton == 'Lt.3'
                                ? indigoDye
                                : customWhite,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: indigoDye),
                                borderRadius: BorderRadius.circular(8))),
                        onPressed: () {
                          setState(() {
                            selectedButton = 'Lt.3';
                          });
                        },
                        child: Text('Lt.3',
                            style: TextStyle(
                                color: selectedButton == 'Lt.3'
                                    ? customWhite
                                    : indigoDye)))),
              ],
            ),
            Text('Daftar Kelas Yang Belum Terisi'),
            DropdownButtonHideUnderline(
                child: DropdownButton2(
              isExpanded: true,
              hint: Text(selectedCapacity!),
              items: kapasitas
                  .map((String e) =>
                      DropdownMenuItem<String>(value: e, child: Text(e)))
                  .toList(),
              value: selectedCapacity,
              onChanged: (value) {
                setState(() {
                  selectedCapacity = value;
                });
              },
              buttonStyleData: ButtonStyleData(
                  height: 36,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: customWhite,
                      border: Border.all(color: indigoDye, width: 2))),
              dropdownStyleData: DropdownStyleData(
                decoration: BoxDecoration(
                    color: customWhite,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: indigoDye, width: 2)),
              ),
              menuItemStyleData: MenuItemStyleData(height: 36),
            )),
            SizedBox(
              height: 12,
            ),
            Flexible(
              child: Material(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: daftarKelas.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ListTile(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            title: Text(daftarKelas[index]),
                            tileColor: indigoDye,
                            textColor: customWhite,
                          ),
                          SizedBox(
                            height: 16,
                          ),
                        ],
                      );
                    }),
              ),
            )
          ],
        ));
  }
}
