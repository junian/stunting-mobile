import 'package:flutter/material.dart';
import 'ArtikelDetailPage.dart';

class Artikel {
  String category;
  String title;
  String author;
  String date;
  int views;
  int likes;
  String description;
  String imageUrl;

  Artikel({
    required this.category,
    required this.title,
    required this.author,
    required this.date,
    required this.views,
    required this.likes,
    required this.description,
    required this.imageUrl,
  });
}

List<Artikel> artikelList = [
  Artikel(
    category: "Olahraga",
    title: "Manfaat Olahraga Bagi Kesehatan",
    author: "John Doe",
    date: "20 Okt 2023",
    views: 500,
    likes: 100,
    description:
        "Artikel ini membahas berbagai manfaat olahraga bagi kesehatan tubuh, termasuk peningkatan kebugaran, penurunan risiko penyakit jantung, dan peningkatan mood.",
    imageUrl:
        "https://img-cdn.medkomtek.com/P5cMHVk2qKUlv_CTwQo1Z_eAjkw=/730x411/smart/filters:quality(75):strip_icc():format(webp)/article/O-Aq3WlaQkGVu0YUjujeQ/original/1666928242-Manfaat%20Olahraga%20bagi%20Kesehatan%20Mental.jpg",
  ),
  Artikel(
    category: "Kesehatan",
    title: "Tips Meningkatkan Sistem Kekebalan Tubuh",
    author: "Jane Smith",
    date: "15 Nov 2023",
    views: 300,
    likes: 50,
    description:
        "Artikel ini memberikan tips praktis untuk meningkatkan sistem kekebalan tubuh, termasuk pola makan sehat, olahraga teratur, dan tidur yang cukup.",
    imageUrl:
        "https://dk4fkkwa4o9l0.cloudfront.net/production/uploads/article/image/856/peran_Nutrisi.jpeg",
  ),
  Artikel(
    category: "Tips",
    title: "Tips Pentingnya Konsumsi Air Putih",
    author: "Michael Johnson",
    date: "10 Des 2023",
    views: 800,
    likes: 200,
    description:
        "Artikel ini menjelaskan pentingnya konsumsi air putih bagi kesehatan, termasuk menjaga hidrasi, membuang racun dari tubuh, dan menjaga fungsi organ yang optimal.",
    imageUrl:
        "https://res.cloudinary.com/dk0z4ums3/image/upload/v1618195654/attached_image/jangan-remehkan-manfaat-air-putih-0-alodokter.jpg",
  ),
  // Artikel lainnya ...
];

class ArtikelPage extends StatefulWidget {
  ArtikelPage({super.key});

  @override
  State<ArtikelPage> createState() => _ArtikelPageState();
}

class _ArtikelPageState extends State<ArtikelPage> {
  String selectedCategory = "Semua";
  TextEditingController searchController = TextEditingController();

  List<Artikel> filteredList = [];

  @override
  void initState() {
    super.initState();
    filteredList = artikelList;
  }

  void filterList() {
    String keyword = searchController.text.toLowerCase();

    setState(() {
      filteredList = artikelList.where((artikel) {
        bool isCategoryMatched =
            selectedCategory == "Semua" || artikel.category == selectedCategory;
        bool isKeywordMatched = artikel.title.toLowerCase().contains(keyword);
        return isCategoryMatched && isKeywordMatched;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> categories = [
      "Semua",
      "Kesehatan",
      "Olahraga",
      "Tips",
      "Rekomendasi",
    ];

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          Container(
            alignment: Alignment.center,
            width: width * 0.83,
            height: height * 0.1,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey[100]),
            child: Padding(
              padding: const EdgeInsets.only(right: 10, left: 10),
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  filterList();
                },
                decoration: InputDecoration(
                    iconColor: Colors.grey,
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey),
                    icon: Icon(Icons.search),
                    hintText: "Cari Artikel"),
              ),
            ),
          ),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.bookmark_border_outlined,
                size: 30,
              ))
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Card(
              child: Container(
                color: Colors.white,
                width: width,
                height: height * 0.05,
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.library_books,
                        color: Colors.blue,
                      ),
                      SizedBox(
                        width: width * 0.01,
                      ),
                      Text("Artikel")
                    ],
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Container(
                    color: Colors.blue,
                    width: width * 0.3,
                    height: height * 0.005,
                  )
                ]),
              ),
            ),
          ),
          SizedBox(
            height: height * 0.02,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Container(
              height: height * 0.05,
              width: width,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  String category = categories[index];
                  bool isSelected = selectedCategory == category;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory = category;
                        filterList();
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 8.0),
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color:
                              isSelected ? Colors.blue.shade400 : Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          category,
                          style: TextStyle(
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected ? Colors.blue[400] : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(
            height: height * 0.02,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                Artikel artikel = filteredList[index];
                return Card(
                  child: Container(
                    width: width,
                    height: height * 0.18,
                    color: Colors.white,
                    child: Column(
                      children: [
                        ListTile(
                          trailing: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ArtikelDetailPage(
                                          category: artikel.category,
                                          title: artikel.title,
                                          author: artikel.author,
                                          date: artikel.date,
                                          views: artikel.views,
                                          likes: artikel.likes,
                                          description: artikel.description,
                                          imageUrl: artikel.imageUrl)));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadiusDirectional.circular(10),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(artikel.imageUrl)),
                              ),
                              height: 100,
                              width: 100,
                            ),
                          ),
                          title: Text(
                            artikel.title,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text("Penulis : ${artikel.author}"),
                          onTap: () {
                            // Tambahkan aksi ketika artikel diklik di sini
                          },
                        ),
                        Container(
                          height: height * 0.07,
                          width: width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: height * 0.07,
                                width: width * 0.65,
                                child: Row(
                                  children: [
                                    Text(
                                      artikel.date,
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                    SizedBox(
                                      width: width * 0.02,
                                    ),
                                    Icon(
                                      Icons.remove_red_eye_outlined,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(
                                      width: width * 0.015,
                                    ),
                                    Text("Dilihat ${artikel.views}",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.grey)),
                                    SizedBox(
                                      width: width * 0.015,
                                    ),
                                    IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.favorite_border_outlined,
                                          color: Colors.grey,
                                        )),
                                    Text(artikel.likes.toString(),
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.grey)),
                                  ],
                                ),
                              ),
                              Container(
                                height: height * 0.07,
                                width: width * 0.30,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                        onPressed: () {},
                                        icon: Icon(Icons.bookmark_add_outlined))
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
