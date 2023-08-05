import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'Connection/database_connetion.dart';
import 'Entities/entities.dart';
import 'main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.currentUser});

  final User? currentUser;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  List todaySession = [];
  bool todayIsEmpty = false;
  int activeClass = 0;

  @override
  bool get wantKeepAlive {
    return true;
  }

  @override
  void initState() {
    super.initState();
    getTodaySessionFromGlobalSession();
  }

  Future homePageRefresh() async {
    await getSessionFromDatabase();
    await getTodaySessionFromGlobalSession();
  }

  int converting(String time) {
    List myTime = time.split(":");
    return int.parse(myTime[0]) * 60 + int.parse(myTime[1]);
  }

  Future<void> getTodaySessionFromGlobalSession() async {
    setState(() {
      todaySession = [];
    });
    List<Session> session = [];
    List<String> dayOfTheWeek = [
      'Minggu',
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jum\'at',
      'Sabtu',
    ];
    var hari = DateTime.now().weekday;
    if (widget.currentUser!.role != 'admin') {
      for (var element in globalSession) {
        if ((element['student'] as List).contains(widget.currentUser!.id) &&
            element['day'] == dayOfTheWeek[hari]) {
          var retrievedSubject =
              getSubjectFromGlobalSubjectForSession(element['subject']);
          var studentList =
              getStudentsFromGlobalUserForSession(element['student']);
          session.add(Session(
              element['_id'],
              element["day"],
              element['start_time'],
              element['end_time'],
              element['lecturer'],
              studentList,
              retrievedSubject,
              element['classroom'],
              element['department']));
        }
      }
    } else {
      for (var element in globalSession) {
        if (element['department'] == widget.currentUser!.department &&
            element['day'] == dayOfTheWeek[hari]) {
          var retrievedSubject =
              getSubjectFromGlobalSubjectForSession(element['subject']);
          var studentList =
              getStudentsFromGlobalUserForSession(element['student']);
          session.add(Session(
              element['_id'],
              element["day"],
              element['start_time'],
              element['end_time'],
              element['lecturer'],
              studentList,
              retrievedSubject,
              element['classroom'],
              element['department']));
        }
      }
    }

    session.sort(
        (a, b) => converting(a.startTime).compareTo(converting(b.startTime)));

    DateTime now = DateTime.now();
    for (var element in session) {
      List<String> sessionTime = element.startTime.split(':');
      if (int.parse(sessionTime[0]) > now.hour) {
        activeClass = session.indexOf(element);
        break;
      } else {
        activeClass = session.length - 1;
      }
    }
    setState(() {
      todaySession = session;
      todayIsEmpty = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: homePageRefresh,
      child: todaySession.isEmpty && !todayIsEmpty
          ? const Center(child: CircularProgressIndicator())
          : todaySession.isEmpty && todayIsEmpty
              ? Center(
                  child: Card(
                  child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Symbols.warning,
                            color: dimGrey,
                            size: 64,
                          ),
                          const Text(
                              'Anda tidak memiliki mata kuliah untuk hari ini'),
                        ],
                      )),
                ))
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                      Container(
                        padding: paddings,
                        child: Stack(children: [
                          SizedBox(
                            width: 720,
                            child: Card(
                              semanticContainer: true,
                              child: AspectRatio(
                                aspectRatio: 20 / 10,
                                child: Image.asset(
                                  'assets/image/banner.png',
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 24, horizontal: 32),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  'Kelas Berikutnya',
                                  style: TextStyle(
                                      color: customWhite,
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal),
                                ),
                                Text(
                                  todaySession[activeClass].subject.name,
                                  style: TextStyle(
                                      color: customWhite,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  'CR ${todaySession[activeClass].classroom}',
                                  style: TextStyle(
                                      color: customWhite,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${todaySession[activeClass].day}, ${todaySession[activeClass].startTime} - ${todaySession[activeClass].endTime}',
                                  style: TextStyle(
                                      color: customWhite,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.right,
                                ),
                              ],
                            ),
                          ),
                        ]),
                      ),
                      const Divider(
                        height: 2,
                        color: Colors.grey,
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * .45,
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Jadwal Hari Ini',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: todaySession.length,
                                  itemBuilder: (BuildContext context, index) {
                                    return Container(
                                      width: 480,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 12),
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                color: dimGrey,
                                                offset: const Offset(2, 2),
                                                blurRadius: 2)
                                          ],
                                          border: Border.all(color: indigoDye),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: activeClass == index
                                              ? indigoDye
                                              : customWhite),
                                      child: Row(
                                        children: [
                                          Text(
                                            'CR ${todaySession[index].classroom}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: activeClass == index
                                                  ? customWhite
                                                  : customBlack,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 24,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                todaySession[index]
                                                    .subject
                                                    .name,
                                                style: TextStyle(
                                                    color: activeClass == index
                                                        ? customWhite
                                                        : customBlack,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                '${todaySession[index].startTime} - ${todaySession[index].endTime} ',
                                                style: TextStyle(
                                                    color: activeClass == index
                                                        ? customWhite
                                                        : customBlack,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        ),
                        // Column(
                        //     crossAxisAlignment: CrossAxisAlignment.stretch,
                        //     children: [
                        //       Text(
                        //         'Jadwal Hari Ini',
                        //         textAlign: TextAlign.left,
                        //         style:
                        //             TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        //       ),
                        //       SizedBox(
                        //         height: 16,
                        //       ),
                        //       SingleChildScrollView(
                        //         child: Column(
                        //           children: [
                        //             Container(
                        //               padding: EdgeInsets.symmetric(vertical: 18),
                        //               decoration: BoxDecoration(
                        //                   borderRadius: BorderRadius.circular(8),
                        //                   color: indigoDye),
                        //               child: Row(
                        //                   mainAxisAlignment:
                        //                       MainAxisAlignment.spaceAround,
                        //                   children: [
                        //                     Text(
                        //                       'CR 201',
                        //                       style: TextStyle(
                        //                           color: customWhite,
                        //                           fontWeight: FontWeight.bold,
                        //                           fontSize: 14),
                        //                       textAlign: TextAlign.left,
                        //                     ),
                        //                     Column(
                        //                       crossAxisAlignment:
                        //                           CrossAxisAlignment.start,
                        //                       children: [
                        //                         Text(
                        //                           'Rekayasa Perangkat Lunak',
                        //                           style: TextStyle(
                        //                               color: customWhite,
                        //                               fontWeight: FontWeight.bold,
                        //                               fontSize: 18),
                        //                           textAlign: TextAlign.left,
                        //                         ),
                        //                         Text(
                        //                           'Senin, 10:00 -  12:00',
                        //                           style: TextStyle(
                        //                               color: customWhite,
                        //                               fontSize: 16,
                        //                               fontWeight: FontWeight.bold),
                        //                         )
                        //                       ],
                        //                     )
                        //                   ]),
                        //             ),
                        //             Container(
                        //               margin: EdgeInsets.symmetric(vertical: 14),
                        //               padding: EdgeInsets.symmetric(vertical: 18),
                        //               decoration: BoxDecoration(
                        //                   borderRadius: BorderRadius.circular(8),
                        //                   color: customWhite,
                        //                   border: Border.all(color: indigoDye)),
                        //               child: Row(
                        //                   mainAxisAlignment:
                        //                       MainAxisAlignment.spaceAround,
                        //                   children: [
                        //                     Text(
                        //                       'CR 201',
                        //                       style: TextStyle(
                        //                           color: indigoDye,
                        //                           fontWeight: FontWeight.bold,
                        //                           fontSize: 14),
                        //                       textAlign: TextAlign.left,
                        //                     ),
                        //                     Column(
                        //                       crossAxisAlignment:
                        //                           CrossAxisAlignment.start,
                        //                       children: [
                        //                         Text(
                        //                           'Rekayasa Perangkat Lunak',
                        //                           style: TextStyle(
                        //                               color: indigoDye,
                        //                               fontWeight: FontWeight.bold,
                        //                               fontSize: 18),
                        //                           textAlign: TextAlign.left,
                        //                         ),
                        //                         Text(
                        //                           'Senin, 10:00 -  12:00',
                        //                           style: TextStyle(
                        //                               color: indigoDye,
                        //                               fontSize: 16,
                        //                               fontWeight: FontWeight.bold),
                        //                         )
                        //                       ],
                        //                     )
                        //                   ]),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     ]),
                      )
                    ]),
    );
  }
}
