import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'main.dart';

List requests = [
  {
    'nama': 'A. Analta Dwiyanto',
    'tanggal': 'Rabu, 21 Oktober 2090 | 08:00 WITA',
    'mata kuliah': 'Rekayasa Perangkat Lunak',
    'jadwal baru': 'Rabu, 20 September 2023 Pukul 07:30 - 08:30',
    'kelas baru': 'CR 100|201',
    'deskripsi': 'Dosen ingin mengganti kelas',
    'status': 'Ditolak',
    'alasan': 'Dalam proses renovasi',
  },
  {
    'nama': 'Testing',
    'tanggal': 'Rabu, 21 Oktober 2090 | 08:00 WITA',
    'mata kuliah': 'Rekayasa Perangkat Lunak',
    'jadwal baru': 'Rabu, 20 September 2023 Pukul 07:30 - 08:30',
    'kelas baru': 'CR 100|201',
    'deskripsi': 'Dosen ingin mengganti kelas',
    'status': 'Diterima',
    'alasan': 'Dalam proses renovasi',
  },
  {
    'nama': 'Fakhri',
    'tanggal': 'Kamis, 21 Oktober 2090 | 08:00 WITA',
    'mata kuliah': 'Rekayasa Perangkat Lunak',
    'jadwal baru': 'Rabu, 20 September 2023 Pukul 07:30 - 08:30',
    'kelas baru': 'CR 100|201',
    'deskripsi': 'Dosen ingin mengganti kelas',
    'status': 'Menunggu',
    'alasan': 'Dalam proses renovasi',
  },
  {
    'nama': 'Rasyad',
    'tanggal': 'Rabu, 21 Oktober 2090 | 08:00 WITA',
    'mata kuliah': 'Rekayasa Perangkat Lunak',
    'jadwal baru': 'Rabu, 20 September 2023 Pukul 07:30 - 08:30',
    'kelas baru': 'CR 100|201',
    'deskripsi': 'Dosen ingin mengganti kelas',
    'status': 'Ditolak',
    'alasan': 'Dalam proses renovasi',
  }
];

class Requests {
  Requests(
      {required this.nama,
      required this.tanggal,
      required this.mataKuliah,
      required this.jadwalBaru,
      required this.kelasBaru,
      required this.deskripsi,
      required this.status,
      required this.alasan});

  String nama;
  String tanggal;
  String mataKuliah;
  String jadwalBaru;
  String kelasBaru;
  String deskripsi;
  String status;
  String alasan;
}

Future<void> myDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
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
                          onPressed: () {},
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

class RequestPage extends StatefulWidget {
  const RequestPage({super.key});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  @override
  Widget build(BuildContext context) {
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
                    width: (MediaQuery.of(context).size.width - 64) / 2 - 10,
                    hintText: 'Terbaru',
                    dropdownMenuEntries: [
                      DropdownMenuEntry(label: 'Text', value: 'Label')
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: indigoDye),
                      borderRadius: BorderRadius.circular(8)),
                  child: DropdownMenu(
                    width: (MediaQuery.of(context).size.width - 64) / 2 - 10,
                    hintText: 'Semua',
                    dropdownMenuEntries: [
                      DropdownMenuEntry(label: 'Diterima', value: 'Label'),
                      DropdownMenuEntry(label: 'Ditolak', value: 'Label'),
                      DropdownMenuEntry(label: 'Menunggu', value: 'Label')
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: indigoDye),
                borderRadius: BorderRadius.circular(8)),
            child: DropdownMenu(
              width: MediaQuery.of(context).size.width - 64,
              hintText: 'Ganti Jadwal',
              dropdownMenuEntries: [
                DropdownMenuEntry(label: 'Text', value: 'Label')
              ],
            ),
          ),
          SizedBox(
            height: 24,
          ),
          Flexible(
            child: ListView.separated(
              itemCount: requests.length,
              itemBuilder: (context, index) {
                var textStyle = TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: customWhite);
                var textStyle2 = TextStyle(fontSize: 12, color: customWhite);
                var thisRequest = Requests(
                    nama: requests[index]['nama'],
                    tanggal: requests[index]['tanggal'],
                    mataKuliah: requests[index]['mata kuliah'],
                    jadwalBaru: requests[index]['jadwal baru'],
                    kelasBaru: requests[index]['kelas baru'],
                    deskripsi: requests[index]['deskripsi'],
                    status: requests[index]['status'],
                    alasan: requests[index]['alasan']);
                return InkWell(
                  onTap: () {
                    showingBottomSheet(context, thisRequest);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: indigoDye),
                    padding: EdgeInsets.symmetric(vertical: 24, horizontal: 24),
                    child: Row(children: [
                      Icon(
                        Symbols.circle,
                        color: thisRequest.status == 'Diterima'
                            ? Colors.green
                            : thisRequest.status == 'Ditolak'
                                ? Colors.red
                                : grey,
                        fill: 1,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  thisRequest.nama,
                                  style: textStyle,
                                ),
                                Text(
                                  thisRequest.tanggal,
                                  style: textStyle,
                                )
                              ],
                            ),
                            Text(
                              'D121211017',
                              style: textStyle,
                            ),
                            Divider(
                              color: customWhite,
                            ),
                            Text(
                              thisRequest.mataKuliah,
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

  Future<dynamic> showingBottomSheet(
      BuildContext context, Requests theRequest) {
    bool isReadOnly = true;
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return Container(
            padding: EdgeInsets.all(24),
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                myDialog(context);
                              },
                              child: Icon(
                                Symbols.delete_outline,
                                size: 32,
                              ),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isReadOnly = !isReadOnly;
                                });
                              },
                              child: Icon(
                                Symbols.edit_square_rounded,
                                size: 28,
                              ),
                            )
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
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                theRequest.nama,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.black),
                              ),
                              Text(theRequest.tanggal)
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
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(border: Border.all()),
                      child: TextFormField(
                        readOnly: isReadOnly,
                        initialValue: theRequest.mataKuliah,
                        decoration: InputDecoration(border: InputBorder.none),
                      ),
                    ),
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
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(border: Border.all()),
                      child: TextFormField(
                        readOnly: isReadOnly,
                        initialValue: theRequest.jadwalBaru,
                        decoration: InputDecoration(border: InputBorder.none),
                      ),
                    ),
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
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(border: Border.all()),
                      child: TextFormField(
                        readOnly: isReadOnly,
                        initialValue: theRequest.kelasBaru,
                        decoration: InputDecoration(border: InputBorder.none),
                      ),
                    ),
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
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(border: Border.all()),
                      child: TextFormField(
                        readOnly: isReadOnly,
                        initialValue: theRequest.alasan,
                        decoration: InputDecoration(border: InputBorder.none),
                      ),
                    ),
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
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(border: Border.all()),
                      child: TextFormField(
                        readOnly: isReadOnly,
                        initialValue: theRequest.status,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              Symbols.radio_button_unchecked,
                              fill: 1,
                              color: theRequest.status == 'Diterima'
                                  ? Colors.green
                                  : theRequest.status == 'Ditolak'
                                      ? Colors.red
                                      : Colors.grey,
                            )),
                      ),
                    ),
                  ],
                ),
                if (!isReadOnly)
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: indigoDye,
                          padding: EdgeInsets.symmetric(vertical: 18)),
                      onPressed: () {},
                      child: Text(
                        'Konfirmasi Perubahan',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ))
              ],
            ),
          );
        });
      },
    );
  }
}
