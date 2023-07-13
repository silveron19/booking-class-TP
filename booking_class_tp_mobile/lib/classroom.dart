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
  final List<String> hari = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jum\'at'];

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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: DropdownButtonHideUnderline(
                child: DropdownButton2<String>(
                  isExpanded: true,
                  hint: Text(
                    'Senin',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  items: hari
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
                                  : indigoDye,
                              fontWeight: FontWeight.bold),
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
                                  : indigoDye,
                              fontWeight: FontWeight.bold),
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
                                    : indigoDye,
                                fontWeight: FontWeight.bold)))),
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
                                    : indigoDye,
                                fontWeight: FontWeight.bold)))),
              ],
            ),
            SizedBox(
              height: 48,
            ),
            Text(
              'Daftar Kelas Yang Belum Terisi',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(
              height: 12,
            ),
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
              height: 24,
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
                            onTap: () {
                              scheduleModalBottomSheet(context);
                            },
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

Future<dynamic> scheduleModalBottomSheet(
  BuildContext context,
) {
  return showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          side: BorderSide(),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12))),
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 18),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ListTile(
                  leading: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Symbols.close,
                      size: 24,
                      weight: 700,
                    ),
                  ),
                  title: Text(
                    'Nama Mata Kuliah',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * .8,
                  padding: EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Column(
                          children: [
                            Row(children: [
                              Icon(
                                Symbols.calendar_month,
                                color: Colors.black,
                                size: 32,
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Text(
                                "nama",
                              ),
                            ]),
                            SizedBox(
                              height: 24,
                            ),
                            Row(children: [
                              Icon(
                                Symbols.location_on,
                                color: Colors.black,
                                size: 32,
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Text(
                                "kapasitas",
                              ),
                            ]),
                            SizedBox(
                              height: 24,
                            ),
                            Row(children: [
                              Icon(
                                Symbols.school,
                                color: Colors.black,
                                size: 32,
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Text(
                                "namaDosen",
                              ),
                            ]),
                            SizedBox(
                              height: 24,
                            ),
                            Row(children: [
                              Icon(
                                Symbols.groups,
                                color: Colors.black,
                                size: 32,
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Text(
                                "kapasitas",
                              ),
                            ]),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(
                              height: 8,
                            ),
                            Text('Jadwal Baru'),
                            SizedBox(
                              height: 8,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: indigoDye, width: 2),
                                  borderRadius: BorderRadius.circular(8)),
                              padding: EdgeInsets.all(12),
                              child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Pilih Tanggal'),
                                    InkWell(
                                      onTap: () {},
                                      child: Icon(Symbols.calendar_month),
                                    )
                                  ]),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text('Kelas Baru'),
                            SizedBox(
                              height: 8,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: indigoDye, width: 2),
                                  borderRadius: BorderRadius.circular(8)),
                              padding: EdgeInsets.all(12),
                              child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Kelas'),
                                    InkWell(
                                      onTap: () {},
                                      child: Icon(Symbols.arrow_drop_down),
                                    )
                                  ]),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              'Alasan',
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            TextField(
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: indigoDye, width: 2)),
                                hintText: 'Berikan alasan',
                              ),
                              maxLines: 5,
                              maxLength: 100,
                            ),
                          ],
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(18),
                                backgroundColor: indigoDye,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8))),
                            onPressed: () {},
                            child: Text('Kirim'))
                      ]),
                )
              ]),
        );
      });
}

Future<void> bookingDialog(context) async {
  return showDialog(
      context: context,
      builder: (context) {
        String test = 'tes';
        String? selectedSubject;
        final List<String> subjects = [
          'Subject1',
          'Subject2',
          'Subject3',
          'Subject4',
          'Subject5',
        ];
        return AlertDialog(
          titlePadding: EdgeInsets.zero,
          title: IconButton(
            iconSize: 24,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Symbols.close,
              weight: 700,
            ),
            alignment: Alignment.centerRight,
          ),
          contentPadding: EdgeInsets.only(left: 24, right: 24, bottom: 24),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Container(
                  width: 304,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Pemesanan Kelas',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text('Mata Kuliah',
                              style: TextStyle(fontWeight: FontWeight.w500)),
                          DropdownButtonHideUnderline(
                              child: DropdownButton2(
                            hint: Text('Pilih Mata Kuliah'),
                            buttonStyleData: ButtonStyleData(
                                decoration: BoxDecoration(
                                    border: Border.all(color: indigoDye),
                                    borderRadius: BorderRadius.circular(8))),
                            value: selectedSubject,
                            onChanged: (value) {
                              setState(() {
                                selectedSubject = value;
                              });
                            },
                            items: subjects
                                .map((e) =>
                                    DropdownMenuItem(value: e, child: Text(e)))
                                .toList(),
                          ))
                        ],
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Alasan',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          TextField(
                            maxLength: 100,
                            maxLines: 5,
                            decoration: InputDecoration(
                                counterText: '0/100',
                                hintText: 'Berikan alasan',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: indigoDye))),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      Row(
                        children: [
                          Flexible(
                            fit: FlexFit.tight,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(130, 48),
                                    backgroundColor: customWhite,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        side: BorderSide(color: indigoDye))),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Batal',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: indigoDye),
                                )),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Flexible(
                            fit: FlexFit.tight,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(130, 48),
                                    backgroundColor: indigoDye,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: BorderSide(color: indigoDye),
                                    )),
                                onPressed: () {},
                                child: Text(
                                  'Pesan',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                )),
                          )
                        ],
                      )
                    ],
                  ));
            },
          ),
        );
      });
}
