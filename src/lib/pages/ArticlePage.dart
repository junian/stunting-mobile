import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:growthtracker/models/MGetArticle.dart';
import 'package:growthtracker/models/MGetArticleCategory.dart';
import '../controller/ArticleController.dart';
import 'ArticleDetailPage.dart';

class ArticlePage extends StatefulWidget {
  ArticlePage({super.key});

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  String selectedCategory = "Semua";
  TextEditingController searchController = TextEditingController();
  var artikelController = Get.put(ArticleController());

  List<MGetArticle> filteredList = [];
  List<MGetArticleCategory> categories = [];
  bool isDataInitialized = false;

  Future<void> initializeData() async {
    await Future.delayed(Duration(seconds: 3)); // Wait for 2 seconds
    // await artikelController.getArtikel();
    await artikelController.getArtikelKategori();
    filteredList = artikelController.artikel.toList();
    categories = artikelController.kategori.toList();
    setState(() {
      isDataInitialized =
          true; // Set the data initialization status to true
    });
  }

  @override
  void initState() {
    initializeData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void filterList() {
      String keyword = searchController.text.toLowerCase();

      setState(() {
        filteredList = artikelController.artikel.where((artikel) {
          bool isCategoryMatched = selectedCategory == "Semua" ||
              artikel.namaKategori == selectedCategory;
          bool isKeywordMatched = artikel.judul.toLowerCase().contains(keyword);
          return isCategoryMatched && isKeywordMatched;
        }).toList();
      });
    }

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          Container(
            alignment: Alignment.center,
            width: width * 0.8,
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
                    hintText: "search_articles".tr),
              ),
            ),
          ),
          SizedBox(width: width * 0.1,)
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Card(
              child: GestureDetector(
                onTap: () {},
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
                        Text("articles".tr)
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
                  String category = categories[index].namaKategori;
                  bool isSelected = selectedCategory == category;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory = category;
                        filterList();
                      });
                    },
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 8.0),
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 8.0),
                          decoration: BoxDecoration(
                            color:
                                isSelected ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.blue.shade400
                                  : Colors.grey,
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
                                color:
                                    isSelected ? Colors.blue[400] : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(
            height: height * 0.02,
          ),
          isDataInitialized
              ? Expanded(
                  child: ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      MGetArticle artikel = filteredList[index];
                      DateFormat dateFormat = DateFormat('d MMM y');
                      String tglbuat = dateFormat
                          .format(DateTime.parse(artikel.createdDate));

                      if (filteredList.isEmpty) {
                        return Text("failed".tr);
                      }
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
                                    Get.to(
                                      ArticleDetailPage(
                                        category: artikel.namaKategori,
                                        title: artikel.judul,
                                        author: artikel.fullname,
                                        date: tglbuat,
                                        description: artikel.konten,
                                        imageUrl:
                                            "https://mystantapp.siuinsa.com" +
                                                artikel.thumbnail.toString(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadiusDirectional.circular(10),
                                      image: artikel.thumbnail != null
                                          ? DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                "https://mystantapp.siuinsa.com" +
                                                    artikel.thumbnail
                                                        .toString(),
                                              ),
                                            )
                                          : DecorationImage(
                                              image:
                                                  AssetImage('images/logo.png'),
                                              fit: BoxFit.contain),
                                    ),
                                    height: 100,
                                    width: 100,
                                  ),
                                ),
                                title: GestureDetector(
                                  onTap: () {
                                    Get.to(
                                      ArticleDetailPage(
                                        category: artikel.namaKategori,
                                        title: artikel.judul,
                                        author: artikel.fullname,
                                        date: tglbuat,
                                        description: artikel.konten,
                                        imageUrl:
                                            "https://mystantapp.siuinsa.com" +
                                                artikel.thumbnail.toString(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    artikel.judul,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                subtitle: Text("author_by".trParams(
                                    {"author": artikel.fullname})),
                                onTap: () {
                                  // Add the action for when an article is clicked here
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
                                      width: width * 0.70,
                                      child: Row(
                                        children: [
                                          Text(
                                            tglbuat,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey),
                                          ),
                                          SizedBox(
                                            width: width * 0.02,
                                          ),
                                          // Icon(
                                          //   Icons.remove_red_eye_outlined,
                                          //   color: Colors.grey,
                                          // ),
                                          // SizedBox(
                                          //   width: width * 0.015,
                                          // ),
                                          // Text(
                                          //     "Dilihat"
                                          //     // ${artikel.views
                                          //     //   }
                                          //     ,
                                          //     style: TextStyle(
                                          //         fontSize: 12,
                                          //         color: Colors.grey)),
                                          // SizedBox(
                                          //   width: width * 0.015,
                                          // ),
                                          // IconButton(
                                          //     onPressed: () {},
                                          //     icon: Icon(
                                          //       Icons.favorite_border_outlined,
                                          //       color: Colors.grey,
                                          //     )),
                                          // Text("",
                                          //     // artikel.likes.toString(),
                                          //     style: TextStyle(
                                          //         fontSize: 12,
                                          //         color: Colors.grey)),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: height * 0.07,
                                      width: width * 0.25,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          // IconButton(
                                          //     onPressed: () {},
                                          //     icon: Icon(
                                          //         Icons.bookmark_add_outlined),)
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
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
        ],
      ),
    );
  }
}
