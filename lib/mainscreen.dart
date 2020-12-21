import 'dart:convert';
import 'detailscreen.dart';
import 'books.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List booksList;
  double screenHeight, screenWidth;
  String titlecenter = "Loading Books...";

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
        //title: 'Material App',
        theme: new ThemeData(primarySwatch: Colors.cyan),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: Text('List of Books'),
          ),
          body: Column(
            children: [
              booksList == null
                  ? Flexible(
                      child: Container(
                          child: Center(
                              child: Text(
                      titlecenter,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ))))
                  : Flexible(
                      child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: (screenWidth / screenHeight) / 1.0,
                      children: List.generate(booksList.length, (index) {
                        return Padding(
                          padding: EdgeInsets.all(1),
                          child: Card(
                             child: InkWell(
                                onTap: () => _loadBooksDetail(index),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Stack(
                              children: [
                                Container(
                                    height: screenHeight / 3.0,
                                    width: screenWidth / 1.0,
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          "http://slumberjer.com/bookdepo/bookcover/${booksList[index]['cover']}.jpg",
                                      fit: BoxFit.fill,
                                      placeholder: (context, url) =>
                                          new CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          new Icon(
                                        Icons.broken_image,
                                        size: screenWidth / 2,
                                      ),
                                    )),
                                    Positioned(
                                            child: Container(
                                                margin: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                      color: Colors.white,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10))),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                        booksList[index]
                                                            ['rating'],
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black)),
                                                    Icon(Icons.star,
                                                        color: Colors.black),
                                                  ],
                                                )),
                                            bottom: 10,
                                            right: 10,
                                          )
                                        ],
                                      ),
                                SizedBox(height: 5),
                                Text(
                                  booksList[index]['booktitle'],
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text('Author:' + booksList[index]['author']),
                                Text('RM ' + booksList[index]['price']),
                                //Text(booksList[index]['rating']),
                              ],
                            ),
                          ),
                      )));
                      }),
                    ))
            ],
          ),
        ));
  }

  void _loadBooks() {
    http.post("http://slumberjer.com/bookdepo/php/load_books.php",
        body: {}).then((res) {
      print(res.body);
      if (res.body == "no data") {
        booksList = null;
        setState(() {
          titlecenter = "No Book Found";
        });
      } else {
        setState(() {
          var jsondata = json.decode(res.body);
          booksList = jsondata["books"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }
  _loadBooksDetail(int index) {
    print(booksList[index]['booktitle']);
    Books books = new Books(
        bookid: booksList[index]['bookid'],
        booktitle: booksList[index]['booktitle'],
        author: booksList[index]['author'],
        price: booksList[index]['price'],
        description: booksList[index]['description'],
        rating: booksList[index]['rating'],
        publisher: booksList[index]['publisher'],
        isbn: booksList[index]['isbn'],
        cover: booksList[index]['cover']);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => DetailScreen(
                  book: books,
                )));
  }
}
