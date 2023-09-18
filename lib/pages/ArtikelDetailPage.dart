import 'package:flutter/material.dart';
import 'package:html/parser.dart' as html;

class ArtikelDetailPage extends StatefulWidget {
  String category;
  String title;
  String author;
  String date;
  // int views;
  // int likes;
  String description;
  String imageUrl;

  ArtikelDetailPage({
    super.key,
    required this.category,
    required this.title,
    required this.author,
    required this.date,
    // required this.views,
    // required this.likes,
    required this.description,
    required this.imageUrl,
  });

  @override
  State<ArtikelDetailPage> createState() => _ArtikelDetailPageState();
}

class _ArtikelDetailPageState extends State<ArtikelDetailPage> {
  late String cleanedDescription;

  String cleanHtml(String htmlString) {
    // Menguraikan teks HTML
    final document = html.parse(htmlString);

    // Mengambil teks dari elemen
    final plainText = document.body?.text;

    return plainText ??
        ''; // Mengembalikan teks biasa, jika ada, atau string kosong jika tidak ada teks
  }

  @override
  void initState() {
    super.initState();
    cleanedDescription = cleanHtml(widget.description);
  }

  @override
  Widget build(BuildContext context) {
    print("ini title: ${widget.description}");
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Artikel',
          style: TextStyle(fontSize: 20),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      // floatingActionButton: Container(
      //     width: width * 0.5,
      //     height: height * 0.07,
      //     decoration: BoxDecoration(
      //       borderRadius: BorderRadius.circular(30),
      //       shape: BoxShape.rectangle,
      //       color: Colors.white,
      //       boxShadow: [
      //         BoxShadow(
      //           color: Colors.grey.withOpacity(0.5),
      //           spreadRadius: 2,
      //           blurRadius: 5,
      //           offset: Offset(0, 3),
      //         ),
      //       ],
      //     ),
      //     child: Row(
      //       children: [
      //         IconButton(
      //           onPressed: () {},
      //           icon: Icon(
      //             Icons.favorite_border_outlined,
      //             color: Colors.grey,
      //             size: 30,
      //           ),
      //         ),
      //         // Text(likes.toString()),
      //         SizedBox(
      //           width: width * 0.05,
      //         ),
      //         Container(
      //           color: Colors.grey,
      //           width: width * 0.006,
      //           height: height * 0.035,
      //         ),
      //         IconButton(
      //           onPressed: () {},
      //           icon: Icon(
      //             Icons.bookmark_add_outlined,
      //             color: Colors.grey,
      //             size: 30,
      //           ),
      //         ),
      //         IconButton(
      //           onPressed: () {},
      //           icon: Icon(
      //             Icons.share_outlined,
      //             color: Colors.grey,
      //             size: 30,
      //           ),
      //         ),
      //       ],
      //     )),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Container(
              width: width,
              height: height * 0.3,
              decoration: BoxDecoration(
                  image: widget.imageUrl != 'null'
                      ? DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(widget.imageUrl),
                        )
                      : DecorationImage(
                          fit: BoxFit.contain,
                          image: AssetImage('images/logo.png'),
                        ),
                  borderRadius: BorderRadius.circular(20)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15, left: 15),
            child: Container(
              alignment: Alignment.topLeft,
              width: width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.date,
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(widget.title,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text("Ditulis Oleh ${widget.author}",
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15, left: 15, top: 15),
            child: Container(
              child: Text(
                cleanedDescription,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
