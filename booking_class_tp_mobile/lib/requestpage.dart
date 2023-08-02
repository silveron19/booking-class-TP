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
    retrieveRequest();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future retrieveRequest() async {
    List<Request> response = await getRequest(widget.currentUser!);
    if (mounted) {
      setState(() {
        userRequests = response;
        hasRetrievedRequest = true;
        modifiableList = response;
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
          return RefreshIndicator(
            onRefresh: retrieveRequest,
            child: AlertDialog(
              content: Text(
                  'Apakah anda yakin ingin menghapus request ini secara permanen?'),
              icon: Icon(
                Symbols.delete_outline_rounded,
                size: 96,
                semanticLabel: 'Delete',
              ),
              alignment: Alignment.center,
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actionsPadding: EdgeInsets.only(bottom: 24, left: 24, right: 24),
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
                    SizedBox(
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
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    super.build;
    return Container(
      padding: paddings,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            decoration: BoxDecoration(
                color: Color(0xffE6E6E6),
                borderRadius: BorderRadius.circular(8)),
            height: 48,
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                suffixIcon: Icon(Icons.search_outlined),
                hintText: 'Masukkan Pencarian',
              ),
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Container(
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
          SizedBox(
            height: 24,
          ),
          Flexible(
            child: modifiableList.isEmpty && !hasRetrievedRequest
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : modifiableList.isEmpty && hasRetrievedRequest
                    ? Center(
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
                              padding: EdgeInsets.symmetric(
                                  vertical: 24, horizontal: 24),
                              child: Row(children: [
                                Icon(
                                  Symbols.circle,
                                  color:
                                      modifiableList[index].status == 'Diterima'
                                          ? Colors.green
                                          : modifiableList[index].status ==
                                                  'Ditolak'
                                              ? Colors.red
                                              : grey,
                                  fill: 1,
                                ),
                                SizedBox(
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
                          return SizedBox(
                            height: 18,
                          );
                        },
                      ),
          )
        ],
      ),
    );
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
            padding: EdgeInsets.all(24),
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                            child: Icon(
                              Symbols.close,
                              size: 32,
                            )),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                myDialog(context, theRequest);
                              },
                              child: Icon(
                                Symbols.delete_outline,
                                size: 32,
                              ),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Row(
                      children: [
                        Icon(
                          Symbols.calendar_month,
                          size: 28,
                        ),
                        SizedBox(
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
                                    style: TextStyle(
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Nama Mata Kuliah: '),
                    SizedBox(
                      height: 12,
                    ),
                    Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                            border: Border.all(color: indigoDye),
                            borderRadius: BorderRadius.circular(8)),
                        child: Text(theRequest.sessionDetail.subject.name)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Jadwal Baru: '),
                    SizedBox(
                      height: 12,
                    ),
                    Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(8)),
                        child: Text(
                            '${theRequest.newDay}, ${theRequest.newStartTime} - ${theRequest.newEndTime}')),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Kelas Baru: '),
                    SizedBox(
                      height: 12,
                    ),
                    Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(8)),
                        child: Text(theRequest.newClassroom)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Alasan: '),
                    SizedBox(
                      height: 12,
                    ),
                    Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(8)),
                        child: Text(theRequest.reason)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Status: '),
                    SizedBox(
                      height: 12,
                    ),
                    Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                            SizedBox(
                              width: 12,
                            ),
                            Text(theRequest.status)
                          ],
                        )),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
