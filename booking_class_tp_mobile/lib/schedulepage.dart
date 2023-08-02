import 'package:booking_class_tp_mobile/Connection/database_connetion.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'Entities/entities.dart';
import 'main.dart';

TextStyle myTileTrailingStyle = const TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.bold,
);

class SchedulePage extends StatefulWidget {
  SchedulePage({super.key, required this.currentUser});
  final User? currentUser;
  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage>
    with AutomaticKeepAliveClientMixin {
  List<Session> sessions = [];
  Session? activeSession;
  int? selectedIndex;
  bool gotResponse = false;

  @override
  bool get wantKeepAlive {
    return true;
  }

  TextStyle title = const TextStyle(fontWeight: FontWeight.bold, fontSize: 18);

  @override
  void initState() {
    super.initState();
    getUserSession();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future getUserSession() async {
    List<Session> session = await getSessions(widget.currentUser!);
    if (mounted) {
      setState(() {
        sessions = session;
        gotResponse = true;
      });
    }
  }

  List<Session> sessionCount(List<Session> session, String day) {
    List<Session> sessionInTheDay = [];
    for (Session element in session) {
      if (element.day == day) {
        sessionInTheDay.add(element);
      }
    }

    return sessionInTheDay;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: getUserSession,
      child: sessions.isEmpty && !gotResponse
          ? Center(
              child: CircularProgressIndicator(),
            )
          : sessions.isEmpty && gotResponse
              ? Center(
                  child: Text('Anda belum terdaftar pada mata kuliah apapun'),
                )
              : Container(
                  padding: paddings,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        columnOfDay('Senin'),
                        columnOfDay('Selasa'),
                        columnOfDay('Rabu'),
                        columnOfDay('Kamis'),
                        columnOfDay('Jum\'at'),
                      ],
                    ),
                  )),
    );
  }

  Column columnOfDay(String day) {
    List<Session> thisDaySession = sessionCount(sessions, day);
    if (thisDaySession.isNotEmpty) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            day,
            style: title,
          ),
          SizedBox(
            height: 4,
          ),
          Flexible(fit: FlexFit.loose, child: sessionsOfItsDay(thisDaySession))
        ],
      );
    }
    return Column();
  }

  ListView sessionsOfItsDay(List<Session> thisDaySessions) {
    return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: thisDaySessions.length,
        itemBuilder: (BuildContext context, index) {
          Session thisSession = thisDaySessions[index];
          return InkWell(
            onTap: () {
              scheduleModalBottomSheet(context, thisSession
                  // thisSession.subject,
                  // '${thisSession.day}, ${thisSession.startTime} - ${thisSession.endTime}',
                  // thisSession.classroom,
                  // thisSession.lecturer,
                  // thisSession.students.length.toString()
                  );
              if (mounted) {
                setState(() {
                  activeSession = thisDaySessions[index];
                });
              }
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              padding: EdgeInsets.all(18),
              decoration: BoxDecoration(
                  border: Border.all(
                    color:
                        activeSession == thisSession ? customWhite : indigoDye,
                    width: 2,
                  ),
                  color: activeSession == thisSession ? indigoDye : customWhite,
                  borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: [
                  Text(
                    thisDaySessions[index].classroom,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: activeSession == thisSession
                            ? customWhite
                            : indigoDye),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Text(
                      thisDaySessions[index].subject.name,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: activeSession == thisSession
                              ? customWhite
                              : indigoDye),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<dynamic> scheduleModalBottomSheet(
      BuildContext context, Session thisSession
      // Subjects mataKuliah,
      // String tanggal,
      // String kelas,
      // String namaDosen,
      // String jumlahMurid,
      ) {
    return showModalBottomSheet(
        anchorPoint: const Offset(0, 96),
        showDragHandle: true,
        enableDrag: true,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            side: BorderSide(),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12))),
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 32),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Icon(
                        Symbols.calendar_month,
                        size: 24,
                      ),
                      SizedBox(
                        width: 24,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            thisSession.subject.name,
                            style: myTileTrailingStyle,
                          ),
                          Text(
                            '${thisSession.day}, ${thisSession.startTime} - ${thisSession.endTime}',
                            style: TextStyle(
                                color: dimGrey,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  Row(
                    children: [
                      Icon(
                        Symbols.location_on,
                        size: 24,
                      ),
                      SizedBox(
                        width: 24,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CR ${thisSession.classroom}',
                            style: myTileTrailingStyle,
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  Row(
                    children: [
                      Icon(
                        Symbols.school,
                        size: 24,
                      ),
                      SizedBox(
                        width: 24,
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              thisSession.lecturer,
                              style: myTileTrailingStyle,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  Row(
                    children: [
                      Icon(
                        Symbols.groups,
                        size: 24,
                      ),
                      SizedBox(
                        width: 24,
                      ),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${thisSession.students.length} Orang',
                              style: myTileTrailingStyle,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  if (widget.currentUser!.id ==
                          thisSession.subject.classPresident ||
                      widget.currentUser!.role == 'admin')
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          widget.currentUser!.role == 'admin'
                              ? 'Pilih ketua kelas mata kuliah ini'
                              : 'Kamu ketua kelas mata kuliah ini',
                          textAlign: TextAlign.start,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: indigoDye),
                                onPressed: () {
                                  changeScheduleModalBottomSheet(
                                      context, thisSession);
                                },
                                child: Text(
                                  widget.currentUser!.role == 'admin'
                                      ? 'Pilih Ketua Kelas'
                                      : 'Ganti Jadwal',
                                  style: TextStyle(
                                      color: customWhite,
                                      fontWeight: FontWeight.bold),
                                )),
                          ],
                        )
                      ],
                    )
                ]),
          );
        });
  }

  Future<dynamic> changeScheduleModalBottomSheet(
      BuildContext context, Session thisSession) {
    String? newDay;
    String? newDuration;
    String? newClass;
    String? chosenChief;
    TextEditingController reason = TextEditingController();
    final List<String> days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jum\'at'];
    final List<String> durations = [
      '07:30 - 09:30',
      '10:00 - 12:30',
      '13:00 - 15:30',
    ];

    final List<String> classrooms = [
      "G01",
      "G02",
      "G03",
      "G04",
      "G05",
      "G06",
      "G07",
      "G08",
      "G09",
      "G10",
      "G11",
      "G12",
      "G13",
      "101",
      "102",
      "103",
      "104",
      "105",
      "106",
      "107",
      "108",
      "109",
      "110",
      "111",
      "112",
      "113",
      "201",
      "202",
      "203",
      "204",
      "205",
      "206",
      "207",
      "208",
      "209",
      "210",
      "211",
      "212",
      "213",
      "301",
      "302",
      "303",
      "304",
      "305",
      "306",
      "307",
      "308",
      "309",
      "310",
      "311",
      "312",
      "313"
    ];
    return showModalBottomSheet(
      isScrollControlled: true,
      showDragHandle: true,
      context: context,
      builder: (context) {
        bool isRequesting = false;
        if (mounted) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height - 32,
                    padding: EdgeInsets.symmetric(vertical: 18, horizontal: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              child: Icon(Icons.close),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Text(
                              thisSession.subject.name,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 48,
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 18),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        child: Row(
                                          children: [
                                            Icon(Symbols.calendar_month),
                                            SizedBox(width: 12),
                                            Text(
                                                '${thisSession.day}, ${thisSession.startTime} - ${thisSession.endTime}'),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        child: Row(
                                          children: [
                                            Icon(Symbols.school),
                                            SizedBox(width: 12),
                                            Text(thisSession.lecturer),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        child: Row(
                                          children: [
                                            Icon(Symbols.location_on),
                                            SizedBox(width: 12),
                                            Text('CR ${thisSession.classroom}'),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        child: Row(
                                          children: [
                                            Icon(Symbols.groups),
                                            SizedBox(width: 12),
                                            Text(
                                                '${thisSession.students.length} Orang'),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 24,
                                      ),
                                    ]),
                                widget.currentUser!.role == 'admin'
                                    ? Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                Text('Pilih Ketua Kelas'),
                                                SizedBox(
                                                  height: 12,
                                                ),
                                                DropdownButtonHideUnderline(
                                                  child:
                                                      DropdownButton2<String>(
                                                    isExpanded: true,
                                                    hint: Text(
                                                      'Pilih ketua kelas',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: customWhite,
                                                      ),
                                                    ),
                                                    items: thisSession.students
                                                        .map((item) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: item['_id'],
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .stretch,
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Text(
                                                              item['name'],
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  color:
                                                                      customWhite),
                                                            ),
                                                            Text(
                                                              item['_id'],
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color:
                                                                      customWhite),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    }).toList(),
                                                    value: chosenChief,
                                                    onChanged: (String? value) {
                                                      setState(() {
                                                        chosenChief = value;
                                                      });
                                                    },
                                                    buttonStyleData:
                                                        ButtonStyleData(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 16),
                                                      height: 48,
                                                      width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width -
                                                          MediaQuery.of(context)
                                                                  .padding
                                                                  .left *
                                                              2,
                                                      decoration: BoxDecoration(
                                                        color: indigoDye,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        border: Border.all(
                                                            color: indigoDye),
                                                      ),
                                                    ),
                                                    dropdownStyleData:
                                                        DropdownStyleData(
                                                      decoration: BoxDecoration(
                                                        color: indigoDye,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                    ),
                                                    iconStyleData:
                                                        IconStyleData(
                                                      icon: Icon(
                                                        Icons
                                                            .keyboard_arrow_down,
                                                        color: customWhite,
                                                      ),
                                                    ),
                                                    menuItemStyleData:
                                                        const MenuItemStyleData(
                                                      height: 48,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 16.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            backgroundColor:
                                                                indigoDye),
                                                    onPressed: () {
                                                      if (chosenChief == null) {
                                                        showRequestNotification(
                                                            'Ketua Kelas Tidak Boleh Kosong!');
                                                        return;
                                                      }
                                                      updateClassChief(
                                                          thisSession
                                                              .subject.id,
                                                          chosenChief!);
                                                      showRequestNotification(
                                                          'Permintaan telah dikirim');
                                                    },
                                                    child: Text('Kirim')),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Text('Hari: '),
                                              DropdownButtonHideUnderline(
                                                child: DropdownButton2<String>(
                                                  isExpanded: true,
                                                  hint: Text(
                                                    'Pilih hari',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.indigo,
                                                    ),
                                                  ),
                                                  items: days.map((item) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: item,
                                                      child: Text(
                                                        item,
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.indigo),
                                                      ),
                                                    );
                                                  }).toList(),
                                                  value: newDay,
                                                  onChanged: (String? value) {
                                                    setState(() {
                                                      newDay = value;
                                                    });
                                                  },
                                                  buttonStyleData:
                                                      ButtonStyleData(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 16),
                                                    height: 32,
                                                    width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width -
                                                        MediaQuery.of(context)
                                                                .padding
                                                                .left *
                                                            2,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      border: Border.all(
                                                          color: Colors.indigo),
                                                    ),
                                                  ),
                                                  dropdownStyleData:
                                                      DropdownStyleData(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
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
                                            ],
                                          ),
                                          SizedBox(height: 24),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Text('Durasi Mata Kuliah: '),
                                              DropdownButtonHideUnderline(
                                                child: DropdownButton2<String>(
                                                  isExpanded: true,
                                                  hint: Text(
                                                    'Pilih sesi',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.indigo,
                                                    ),
                                                  ),
                                                  items: durations.map((item) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: item,
                                                      child: Text(
                                                        item,
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.indigo),
                                                      ),
                                                    );
                                                  }).toList(),
                                                  value: newDuration,
                                                  onChanged: (String? value) {
                                                    setState(() {
                                                      newDuration = value;
                                                    });
                                                  },
                                                  buttonStyleData:
                                                      ButtonStyleData(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 16),
                                                    height: 32,
                                                    width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width -
                                                        MediaQuery.of(context)
                                                                .padding
                                                                .left *
                                                            2,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      border: Border.all(
                                                          color: Colors.indigo),
                                                    ),
                                                  ),
                                                  dropdownStyleData:
                                                      DropdownStyleData(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
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
                                            ],
                                          ),
                                          SizedBox(
                                            height: 24,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Text('Kelas: '),
                                              DropdownButtonHideUnderline(
                                                child: DropdownButton2<String>(
                                                  isExpanded: true,
                                                  hint: Text(
                                                    'Pilih kelas',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.indigo,
                                                    ),
                                                  ),
                                                  items: classrooms.map((item) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: item,
                                                      child: Text(
                                                        item,
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.indigo),
                                                      ),
                                                    );
                                                  }).toList(),
                                                  value: newClass,
                                                  onChanged: (String? value) {
                                                    setState(() {
                                                      newClass = value;
                                                    });
                                                  },
                                                  buttonStyleData:
                                                      ButtonStyleData(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 16),
                                                    height: 32,
                                                    width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width -
                                                        MediaQuery.of(context)
                                                                .padding
                                                                .left *
                                                            2,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      border: Border.all(
                                                          color: Colors.indigo),
                                                    ),
                                                  ),
                                                  dropdownStyleData:
                                                      DropdownStyleData(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
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
                                            ],
                                          ),
                                          SizedBox(height: 24),
                                          Container(
                                            padding: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: indigoDye),
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            child: TextField(
                                              controller: reason,
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText:
                                                      'Berikan deskripsi request disini'),
                                              maxLines: 5,
                                              maxLength: 100,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          ElevatedButton(
                                            onPressed: () async {
                                              if (newDay == null) {
                                                showRequestNotification(
                                                    'Hari Tidak Boleh Kosong!');
                                                return;
                                              } else if (newDuration == null) {
                                                showRequestNotification(
                                                    'Waktu Tidak Boleh Kosong');
                                                return;
                                              } else if (newClass == null) {
                                                showRequestNotification(
                                                    'Kelas Tidak Boleh Kosong');
                                                return;
                                              } else if (reason.text
                                                  .trim()
                                                  .isEmpty) {
                                                showRequestNotification(
                                                    'Alasan tidak boleh kosong');
                                                return;
                                              }

                                              setState(() {
                                                isRequesting = true;
                                              });

                                              List check = await checkIfCanBook(
                                                  newDay,
                                                  newDuration,
                                                  newClass);

                                              print(check);

                                              if (check.isEmpty) {
                                                showRequestNotification(
                                                    'Permintaan telah dikirim');
                                                addRequest(
                                                    widget.currentUser!.id,
                                                    thisSession.id
                                                        .toHexString(),
                                                    newDay!,
                                                    newDuration!,
                                                    newClass!,
                                                    reason.text);
                                              } else {
                                                showRequestNotification(
                                                    'Permintaan tidak dapat dilakukan');
                                              }

                                              setState(() {
                                                isRequesting = false;
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: indigoDye),
                                            child: isRequesting
                                                ? const CircularProgressIndicator()
                                                : Text(
                                                    'Kirim',
                                                    style: TextStyle(
                                                        color: customWhite),
                                                  ),
                                          )
                                        ],
                                      )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return Center(child: Text('Empty'));
        }
      },
    );
  }

  Future showRequestNotification(String popUpText) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(popUpText),
          );
        });
  }
}
