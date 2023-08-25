import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stantapp/controller/NotificationController.dart';

enum NotificationType {
  InfoImmunizationSchedule,
  WarningImmunizationSchedule,
  InfoGrowthUpdate,
  WarningGrowthUpdate,
}

class Child {
  final String name;
  final int age;

  Child({required this.name, required this.age});
}

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  var notificationController = Get.put(NotificationController());

  bool isDataInitialized = false;

  List<Child> children = [
    Child(name: 'Anak 1', age: 24), // Contoh data anak 1
    Child(name: 'Anak 2', age: 36), // Contoh data anak 2
    // Tambahkan data anak lainnya di sini
  ];

  List<NotificationItem> notifications = [];

  List<dynamic> isNotification = [];

  Future<void> initializeData() async {
    await Future.delayed(Duration(seconds: 2)); // Menunggu selama 2 detik
    isNotification = jsonDecode(notificationController.notification.toString());

    setState(() {
      isDataInitialized =
          true; // Mengubah status inisialisasi data menjadi true
    });
  }

  @override
  void initState() {
    super.initState();
    initializeData();
    generateNotifications();
  }

  void generateNotifications() {
    DateTime now = DateTime.now();

    // 1. Info Jadwal Imunisasi
    children.forEach((child) {
      String notification =
          'Silahkan melakukan imunisasi ${child.name} berdasarkan jadwal IDAI';
      DateTime nextImmunizationDate = calculateNextImmunizationDate(child.age);
      String formattedDate = formatDate(nextImmunizationDate);
      notification += '\nTanggal ${formattedDate}';
      NotificationItem item = NotificationItem(
        type: NotificationType.InfoImmunizationSchedule,
        message: notification,
      );
      notifications.add(item);
    });

    // 2. Warning Jika belum melakukan imunisasi
    children.forEach((child) {
      DateTime nextImmunizationDate = calculateNextImmunizationDate(child.age);
      if (now.isAfter(nextImmunizationDate)) {
        String notification = 'Silahkan melakukan imunisasi ${child.name}';
        NotificationItem item = NotificationItem(
          type: NotificationType.WarningImmunizationSchedule,
          message: notification,
        );
        notifications.add(item);
      }
    });

    // 3. Info setelah update pertumbuhan anak (NORMAL)
    children.forEach((child) {
      String notification =
          'Hasil Pertumbuhan Anak ${child.name} Umur ${child.age} Sesuai Standar Pertumbuhan Normal';
      NotificationItem item = NotificationItem(
        type: NotificationType.InfoGrowthUpdate,
        message: notification,
      );
      notifications.add(item);
    });

    // 4. Warning setelah update pertumbuhan anak (TIDAK NORMAL)
    children.forEach((child) {
      String notification =
          'Hasil Pertumbuhan Anak ${child.name} Umur ${child.age} Tidak Sesuai Standar Pertumbuhan Normal. Silahkan melakukan konsultasi.';
      NotificationItem item = NotificationItem(
        type: NotificationType.WarningGrowthUpdate,
        message: notification,
      );
      notifications.add(item);
    });

    setState(() {});
  }

  DateTime calculateNextImmunizationDate(int age) {
    // Logika perhitungan tanggal jadwal imunisasi berdasarkan umur anak
    // Implementasikan sesuai jadwal IDAI atau standar yang berlaku
    // Contoh sederhana:
    DateTime now = DateTime.now();
    DateTime birthDate = now.subtract(Duration(days: age * 30));
    DateTime nextImmunizationDate = birthDate.add(Duration(days: 30));
    return nextImmunizationDate;
  }

  String formatDate(DateTime date) {
    String formattedDate =
        '${date.day.toString().padLeft(2, '0')} ${getMonthName(date.month)} ${date.year}';
    return formattedDate;
  }

  String getMonthName(int month) {
    // Mengembalikan nama bulan berdasarkan angka bulan
    // Anda dapat mengubah logika ini sesuai dengan preferensi Anda
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'Mei';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Agu';
      case 9:
        return 'Sep';
      case 10:
        return 'Okt';
      case 11:
        return 'Nov';
      case 12:
        return 'Des';
      default:
        return '';
    }
  }

  IconData getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.InfoImmunizationSchedule:
      case NotificationType.InfoGrowthUpdate:
        return Icons.info;
      case NotificationType.WarningImmunizationSchedule:
      case NotificationType.WarningGrowthUpdate:
        return Icons.warning;
      default:
        return Icons.notifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    print(isDataInitialized);
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifikasi'),
      ),
      body: isDataInitialized == true ? ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          NotificationItem notification = notifications[index];
          return ListTile(
            title: Text(notification.message),
            leading: Icon(
              getNotificationIcon(notification.type),
            ),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              // Tindakan ketika notifikasi diklik
              print('Notifikasi ${index + 1} diklik');
            },
          );
        },
      ) : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class NotificationItem {
  final NotificationType type;
  final String message;

  NotificationItem({required this.type, required this.message});
}
