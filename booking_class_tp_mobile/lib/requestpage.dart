import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'Connection/database_connetion.dart';
import 'Entities/entities.dart';
import 'main.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({super.key, required this.currentUser});
  final User? currentUser;
  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage>
    with AutomaticKeepAliveClientMixin {
  List<Request> userRequests = [];
  List<Request> modifiableList = [];
  bool hasRetrievedRequest = false;
  List<String> sortingChoices = ['Terbaru', 'Terlama'];
  List filterChoices = ['Ditolak', 'Diterima', 'Menunggu Verifikasi', null];
  String? sort;
  String? filter;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    getRequestFromGlobalRequest();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future requestRefresh() async {
    await getRequestFromDatabase();
    await getRequestFromGlobalRequest();
  }

  Future getRequestFromGlobalRequest() async {
    List<Request> globalRequestRequestPage = [];
    List userRequest = [];
    if (widget.currentUser!.role == 'admin') {
      for (var element in globalRequest) {
        userRequest.add(element);
      }
    } else {
      for (var element in globalRequest) {
        if (element['request_by'] == widget.currentUser!.id) {
          userRequest.add(element);
        }
      }
    }

    for (var element in userRequest) {
      Session sessionOfThisRequest =
          getSessionForRequest(element['session_detail']);
      User userOfThisRequest = getUserForRequest(element['request_by']);
      globalRequestRequestPage.add(Request(
          element['_id'],
          sessionOfThisRequest,
          userOfThisRequest,
          element['new_day'],
          element['new_start_time'],
          element['new_end_time'],
          element['new_classroom'],
          element['reason'],
          element['status'],
          element['created_at'],
          element['updated_at']));
    }

    if (mounted) {
      setState(() {
        userRequests = globalRequestRequestPage;
        hasRetrievedRequest = true;
        modifiableList = globalRequestRequestPage;
      });
    }
  }

  void sortRequest() {
    List<Request> thisRequest = [];
    if (filter != null) {
      for (Request num in userRequests) {
        if (num.status == filter) {
          thisRequest.add(num);
        }
      }
    } else {
      thisRequest = userRequests;
    }

    switch (sort) {
      case 'Terbaru':
        thisRequest.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'Terlama':
        thisRequest.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    }

    // for (Request reqs in modifiableList) {
    //   print(reqs.createdAt);
    // }

    setState(() {
      modifiableList = thisRequest;
    });
  }

  Future<void> myDialog(BuildContext context, Request theRequest) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Text(
                'Apakah anda yakin ingin menghapus request ini secara permanen?'),
            icon: const Icon(
              Symbols.delete_outline_rounded,
              size: 96,
              semanticLabel: 'Delete',
            ),
            alignment: Alignment.center,
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actionsPadding:
                const EdgeInsets.only(bottom: 24, left: 24, right: 24),
            actions: [
              Row(
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: Container(
                      decoration: BoxDecoration(
                          color: antiFlashWhite,
                          borderRadius: BorderRadius.circular(8)),
                      child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Batal',
                            style: TextStyle(
                                color: dimGrey, fontWeight: FontWeight.bold),
                          )),
                    ),
                  ),
                  const SizedBox(
                    width: 24,
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8)),
                        child: TextButton(
                            onPressed: () {
                              deleteRequest(theRequest.id);
                              modifiableList.removeWhere(
                                  (element) => element.id == theRequest.id);
                              userRequests.removeWhere(
                                  (element) => element.id == theRequest.id);
                              setState(() {
                                modifiableList;
                                userRequests;
                              });
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Hapus',
                              style: TextStyle(
                                  color: customWhite,
                                  fontWeight: FontWeight.bold),
                            ))),
                  ),
                ],
              )
            ],
          );
        });
  }

  Future<dynamic> showingBottomSheet(BuildContext context, Request theRequest) {
    List<String> dayOfTheWeek = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jum\'at',
      'Sabtu',
      'Minggu'
    ];

    List<String> months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];

    String day = dayOfTheWeek[theRequest.createdAt.weekday - 1];
    String month = months[theRequest.createdAt.month - 1];
    String hour = theRequest.createdAt.hour.toString();
    String minute = theRequest.createdAt.minute.toString();
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.all(24),
            height: MediaQuery.of(context).size.height * .95,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const Icon(
                                  Symbols.close,
                                  size: 32,
                                )),
                            if (widget.currentUser!.role != 'admin')
                              InkWell(
                                onTap: () {
                                  myDialog(context, theRequest);
                                },
                                child: const Icon(
                                  Symbols.delete_outline,
                                  size: 32,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Symbols.calendar_month,
                              size: 28,
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        theRequest.requestBy.name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                  Text(
                                      '$day, ${theRequest.createdAt.day}, $month ${theRequest.createdAt.year} | $hour:$minute'),
                                  // ${DateFormat.Hm(theRequest.createdAt).toString()}
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text('Nama Mata Kuliah: '),
                        const SizedBox(
                          height: 12,
                        ),
                        Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            decoration: BoxDecoration(
                                border: Border.all(color: indigoDye),
                                borderRadius: BorderRadius.circular(8)),
                            child: Text(theRequest.sessionDetail.subject.name)),
                        const SizedBox(
                          height: 12,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text('Jadwal Baru: '),
                        const SizedBox(
                          height: 12,
                        ),
                        Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(8)),
                            child: Text(
                                '${theRequest.newDay}, ${theRequest.newStartTime} - ${theRequest.newEndTime}')),
                        const SizedBox(
                          height: 12,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text('Kelas Baru: '),
                        const SizedBox(
                          height: 12,
                        ),
                        Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(8)),
                            child: Text(theRequest.newClassroom)),
                        const SizedBox(
                          height: 12,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text('Alasan: '),
                        const SizedBox(
                          height: 12,
                        ),
                        Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(8)),
                            child: Text(theRequest.reason)),
                        const SizedBox(
                          height: 12,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text('Status: '),
                        const SizedBox(
                          height: 12,
                        ),
                        Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              children: [
                                Icon(
                                  Symbols.radio_button_unchecked,
                                  fill: 1,
                                  color: theRequest.status == 'Diterima'
                                      ? Colors.green
                                      : theRequest.status == 'Ditolak'
                                          ? Colors.red
                                          : Colors.grey,
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Text(theRequest.status)
                              ],
                            )),
                        const SizedBox(
                          height: 12,
                        ),
                      ],
                    ),
                  ],
                ),
                if (widget.currentUser!.role == 'admin' &&
                    theRequest.status.toLowerCase() == 'menunggu verifikasi')
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: indigoDye),
                            onPressed: () {
                              myRejectDialog(context, theRequest);
                            },
                            child: const Text('Tolak')),
                        const SizedBox(
                          width: 16,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: indigoDye),
                            onPressed: () {
                              updateSession(theRequest, 'Diterima');
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    Future.delayed(
                                        const Duration(milliseconds: 500), () {
                                      Navigator.pop(context);
                                    });
                                    return const AlertDialog(
                                      content: Text('Permintaan dikirim'),
                                    );
                                  });
                              userRequests
                                  .where(
                                      (element) => element.id == theRequest.id)
                                  .forEach((element) {
                                element.status = 'Diterima';
                              });
                              modifiableList
                                  .where(
                                      (element) => element.id == theRequest.id)
                                  .forEach((element) {
                                element.status = 'Diterima';
                              });
                              setState(() {
                                modifiableList;
                                userRequests;
                              });
                            },
                            child: const Text('Terima'))
                      ],
                    ),
                  ),
              ],
            ),
          );
        });
  }

  Future<void> myRejectDialog(BuildContext context, Request theRequest) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Text('Apakah anda yakin ingin menolak request?'),
            icon: const Icon(
              Symbols.warning,
              size: 96,
              semanticLabel: 'Delete',
            ),
            alignment: Alignment.center,
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actionsPadding:
                const EdgeInsets.only(bottom: 24, left: 24, right: 24),
            actions: [
              Row(
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: Container(
                      decoration: BoxDecoration(
                          color: antiFlashWhite,
                          borderRadius: BorderRadius.circular(8)),
                      child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Batal',
                            style: TextStyle(
                                color: dimGrey, fontWeight: FontWeight.bold),
                          )),
                    ),
                  ),
                  const SizedBox(
                    width: 24,
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8)),
                        child: TextButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return const AlertDialog(
                                      content: Text('Request Telah Ditolak'),
                                    );
                                  });
                              userRequests
                                  .where(
                                      (element) => element.id == theRequest.id)
                                  .forEach((element) {
                                element.status = 'Ditolak';
                              });
                              modifiableList
                                  .where(
                                      (element) => element.id == theRequest.id)
                                  .forEach((element) {
                                element.status = 'Ditolak';
                              });
                              updateSession(theRequest, 'Ditolak');
                              setState(() {
                                modifiableList;
                                userRequests;
                              });
                              Future.delayed(const Duration(milliseconds: 400),
                                  () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              });
                            },
                            child: Text(
                              'Tolak',
                              style: TextStyle(
                                  color: customWhite,
                                  fontWeight: FontWeight.bold),
                            ))),
                  ),
                ],
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    super.build;
    return RefreshIndicator(
      onRefresh: requestRefresh,
      child: Container(
        padding: paddings,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 16, right: 16),
              decoration: BoxDecoration(
                  color: const Color(0xffE6E6E6),
                  borderRadius: BorderRadius.circular(8)),
              height: 48,
              child: const TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  suffixIcon: Icon(Icons.search_outlined),
                  hintText: 'Masukkan Pencarian',
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: indigoDye),
                        borderRadius: BorderRadius.circular(8)),
                    child: DropdownMenu(
                      onSelected: (value) {
                        sort = value;
                        sortRequest();
                      },
                      width: (MediaQuery.of(context).size.width - 64) / 2 - 10,
                      hintText: 'Terbaru',
                      dropdownMenuEntries: sortingChoices
                          .map((e) => DropdownMenuEntry(value: e, label: e))
                          .toList(),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: indigoDye),
                        borderRadius: BorderRadius.circular(8)),
                    child: DropdownMenu(
                      onSelected: (value) {
                        filter = value;
                        sortRequest();
                      },
                      width: (MediaQuery.of(context).size.width - 64) / 2 - 10,
                      hintText: 'Semua',
                      dropdownMenuEntries: filterChoices
                          .map((e) =>
                              DropdownMenuEntry(value: e, label: e ?? 'Semua'))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Flexible(
              child: modifiableList.isEmpty && !hasRetrievedRequest
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : modifiableList.isEmpty && hasRetrievedRequest
                      ? const Center(
                          child: Text('Oops kamu belum membuat request'),
                        )
                      : ListView.separated(
                          itemCount: modifiableList.length,
                          itemBuilder: (context, index) {
                            var textStyle = TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: customWhite);
                            var textStyle2 =
                                TextStyle(fontSize: 14, color: customWhite);

                            return InkWell(
                              onTap: () {
                                showingBottomSheet(
                                    context, modifiableList[index]);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: indigoDye),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 24, horizontal: 24),
                                child: Row(children: [
                                  Icon(
                                    Symbols.circle,
                                    color: modifiableList[index].status ==
                                            'Diterima'
                                        ? Colors.green
                                        : modifiableList[index].status ==
                                                'Ditolak'
                                            ? Colors.red
                                            : grey,
                                    fill: 1,
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              modifiableList[index]
                                                  .requestBy
                                                  .name,
                                              style: textStyle,
                                            ),
                                          ],
                                        ),
                                        Text(
                                          modifiableList[index].requestBy.id,
                                          style: textStyle,
                                        ),
                                        Divider(
                                          color: customWhite,
                                        ),
                                        Text(
                                          modifiableList[index]
                                              .sessionDetail
                                              .subject
                                              .name,
                                          style: textStyle2,
                                        ),
                                      ],
                                    ),
                                  )
                                ]),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              height: 18,
                            );
                          },
                        ),
            )
          ],
        ),
      ),
    );
  }
}
