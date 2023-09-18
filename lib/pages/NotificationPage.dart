import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:stantapp/controller/NotificationController.dart';

class NotifikasiPage extends StatefulWidget {
  const NotifikasiPage({super.key});

  @override
  State<NotifikasiPage> createState() => _NotifikasiPageState();
}

class _NotifikasiPageState extends State<NotifikasiPage> {
  var notificationController = Get.put(NotificationController());
  bool isDataInitialized = false;

  List<dynamic> isNotification = [];

  Future<void> initializeData() async {
    await Future.delayed(Duration(seconds: 3)); // Menunggu selama 2 detik

    setState(() {
      isDataInitialized =
          true; // Mengubah status inisialisasi data menjadi true
    });
  }

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> isNotification =
        notificationController.notification.toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifikasi'),
      ),
      body: isDataInitialized == true
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: isNotification.isNotEmpty ? ListView.builder(
                itemCount:
                    isNotification.length < 10 ? isNotification.length : 10,
                itemBuilder: (context, index) {
                  var notif = isNotification[index];
                  DateFormat dateFormat = DateFormat('d MMM y');
                  String tglbuat =
                      dateFormat.format(DateTime.parse(notif['created_date']));
                  return Card(
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            notif['judul'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            tglbuat,
                            style: TextStyle(color: Colors.grey, fontSize: 15),
                          ),
                        ],
                      ),
                      subtitle: Text(notif['isi']),
                    ),
                  );
                },
              ) : Container(
                child: Center(
                  child: Text(
                    "Belum ada notifikasi",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.grey,
                      fontWeight: FontWeight.w300
                    ),
                  ),
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
