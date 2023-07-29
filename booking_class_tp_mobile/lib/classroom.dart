import 'package:booking_class_tp_mobile/Connection/database_connetion.dart';
import 'package:booking_class_tp_mobile/main.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'Entities/entities.dart';

class ClassroomPage extends StatefulWidget {
  ClassroomPage({super.key, required this.currentUser});
  User? currentUser;

  @override
  State<ClassroomPage> createState() => _ClassroomPageState();
}

class _ClassroomPageState extends State<ClassroomPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    settingUpClass();
  }

  Future settingUpClass() async {
    List availableClassroom = await getClassroom(widget.currentUser!.id);
    setState(() {
      daftarKelas = availableClassroom[0];
      sessionList = availableClassroom[1];
      listWhereTheUserIsInCharge = availableClassroom[2];
      selectedDay = 'Senin';
      selectedDuration = '07:30 - 09:30';
    });

    choosingClass();
  }

  void choosingClass() {
    List result = [];
    List kelasYangPerluDihapuskan = [];
    String? classCapacity;

    if (selectedCapacity == 'Kapasitas 50') {
      classCapacity = 'CR50';
    } else if (selectedCapacity == 'Kapasitas 100') {
      classCapacity = 'CR100';
    }

    for (var element in daftarKelas) {
      if (element['floor'] == currentFloor &&
          element['capacity'] == classCapacity) {
        result.add(element);
        print(element);
      }
    }

    for (var element in sessionList) {
      var sessionDuration = '${element['start_time']} - ${element['end_time']}';
      if (element['day'] == selectedDay &&
          sessionDuration == selectedDuration) {
        kelasYangPerluDihapuskan.add(element['classroom']);
      }
    }

    result.removeWhere(
      (element) => kelasYangPerluDihapuskan.contains(element['_id']),
    );

    setState(() {
      thisFloorClasses = result;
    });
  }

  List daftarKelas = [];
  List sessionList = [];
  List thisFloorClasses = [];
  List<Session> listWhereTheUserIsInCharge = [];

  String currentFloor = 'ground';
  String selectedDay = 'Senin';
  String selectedDuration = '07:30 - 09:30';
  String selectedButton = 'Ground';
  String selectedCapacity = 'Kapasitas 50';

  final List<String> kapasitas = ['Kapasitas 50', 'Kapasitas 100'];
  final List<String> duration = [
    '07:30 - 09:30',
    '10:00 - 12:30',
    '13:00 - 15:30'
  ];
  final List<String> hari = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jum\'at'];
  final List<String> daftarLantai = ['Ground', 'Lt.1', 'Lt.2', 'Lt.3'];

  @override
  Widget build(BuildContext context) {
    super.build;
    return RefreshIndicator(
      onRefresh: settingUpClass,
      child: Container(
          padding: paddings,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButtonHideUnderline(
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
                      value: selectedDay,
                      onChanged: (String? value) {
                        setState(() {
                          selectedDay = value!;
                        });
                        choosingClass();
                      },
                      buttonStyleData: ButtonStyleData(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          height: 52,
                          width: 160,
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
                  DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      hint: Text(
                        '07:30 - 09:30',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      items: duration
                          .map((String item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ))
                          .toList(),
                      value: selectedDuration,
                      onChanged: (String? value) {
                        setState(() {
                          selectedDuration = value!;
                        });
                        choosingClass();
                      },
                      buttonStyleData: ButtonStyleData(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          height: 52,
                          width: 160,
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
                ],
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
                              currentFloor = 'ground';
                            });
                            choosingClass();
                          },
                          child: Text(
                            'Ground',
                            style: TextStyle(
                                fontSize: 10,
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
                              currentFloor = 'lantai 1';
                            });
                            choosingClass();
                          },
                          child: Text(
                            'Lt.1',
                            style: TextStyle(
                                fontSize: 10,
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
                              currentFloor = 'lantai 2';
                            });
                            choosingClass();
                          },
                          child: Text('Lt.2',
                              style: TextStyle(
                                  fontSize: 10,
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
                              currentFloor = 'lantai 3';
                            });
                            choosingClass();
                          },
                          child: Text('Lt.3',
                              style: TextStyle(
                                  fontSize: 10,
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
                hint: Text(selectedCapacity),
                items: kapasitas
                    .map((String e) =>
                        DropdownMenuItem<String>(value: e, child: Text(e)))
                    .toList(),
                value: selectedCapacity,
                onChanged: (value) {
                  setState(() {
                    selectedCapacity = value!;
                  });
                  choosingClass();
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
                child: thisFloorClasses.isEmpty
                    ? Center(child: CircularProgressIndicator())
                    : Material(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: thisFloorClasses.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  ListTile(
                                    onTap: () {
                                      widget.currentUser!.role == 'ketua kelas'
                                          ? scheduleModalBottomSheet(
                                              context,
                                              thisFloorClasses[index]['_id'],
                                              thisFloorClasses[index]
                                                  ['capacity'],
                                              selectedDay,
                                              selectedDuration,
                                              listWhereTheUserIsInCharge,
                                              widget.currentUser!)
                                          : null;
                                    },
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    title: Text(thisFloorClasses[index]['_id']),
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
          )),
    );
  }
}

Future showRequestNotification(BuildContext context, String popUpText) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(popUpText),
        );
      });
}

Future<dynamic> scheduleModalBottomSheet(
    BuildContext context,
    String className,
    String capacity,
    String day,
    String duration,
    List<Session> sessionList,
    User currentUser) {
  String? selectedSubject;
  TextEditingController reason = TextEditingController();
  return showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          side: BorderSide(),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12))),
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  padding:
                      const EdgeInsets.symmetric(vertical: 32, horizontal: 18),
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
                            'Request Class',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
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
                                        Symbols.location_on,
                                        color: Colors.black,
                                        size: 32,
                                      ),
                                      SizedBox(
                                        width: 12,
                                      ),
                                      Text(
                                        className,
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
                                        capacity,
                                      ),
                                    ]),
                                    SizedBox(
                                      height: 24,
                                    ),
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
                                        day,
                                      ),
                                    ]),
                                    SizedBox(
                                      height: 24,
                                    ),
                                    Row(children: [
                                      Icon(
                                        Symbols.schedule,
                                        color: Colors.black,
                                        size: 32,
                                      ),
                                      SizedBox(
                                        width: 12,
                                      ),
                                      Text(
                                        duration,
                                      ),
                                    ]),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text('Jadwal Baru'),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    DropdownButtonHideUnderline(
                                      child: DropdownButton2<String>(
                                        isExpanded: true,
                                        hint: Text(
                                          'Pilih Subject',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.indigo,
                                          ),
                                        ),
                                        items: sessionList.map((item) {
                                          return DropdownMenuItem<String>(
                                            value: item.subject.name,
                                            child: Text(
                                              item.subject.name,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.indigo),
                                            ),
                                          );
                                        }).toList(),
                                        value: selectedSubject,
                                        onChanged: (String? value) {
                                          setState(() {
                                            selectedSubject = value;
                                          });
                                        },
                                        buttonStyleData: ButtonStyleData(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16),
                                          height: 32,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              MediaQuery.of(context)
                                                      .padding
                                                      .left *
                                                  2,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                                color: Colors.indigo),
                                          ),
                                        ),
                                        dropdownStyleData: DropdownStyleData(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        iconStyleData: IconStyleData(
                                          icon: Icon(
                                            Icons.keyboard_arrow_down,
                                            color: Colors.indigo,
                                          ),
                                        ),
                                        menuItemStyleData:
                                            const MenuItemStyleData(
                                          height: 32,
                                        ),
                                      ),
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
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          border: Border.all(color: indigoDye),
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: TextField(
                                        controller: reason,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Berikan alasan',
                                        ),
                                        maxLines: 5,
                                        maxLength: 100,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 56,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.all(18),
                                          backgroundColor: indigoDye,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8))),
                                      onPressed: () {
                                        if (selectedSubject == null) {
                                          showRequestNotification(context,
                                              'Subject Tidak Boleh Kosong');
                                          return;
                                        }
                                        addRequest(
                                            currentUser.id,
                                            sessionList
                                                .where((element) =>
                                                    element.subject.name ==
                                                    selectedSubject)
                                                .first
                                                .id
                                                .toHexString(),
                                            day,
                                            duration,
                                            className,
                                            reason.text);
                                        showRequestNotification(context,
                                            'Permintaan Telah Dikirim');
                                      },
                                      child: Text('Kirim')),
                                )
                              ]),
                        )
                      ]),
                ),
              ),
            );
          },
        );
      });
}

Future<void> bookingDialog(context) async {
  return showDialog(
      context: context,
      builder: (context) {
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
