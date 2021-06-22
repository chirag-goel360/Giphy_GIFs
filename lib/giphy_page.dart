import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';

// Put your API Key hare
const String apiKey = 'API KEY';
const String urlStart = 'https://api.giphy.com/v1/gifs/search?api_key=';
const String urlEnd = '&limit=25&offset=0&rating=pg&lang=en&q=';

class GiphyPage extends StatefulWidget {
  @override
  _GiphyPageState createState() => _GiphyPageState();
}

class _GiphyPageState extends State<GiphyPage> {
  final url = urlStart + apiKey + urlEnd;
  TextEditingController textEditingController = TextEditingController();
  bool isLoading = false;
  var result;

  @override
  void initState() {
    super.initState();
  }

  fetchData(String text) async {
    isLoading = true;
    setState(() {});
    final response = await http.get(
      Uri.parse(url + text),
    );
    print(response.statusCode);
    result = jsonDecode(response.body)["data"];
    print(result);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Gif Search',
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.teal.shade300,
      ),
      body: Container(
        color: Colors.white70,
        child: Column(
          children: [
            Container(
              height: 70.0,
              decoration: BoxDecoration(
                color: Colors.teal.shade300,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(35.0),
                  bottomRight: Radius.circular(35.0),
                ),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 15.0,
                      vertical: 10.0,
                    ),
                    child: Container(
                      padding: EdgeInsets.only(
                        top: 1.0,
                        left: 5.0,
                        right: 10.0,
                      ),
                      height: 50.0,
                      width: MediaQuery.of(context).size.width - 10,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(40.0),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              autofocus: false,
                              focusNode: FocusNode(
                                canRequestFocus: false,
                              ),
                              showCursor: false,
                              controller: textEditingController,
                              textAlign: TextAlign.justify,
                              decoration: InputDecoration(
                                disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                  ),
                                ),
                                contentPadding: EdgeInsets.all(12.0),
                                prefixIcon: Icon(
                                  Icons.search,
                                  size: 30.0,
                                ),
                                hintText: 'Search',
                                hintStyle: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                fetchData(
                                  textEditingController.text,
                                );
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.purple.shade200,
                              onPrimary: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(40),
                                ),
                              ),
                            ),
                            child: Icon(
                              Icons.gif,
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _getListViewWidget(context),
          ],
        ),
      ),
    );
  }

  Widget _getListViewWidget(BuildContext context) {
    if (result != null)
      return Expanded(
        child: GridView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          primary: false,
          itemCount: result.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
          ),
          padding: EdgeInsets.all(10.0),
          itemBuilder: (context, index) {
            return Column(
              children: [
                Image(
                  height: 150,
                  width: 200,
                  image: NetworkImage(
                    result[index]["images"]["fixed_height"]["url"],
                  ),
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    result[index]["title"],
                    maxLines: 1,
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Share.share(
                        result[index]["images"]["fixed_height"]["webp"],
                      );
                    },
                    child: Text(
                      'Share',
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );
    return Column(
      children: [
        Container(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: 30,
                ),
              ),
              Text(
                'Search GIFs and Share',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                  color: Colors.red.shade300,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 25,
                ),
              ),
              Image.network(
                'https://media.giphy.com/media/COYGe9rZvfiaQ/giphy.gif',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
