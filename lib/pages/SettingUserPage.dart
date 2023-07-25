import 'package:flutter/material.dart';
import 'package:stantapp/controller/AuthController.dart';
import 'package:stantapp/controller/ParameterController.dart';
import 'package:stantapp/pages/TetangAplikasiPage.dart';
import 'package:get/get.dart';

class SettingUserPage extends StatefulWidget {
  const SettingUserPage({super.key});

  @override
  State<SettingUserPage> createState() => _SettingUserPageState();
}

class _SettingUserPageState extends State<SettingUserPage> {
  var parameterController = Get.put(ParameterController());
  var authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var hight = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          // leading: IconButton(
          //   icon: Icon(Icons.arrow_back),
          //   onPressed: () {},
          // ),
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Container(
                alignment: Alignment.bottomLeft,
                width: width,
                height: hight,
                child: Text(
                  'v3.0.24.2305192',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            Container(
              width: width,
              height: hight,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        radius: 41,
                        backgroundImage: NetworkImage(
                            'https://cdn.vectorstock.com/i/1000x1000/70/84/default-avatar-profile-icon-symbol-for-website-vector-46547084.webp'),
                        backgroundColor: Colors.white,
                      ),
                      title: Text(
                        'MOH.NURUDDIN',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '085649930202',
                        style: TextStyle(color: Colors.grey),
                      ),
                      trailing: TextButton(
                        onPressed: () {},
                        child: Text(
                          'Ubah',
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                      child: Container(
                        alignment: Alignment.center,
                        width: width,
                        height: hight * 0.15,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Colors.blueAccent,
                              Color.fromARGB(204, 115, 164, 250),
                            ],
                          ),
                        ),
                        child: ListTile(
                          trailing: Container(
                            width: width * 0.15,
                            height: hight * 0.12,
                            child: Image(
                              image: NetworkImage(
                                  "https://cdn-icons-png.flaticon.com/512/4213/4213958.png"),
                            ),
                          ),
                          title: Text(
                            'Mau dapat voucher Konsultasi senilai Rp.10.000? Ajak teman untuk unduh PrimaKu!!',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Card(
                        child: Container(
                          width: width,
                          color: Colors.white,
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Profile',
                                  style: TextStyle(fontSize: 18),
                                ),
                                IconButton(
                                  icon: Icon(Icons.arrow_forward_ios),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: hight * 0.07,
                    ),
                    Card(
                      child: Container(
                          width: width,
                          color: Colors.white,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Syarat dan Ketentuan',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.arrow_forward_ios),
                                      onPressed: () {},
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    parameterController.getParameter("1");
                                    Get.to(TentangAplikasiPage());
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Tetang Aplikasi',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.arrow_forward_ios),
                                        onPressed: () {},
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Bantuan',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.arrow_forward_ios),
                                      onPressed: () {},
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )),
                    ),
                    SizedBox(
                      height: hight * 0.1,
                    ),
                    Card(
                      child: Container(
                        width: width,
                        color: Colors.white,
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Pengaturan akun',
                                style: TextStyle(fontSize: 18),
                              ),
                              IconButton(
                                icon: Icon(Icons.arrow_forward_ios),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            var height = MediaQuery.of(context).size.height;
                            return Center(
                              child: AlertDialog(
                                title: Text('Apakah anda yakin ingin keluar?',
                                    style: TextStyle(fontSize: 20)),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      authController.logout();
                                    },
                                    child: Text('Keluar'),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Card(
                        child: Container(
                          width: width,
                          color: Colors.white,
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Logout',
                                  style: TextStyle(fontSize: 18),
                                ),
                                IconButton(
                                  icon: Icon(Icons.logout),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
