import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class JadwalImunisaiIDAI extends StatefulWidget {
  final String? path;

  JadwalImunisaiIDAI({Key? key, required this.path}) : super(key: key);

  @override
  _JadwalImunisaiIDAIState createState() => _JadwalImunisaiIDAIState();
}

class _JadwalImunisaiIDAIState extends State<JadwalImunisaiIDAI>
    with WidgetsBindingObserver {
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  int? pages = 0;
  int? currentPage = 0;
  int? previousPage = 0;
  bool isReady = false;
  String errorMessage = '';
  double scrollPosition = 0.0;
  double scrollThreshold = 50.0;

  Future<bool> _onWillPop() async {
    if (previousPage != currentPage) {
      _controller.future.then((controller) {
        if (previousPage! >= 0 && previousPage! < pages!) {
          controller.setPage(previousPage!);
          setState(() {
            currentPage = previousPage;
          });
        }
      });
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Document"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.info_outline),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Center(
                      child: AlertDialog(
                        title: Text('Cara membaca colom umur',
                            style: TextStyle(fontSize: 20)),
                        content: Container(
                          width: width,
                          height: height * 0.25,
                          child: Column(
                            children: [
                              Text(
                                  "Misal 2 berarti 2 bulan (60 Hari) Sampai dengan 2 bulan 29 hari (89 Hari)"),
                              Row(
                                children: [
                                  Icon(
                                    Icons.square,
                                    color: Colors.blue,
                                  ),
                                  Text("Usia si kecil"),
                                ],
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Row(
                                children: [
                                  Icon(Icons.square,
                                      color: Colors.blueAccent[100]),
                                  Text("Primer"),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(Icons.square, color: Colors.white),
                                  Text("Kejar"),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(Icons.square, color: Colors.pink[100]),
                                  Text("Penguat"),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(Icons.square, color: Colors.orange),
                                  Text("Daerah Endemis"),
                                ],
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: Text('Close'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
        body: Stack(
          children: <Widget>[
            NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification is ScrollUpdateNotification) {
                  setState(() {
                    scrollPosition += notification.scrollDelta!;
                  });

                  if (scrollPosition.abs() > scrollThreshold) {
                    int nextPage = currentPage! + (scrollPosition > 0 ? 1 : -1);
                    if (nextPage >= 0 && nextPage < pages!) {
                      setState(() {
                        previousPage = currentPage;
                        currentPage = nextPage;
                      });
                    }
                    setState(() {
                      scrollPosition = 0.0;
                    });
                  }
                }
                return true;
              },
              child: PDFView(
                filePath: widget.path,
                enableSwipe: false,
                swipeHorizontal: true,
                autoSpacing: false,
                pageFling: true,
                pageSnap: true,
                defaultPage: currentPage!,
                fitPolicy: FitPolicy.BOTH,
                preventLinkNavigation: false,
                onRender: (_pages) {
                  setState(() {
                    pages = _pages;
                    isReady = true;
                  });
                },
                onError: (error) {
                  setState(() {
                    errorMessage = error.toString();
                  });
                  print(error.toString());
                },
                onPageError: (page, error) {
                  setState(() {
                    errorMessage = '$page: ${error.toString()}';
                  });
                  print('$page: ${error.toString()}');
                },
                onViewCreated: (PDFViewController pdfViewController) {
                  _controller.complete(pdfViewController);
                },
                onLinkHandler: (String? uri) {
                  print('goto uri: $uri');
                },
                onPageChanged: (int? page, int? total) {
                  print('page change: $page/$total');
                  setState(() {
                    previousPage = currentPage;
                    currentPage = page;
                  });
                },
              ),
            ),
            errorMessage.isEmpty
                ? !isReady
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container()
                : Center(
                    child: Text(errorMessage),
                  )
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        bottomNavigationBar: BottomAppBar(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    if (previousPage! >= 0 && previousPage! < pages!) {
                      _controller.future.then((controller) {
                        int nextPage =
                            previousPage! - 1; // Mengurangi 1 dari previousPage
                        controller.setPage(nextPage);
                        setState(() {
                          currentPage = nextPage;
                          previousPage =
                              nextPage - 1; // Mengurangi 1 dari nextPage
                        });
                      });
                    }
                  },
                ),
                Text(
                  '${currentPage! + 1}/$pages',
                  style: TextStyle(fontSize: 16.0),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: () {
                    int nextPage = currentPage! + 1;
                    if (nextPage >= 0 && nextPage < pages!) {
                      _controller.future.then((controller) {
                        controller.setPage(nextPage);
                        setState(() {
                          currentPage = nextPage;
                        });
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
