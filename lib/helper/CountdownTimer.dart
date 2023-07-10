import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stantapp/controller/AuthController.dart';

class CountdownTimer extends StatefulWidget {
  String email;
  String phone_no;
  CountdownTimer({
    super.key,
    required this.email,
    required this.phone_no,
  });

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  var authController = Get.put(AuthController());

  int countdown = 10 * 60; // Jumlah detik dalam 10 menit
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (countdown > 0) {
          countdown--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  String formatTime(int timeInSeconds) {
    int minutes = (timeInSeconds / 60).floor();
    int seconds = timeInSeconds % 60;

    String formattedMinutes = minutes.toString().padLeft(2, '0');
    String formattedSeconds = seconds.toString().padLeft(2, '0');

    return '$formattedMinutes:$formattedSeconds';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (countdown == 0) {
          // Tindakan yang dijalankan ketika teks "Kirim Ulang Kode" ditekan
          authController.reqAuthCode(widget.email, widget.phone_no);
          // Misalnya, mengirim ulang kode verifikasi
          startTimer(); // Memulai timer kembali setelah dikirim ulang
        }
      },
      child: Text(
        countdown > 0 ? formatTime(countdown) : 'Kirim Ulang Kode',
        style: TextStyle(
          color: countdown > 0 ? Colors.black : Colors.blue,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
