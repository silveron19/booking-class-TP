import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'main.dart';

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
                borderRadius: BorderRadius.circular(4)),
            height: 48,
            child: TextField(
              decoration: InputDecoration(
                  border: InputBorder.none,
                  suffixIcon: Icon(Icons.search_outlined),
                  hintText: 'Masukkan Pencarian'),
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
                DropdownMenu(
                  width: (MediaQuery.of(context).size.width - 64) / 2 - 10,
                  hintText: 'Terbaru',
                  dropdownMenuEntries: [
                    DropdownMenuEntry(label: 'Text', value: 'Label')
                  ],
                ),
                DropdownMenu(
                  width: (MediaQuery.of(context).size.width - 64) / 2 - 10,
                  hintText: 'Semua',
                  dropdownMenuEntries: [
                    DropdownMenuEntry(label: 'Text', value: 'Label')
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 12,
          ),
          DropdownMenu(
            width: MediaQuery.of(context).size.width - 64,
            hintText: 'Ganti Jadwal',
            dropdownMenuEntries: [
              DropdownMenuEntry(label: 'Text', value: 'Label')
            ],
          ),
          SizedBox(
            height: 24,
          ),
          Flexible(
            child: ListView.separated(
              itemCount: 5,
              itemBuilder: (context, index) {
                var textStyle = TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: customWhite);
                return InkWell(
                  onTap: () {
                    showingBottomSheet(context, 'Nama', 'Tanggal');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: indigoDye),
                    padding: EdgeInsets.symmetric(vertical: 24, horizontal: 32),
                    child: Row(children: [
                      Icon(
                        Symbols.circle,
                        color: grey,
                        fill: 1,
                      ),
                      SizedBox(
                        width: 24,
                      ),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Nama',
                                  style: textStyle,
                                ),
                                Text(
                                  'Waktu',
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
                              'Mata Kuliah',
                              style: textStyle,
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
      BuildContext context, String nama, String tanggal) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
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
                              onTap: () {},
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
                                nama,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.black),
                              ),
                              Text(tanggal)
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
                        readOnly: true,
                        initialValue: 'Value',
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
                        readOnly: true,
                        initialValue: 'Value',
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
                        readOnly: true,
                        initialValue: 'Value',
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
                        readOnly: true,
                        initialValue: 'Value',
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
                        readOnly: true,
                        initialValue: 'Value',
                        decoration: InputDecoration(border: InputBorder.none),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
