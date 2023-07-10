import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class JadwalVaksinasiPage extends StatefulWidget {
  JadwalVaksinasiPage({super.key});

  @override
  State<JadwalVaksinasiPage> createState() => _JadwalVaksinasiPageState();
}

class _JadwalVaksinasiPageState extends State<JadwalVaksinasiPage> {
  int selectedMonth = 0;
  int selected = 0;
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> vaccinationData = [
      {
        "periode": "1 Bulan",
        "vaksin": [
          {
            "vaksin_id": "1",
            "nama_vaksin": "Hepatitis B 1",
            "bulan_ke": "1",
            "is_active": "1",
            "created_by": "1",
            "created_date": "2023-06-24 19:59:50",
            "updated_by": null,
            "updated_date": null,
            "anak_id": "2",
            "status": "Sudah"
          },
          {
            "vaksin_id": "8",
            "nama_vaksin": "BCG",
            "bulan_ke": "1",
            "is_active": "1",
            "created_by": "1",
            "created_date": "2023-06-24 20:03:17",
            "updated_by": null,
            "updated_date": null,
            "anak_id": null,
            "status": "Belum"
          },
          {
            "vaksin_id": "9",
            "nama_vaksin": "DTP 1",
            "bulan_ke": "1",
            "is_active": "1",
            "created_by": "1",
            "created_date": "2023-06-24 20:04:06",
            "updated_by": null,
            "updated_date": null,
            "anak_id": null,
            "status": "Belum"
          },
          {
            "vaksin_id": "12",
            "nama_vaksin": "Hib 1",
            "bulan_ke": "1",
            "is_active": "1",
            "created_by": "1",
            "created_date": "2023-06-24 20:04:52",
            "updated_by": null,
            "updated_date": null,
            "anak_id": null,
            "status": "Belum"
          }
        ]
      },
      {
        "periode": "2 Bulan",
        "vaksin": [
          {
            "vaksin_id": "2",
            "nama_vaksin": "Hepatitis B 2",
            "bulan_ke": "2",
            "is_active": "1",
            "created_by": "1",
            "created_date": "2023-06-24 20:00:17",
            "updated_by": null,
            "updated_date": null,
            "anak_id": null,
            "status": "Belum"
          },
          {
            "vaksin_id": "5",
            "nama_vaksin": "Polio 1",
            "bulan_ke": "2",
            "is_active": "1",
            "created_by": "1",
            "created_date": "2023-06-24 20:03:08",
            "updated_by": null,
            "updated_date": null,
            "anak_id": null,
            "status": "Belum"
          },
          {
            "vaksin_id": "10",
            "nama_vaksin": "DTP 2",
            "bulan_ke": "2",
            "is_active": "1",
            "created_by": "1",
            "created_date": "2023-06-24 20:04:07",
            "updated_by": null,
            "updated_date": null,
            "anak_id": null,
            "status": "Belum"
          },
          {
            "vaksin_id": "13",
            "nama_vaksin": "Hib 2",
            "bulan_ke": "2",
            "is_active": "1",
            "created_by": "1",
            "created_date": "2023-06-24 20:04:52",
            "updated_by": null,
            "updated_date": null,
            "anak_id": null,
            "status": "Belum"
          },
          {
            "vaksin_id": "15",
            "nama_vaksin": "PCV 1",
            "bulan_ke": "2",
            "is_active": "1",
            "created_by": "1",
            "created_date": "2023-06-24 20:05:10",
            "updated_by": null,
            "updated_date": null,
            "anak_id": null,
            "status": "Belum"
          },
          {
            "vaksin_id": "18",
            "nama_vaksin": "Rotavirus 1",
            "bulan_ke": "2",
            "is_active": "1",
            "created_by": "1",
            "created_date": "2023-06-24 20:06:38",
            "updated_by": null,
            "updated_date": null,
            "anak_id": null,
            "status": "Belum"
          }
        ]
      },
      {
        "periode": "3 Bulan",
        "vaksin": [
          {
            "vaksin_id": "3",
            "nama_vaksin": "Hepatitis B 3",
            "bulan_ke": "3",
            "is_active": "1",
            "created_by": "1",
            "created_date": "2023-06-24 20:00:28",
            "updated_by": null,
            "updated_date": null,
            "anak_id": null,
            "status": "Belum"
          },
          {
            "vaksin_id": "6",
            "nama_vaksin": "Polio 1",
            "bulan_ke": "3",
            "is_active": "1",
            "created_by": "1",
            "created_date": "2023-06-24 20:03:08",
            "updated_by": null,
            "updated_date": null,
            "anak_id": null,
            "status": "Belum"
          },
          {
            "vaksin_id": "11",
            "nama_vaksin": "DTP 2",
            "bulan_ke": "3",
            "is_active": "1",
            "created_by": "1",
            "created_date": "2023-06-24 20:04:09",
            "updated_by": null,
            "updated_date": null,
            "anak_id": null,
            "status": "Belum"
          },
          {
            "vaksin_id": "14",
            "nama_vaksin": "Hib 3",
            "bulan_ke": "3",
            "is_active": "1",
            "created_by": "1",
            "created_date": "2023-06-24 20:04:53",
            "updated_by": null,
            "updated_date": null,
            "anak_id": null,
            "status": "Belum"
          }
        ]
      },
      {
        "periode": "4 Bulan",
        "vaksin": [
          {
            "vaksin_id": "4",
            "nama_vaksin": "Hepatitis B 4",
            "bulan_ke": "4",
            "is_active": "1",
            "created_by": "1",
            "created_date": "2023-06-24 20:02:22",
            "updated_by": null,
            "updated_date": null,
            "anak_id": null,
            "status": "Belum"
          },
          {
            "vaksin_id": "7",
            "nama_vaksin": "Polio 1",
            "bulan_ke": "4",
            "is_active": "1",
            "created_by": "1",
            "created_date": "2023-06-24 20:03:09",
            "updated_by": null,
            "updated_date": null,
            "anak_id": null,
            "status": "Belum"
          },
          {
            "vaksin_id": "16",
            "nama_vaksin": "PCV 2",
            "bulan_ke": "4",
            "is_active": "1",
            "created_by": "1",
            "created_date": "2023-06-24 20:05:11",
            "updated_by": null,
            "updated_date": null,
            "anak_id": null,
            "status": "Belum"
          },
          {
            "vaksin_id": "19",
            "nama_vaksin": "Rotavirus 2",
            "bulan_ke": "4",
            "is_active": "1",
            "created_by": "1",
            "created_date": "2023-06-24 20:06:39",
            "updated_by": null,
            "updated_date": null,
            "anak_id": null,
            "status": "Belum"
          }
        ]
      },
      {
        "periode": "6 Bulan",
        "vaksin": [
          {
            "vaksin_id": "17",
            "nama_vaksin": "PCV 3",
            "bulan_ke": "6",
            "is_active": "1",
            "created_by": "1",
            "created_date": "2023-06-24 20:06:14",
            "updated_by": null,
            "updated_date": null,
            "anak_id": null,
            "status": "Belum"
          },
          {
            "vaksin_id": "20",
            "nama_vaksin": "Rotavirus 3",
            "bulan_ke": "6",
            "is_active": "1",
            "created_by": "1",
            "created_date": "2023-06-24 20:06:43",
            "updated_by": null,
            "updated_date": null,
            "anak_id": null,
            "status": "Belum"
          }
        ]
      },
      {
        "periode": "9 Bulan",
        "vaksin": [
          {
            "vaksin_id": "21",
            "nama_vaksin": "MR / MMR",
            "bulan_ke": "9",
            "is_active": "1",
            "created_by": "1",
            "created_date": "2023-06-24 20:07:48",
            "updated_by": null,
            "updated_date": null,
            "anak_id": null,
            "status": "Belum"
          }
        ]
      },
      {
        "periode": "12 Bulan",
        "vaksin": [
          {
            "vaksin_id": "23",
            "nama_vaksin": "Varisela 1",
            "bulan_ke": "12",
            "is_active": "1",
            "created_by": "1",
            "created_date": "2023-06-24 20:09:18",
            "updated_by": null,
            "updated_date": null,
            "anak_id": null,
            "status": "Belum"
          },
          {
            "vaksin_id": "25",
            "nama_vaksin": "Hepatitis A 1",
            "bulan_ke": "12",
            "is_active": "1",
            "created_by": "1",
            "created_date": "2023-06-24 20:09:29",
            "updated_by": null,
            "updated_date": null,
            "anak_id": null,
            "status": "Belum"
          }
        ]
      },
      {
        "periode": "18 Bulan",
        "vaksin": [
          {
            "vaksin_id": "24",
            "nama_vaksin": "Varisela 2",
            "bulan_ke": "18",
            "is_active": "1",
            "created_by": "1",
            "created_date": "2023-06-24 20:09:19",
            "updated_by": null,
            "updated_date": null,
            "anak_id": null,
            "status": "Belum"
          },
          {
            "vaksin_id": "26",
            "nama_vaksin": "Hepatitis A 2",
            "bulan_ke": "18",
            "is_active": "1",
            "created_by": "1",
            "created_date": "2023-06-24 20:09:30",
            "updated_by": null,
            "updated_date": null,
            "anak_id": null,
            "status": "Belum"
          }
        ]
      },
      {
        "periode": "24 Bulan",
        "vaksin": [
          {
            "vaksin_id": "22",
            "nama_vaksin": "Tifoid",
            "bulan_ke": "24",
            "is_active": "1",
            "created_by": "1",
            "created_date": "2023-06-24 20:08:38",
            "updated_by": null,
            "updated_date": null,
            "anak_id": null,
            "status": "Belum"
          }
        ]
      }
    ];

    List<Map<String, dynamic>> filteredData = vaccinationData
        .where((vaccination) =>
            vaccination['vaksin'][0]['bulan_ke'] == selectedMonth.toString())
        .toList();

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Jadwal Vaksinasi'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Container(
              width: width,
              height: height * 0.1,
              child: Row(
                children: [
                  Container(
                      alignment: Alignment.centerLeft,
                      width: width * 0.4,
                      height: height * 0.1,
                      child: Text(
                        "Jenis Tampilan",
                        style: TextStyle(fontSize: 20),
                      )),
                  Container(
                      width: width * 0.5,
                      height: height * 0.1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.table_chart_outlined),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                selected = 0;
                                selectedMonth = 0;
                              });
                            },
                            icon: Icon(Icons.filter_alt_outlined),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ),
          Container(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: vaccinationData.length,
              itemBuilder: (BuildContext context, int index) {
                Map<String, dynamic> item = vaccinationData[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        String text = item['periode'];
                        RegExp regex = RegExp(r'\d+');
                        RegExpMatch? match = regex.firstMatch(text);
                        if (match != null) {
                          String? valueString = match.group(0);
                          int? value = int.tryParse(valueString!);
                          if (value != null) {
                            selectedMonth = value;
                            selected = index + 1;
                          }
                        }
                      });
                    },
                    child: Chip(
                      side: BorderSide.none,
                      label: Text(
                        item['periode'],
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: selected == index + 1
                          ? Colors.blue[200]
                          : Colors.grey,
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: selectedMonth == 0
                  ? vaccinationData.length
                  : filteredData.length,
              itemBuilder: (BuildContext context, int index) {
                Map<String, dynamic> item = selectedMonth == 0
                    ? vaccinationData[index]
                    : filteredData[index];
                return ExpansionTile(
                  title: Text(
                    item['periode'],
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 2, right: 16, left: 16),
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        color: Colors.blue,
                        radius: Radius.circular(20),
                        padding: EdgeInsets.all(3),
                        child: Container(
                          width: width * 0.9,
                          height: height * 0.07,
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 18),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Dirokemendasikan di ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                '05 Jun 2023 ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Container(
                        width: width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: item['vaksin'].length,
                          itemBuilder: (BuildContext context, int subIndex) {
                            Map<String, dynamic> subItem =
                                item['vaksin'][subIndex];
                            return ListTile(
                                title: Text(
                                  subItem['nama_vaksin'],
                                  style: TextStyle(color: Colors.black54),
                                ),
                                trailing: Container(
                                  width: width * 0.5,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Chip(
                                        side: BorderSide.none,
                                        label: Text(
                                          subItem['status'],
                                          style: TextStyle(
                                              fontSize: 12, color: Colors.red),
                                        ),
                                        backgroundColor: Colors.red[100],
                                      ),
                                      IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.arrow_forward_ios,
                                            size: 15,
                                          ))
                                    ],
                                  ),
                                ));
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
