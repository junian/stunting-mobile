import 'package:flutter/material.dart';
import 'package:stantapp/controller/ParameterController.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

class TentangAplikasiPage extends StatefulWidget {
  TentangAplikasiPage({super.key});

  @override
  State<TentangAplikasiPage> createState() => _TentangAplikasiPageState();
}

class _TentangAplikasiPageState extends State<TentangAplikasiPage> {
  var parameterController = Get.put(ParameterController());

  bool isDataInitialized = false;
  String isParams = "";

  Future<void> initializeData() async {
    await Future.delayed(Duration(seconds: 2)); // Menunggu selama 2 detik
    await parameterController.getParameter("5");
    isParams = parameterController.parameterValue.toString();

    setState(() {
      isDataInitialized =
          true; // Mengubah status inisialisasi data menjadi true
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeData();
  }

  @override
  Widget build(BuildContext context) {
    final Uri _urlIG = Uri.parse('https://instagram.com/');
    Future<void> _launchUrlIG() async {
      if (!await launchUrl(_urlIG)) {
        throw Exception('Could not launch $_urlIG');
      }
    }

    final Uri _urlFB = Uri.parse('https://www.facebook.com/');
    Future<void> _launchUrlFB() async {
      if (!await launchUrl(_urlFB)) {
        throw Exception('Could not launch $_urlFB');
      }
    }

    final Uri _urlYT = Uri.parse('https://www.youtube.com/watch?v=1Bgbn6F_ON8');
    Future<void> _launchUrlYT() async {
      if (!await launchUrl(_urlYT)) {
        throw Exception('Could not launch $_urlYT');
      }
    }

    final Uri _urlWEB = Uri.parse('www.bebasstunting.com');
    Future<void> _launchUrlWEB() async {
      if (!await launchUrl(_urlWEB)) {
        throw Exception('Could not launch $_urlWEB');
      }
    }

    var width = MediaQuery.of(context).size.width;
    var hight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tentang Aplikasi',
          style: TextStyle(fontSize: 20),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: isDataInitialized == true
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(right: 20, left: 20, bottom: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: hight * 0.05,
                    ),
                    Text(
                      "Tentang Stant App",
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(
                      height: hight * 0.02,
                    ),
                    Container(
                      width: width,
                      child: Text(
                        isParams,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(
                      height: hight * 0.02,
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: width,
                      height: hight * 0.1,
                      child: Text(
                        "Isi dan rekomendasi yang terdapat di dalam STANTAPP dibuat dan disupervisi oleh Ikatan dokter Anak Indonesia (IDAI).",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    // Container(
                    //   alignment: Alignment.bottomLeft,
                    //   width: width,
                    //   height: hight * 0.1,
                    //   child: Text(
                    //     "Temukan STANTAPP di media Sosial!",
                    //     style: TextStyle(fontSize: 18),
                    //   ),
                    // ),
                    // Container(
                    //   alignment: Alignment.centerLeft,
                    //   width: width,
                    //   height: hight * 0.08,
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       Text(
                    //         "Instagram: @bebasstunting",
                    //         style: TextStyle(fontSize: 18),
                    //       ),
                    //       GestureDetector(
                    //         onTap: () {
                    //           _launchUrlIG();
                    //         },
                    //         child: Text(
                    //           "(www.instagram.com/bebasstunting)",
                    //           style: TextStyle(fontSize: 15, color: Colors.blue),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // Container(
                    //   alignment: Alignment.centerLeft,
                    //   width: width,
                    //   height: hight * 0.08,
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       Text(
                    //         "Facebook: STANTAPP",
                    //         style: TextStyle(fontSize: 18),
                    //       ),
                    //       GestureDetector(
                    //         onTap: () {
                    //           _launchUrlFB();
                    //         },
                    //         child: Text(
                    //           "(web.facebook.com/bebasstunting)",
                    //           style: TextStyle(fontSize: 15, color: Colors.blue),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // Container(
                    //   alignment: Alignment.centerLeft,
                    //   width: width,
                    //   height: hight * 0.08,
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       Text(
                    //         "Youtube: Officiak STANTAPP Channel",
                    //         style: TextStyle(fontSize: 18),
                    //       ),
                    //       GestureDetector(
                    //         onTap: () {
                    //           _launchUrlYT();
                    //         },
                    //         child: Text(
                    //           "(www.youtube.com/@bebasstunting)",
                    //           style: TextStyle(fontSize: 15, color: Colors.blue),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // Container(
                    //   alignment: Alignment.centerLeft,
                    //   width: width,
                    //   height: hight * 0.08,
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       Text(
                    //         "website",
                    //         style: TextStyle(fontSize: 18),
                    //       ),
                    //       GestureDetector(
                    //         onTap: () {
                    //           _launchUrlWEB();
                    //         },
                    //         child: Text(
                    //           "(www.bebasstunting.com)",
                    //           style: TextStyle(fontSize: 15, color: Colors.blue),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
