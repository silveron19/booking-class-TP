import 'package:flutter/material.dart';

import 'main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.max, children: [
      Container(
        padding: paddings,
        child: Stack(children: [
          Card(
            semanticContainer: true,
            child: Image.asset(
              'assets/image/banner.png',
              fit: BoxFit.fill,
            ),
          ),
          Container(
            height: 248,
            padding:
                const EdgeInsets.only(top: 12, bottom: 12, left: 18, right: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'Kelas Berikutnya',
                  style: TextStyle(
                      color: customWhite,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'Rekayasa Perangkat Lunak',
                  style: TextStyle(
                      color: customWhite,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'CR 201',
                  style: TextStyle(
                      color: customWhite,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'Senin, 10:00 - 12:00',
                  style: TextStyle(
                      color: customWhite,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
        ]),
      ),
      const Divider(),
      Container(
        width: MediaQuery.of(context).size.width,
        padding: paddings,
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(
            'Jadwal Hari Ini',
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 16,
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8), color: indigoDye),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'CR 201',
                          style: TextStyle(
                              color: customWhite,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                          textAlign: TextAlign.left,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Rekayasa Perangkat Lunak',
                              style: TextStyle(
                                  color: customWhite,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              'Senin, 10:00 -  12:00',
                              style: TextStyle(
                                  color: customWhite,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        )
                      ]),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 14),
                  padding: EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: customWhite,
                      border: Border.all(color: indigoDye)),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'CR 201',
                          style: TextStyle(
                              color: indigoDye,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                          textAlign: TextAlign.left,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Rekayasa Perangkat Lunak',
                              style: TextStyle(
                                  color: indigoDye,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              'Senin, 10:00 -  12:00',
                              style: TextStyle(
                                  color: indigoDye,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        )
                      ]),
                ),
              ],
            ),
          ),
        ]),
      )
    ]);
  }
}
