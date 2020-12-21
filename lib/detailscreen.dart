import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'mainscreen.dart';
import 'books.dart';
import 'dart:convert';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DetailScreen(),
    );
  }
}

class DetailScreen extends StatefulWidget {
  final Books book;

  const DetailScreen({Key key, this.book}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  double screenHeight, screenWidth;
  List booksList;
  String titlecenter = "Loading Book Detail...";

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.book.booktitle),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
              onPressed: () {},
            )
          ],
        ),
        body: Column(
          children: [
            Container(
                height: screenHeight / 3.0,
                width: screenWidth / 0.3,
                child: CachedNetworkImage(
                  imageUrl:
                      "http://slumberjer.com/bookdepo/bookcover/${widget.book.cover}.jpg",
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      new CircularProgressIndicator(),
                  errorWidget: (context, url, error) => new Icon(
                    Icons.broken_image,
                    size: screenWidth / 2,
                  ),
                )),
            SizedBox(height: 5),
            Column(children: [
              Text("Book ID: 1"),
              Text("Book Title: Where the Crawdads Sing"),
              Text("Author: Delia Owens"),
              Text("Price: RM 72.14"),
              Text(
                  "Description: For years, rumors of the 'Marsh Girl' have haunted Barkley Cove, a quiet town on the North Carolina coast. So in late 1969, when handsome Chase Andrews is found dead, the locals immediately suspect Ky"),
              Text("Rating: 4.46"),
              Text("Publisher: Little, Brown Book Group"),
              Text("ISBN: 1472154665"),
              Text("Cover: 9781472154668"),
            ])
          ],
        ));
  }

  void _loadBooks() {
    http.post("http://slumberjer.com/bookdepo/php/load_books.php", body: {
      "bookid": widget.book.bookid,
    }).then((res) {
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
  }
}
