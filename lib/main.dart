import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';
import 'list_of_country.dart';


void main() => runApp(const MyApp());

GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

void toggleDrawer() {
  if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
    _scaffoldKey.currentState?.openEndDrawer();
  } else {
    _scaffoldKey.currentState?.openDrawer();
  }
}

class DropDownList extends StatelessWidget {
  const DropDownList({Key? key, required this.name, required this.call})
      : super(key: key);
  final String name;
  final Function call;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: ListTile(title: Text(name)),
      onTap: () => call(),
    );
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

// ignore: unused_element
class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  dynamic cName;
  dynamic country;
  dynamic category;
  dynamic findNews;
  int pageNum = 1;
  bool isPageLoading = false;
  late ScrollController controller;
  int pageSize = 10;
  bool isSwitched = false;
  List<dynamic> news = [];
  bool notFound = false;
  List<int> data = [];
  bool isLoading = false;
  String baseApi = 'https://newsapi.org/v2/top-headlines?';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'News',
      theme: isSwitched
          ? ThemeData(
              fontFamily: GoogleFonts.poppins().fontFamily,
              brightness: Brightness.light,
            )
          : ThemeData(
              fontFamily: GoogleFonts.poppins().fontFamily,
              brightness: Brightness.dark,
            ),
      home: Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 32),
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (country != null)
                    Text('Country = $cName')
                  else
                    Container(),
                  const SizedBox(height: 10),
                  if (category != null)
                    Text('Category = $category')
                  else
                    Container(),
                  const SizedBox(height: 20),
                ],
              ),
             

              ListTile(
                title: TextFormField(
                  decoration: const InputDecoration(hintText: 'Find Keyword'),
                  scrollPadding: const EdgeInsets.all(5),
                  onChanged: (String val) => setState(() => findNews = val),
                ),
                trailing: IconButton(
                  onPressed: () async => getNews(searchKey: findNews as String),
                  icon: const Icon(Icons.search),
                ),
              ),
              ExpansionTile(
                title: const Text('Country'),
                children: <Widget>[
                  for (int i = 0; i < listOfCountry.length; i++)
                    DropDownList(
                      call: () {
                        country = listOfCountry[i]['code'];
                        cName = listOfCountry[i]['name']!.toUpperCase();
                        getNews();
                      },
                      name: listOfCountry[i]['name']!.toUpperCase(),
                    ),
                ],
              ),
              ExpansionTile(
                title: const Text('Category'),
                children: [
                  for (int i = 0; i < listOfCategory.length; i++)
                    DropDownList(
                      call: () {
                        category = listOfCategory[i]['code'];
                        getNews();
                      },
                      name: listOfCategory[i]['name']!.toUpperCase(),
                    )
                ],
              ),
              ExpansionTile(
                title: const Text('Channel'),
                children: [
                  for (int i = 0; i < listOfNewsChannel.length; i++)
                    DropDownList(
                      call: () =>
                          getNews(channel: listOfNewsChannel[i]['code']),
                      name: listOfNewsChannel[i]['name']!.toUpperCase(),
                    ),
                ],
              ),
            ],
          ),
        ),
        appBar: AppBar(
          centerTitle: true,
          title: const Text('News'),
          actions: [
            IconButton(
              onPressed: () {
                country = null;
                category = null;
                findNews = null;
                cName = null;
                getNews(reload: true);
              },
              icon: const Icon(Icons.refresh),
            ),
            Switch(
              value: isSwitched,
              onChanged: (bool value) => setState(() => isSwitched = value),
              activeTrackColor: Colors.white,
              activeColor: Colors.white,
            ),
            // Bookmark Button in App Bar
            Builder(
              // Use Builder to get the correct context
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(Icons.bookmark),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const BookmarkPage()),
                    );
                  },
                );
              },
            ),
          ],
        ),
        body: notFound
            ? const Center(
                child: Text('Not Found', style: TextStyle(fontSize: 30)),
              )
            : news.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.yellow,
                    ),
                  )
                : ListView.builder(
                    controller: controller,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 15,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Column(
                                  children: [
                                    Stack(
                                      children: [
                                        if (news[index]['urlToImage'] == null)
                                          Container()
                                        else
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: CachedNetworkImage(
                                              placeholder:
                                                  (BuildContext context,
                                                          String url) =>
                                                      Container(),
                                              errorWidget:
                                                  (BuildContext context,
                                                          String url, error) =>
                                                      const SizedBox(),
                                              imageUrl: news[index]
                                                  ['urlToImage'] as String,
                                            ),
                                          ),
                                        Positioned(
                                          bottom: 8,
                                          right: 8,
                                          child: Card(
                                            elevation: 0,
                                            color: Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.8),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 8,
                                              ),
                                              child: Text(
                                                "${news[index]['source']['name']}",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(),
                                    Text(
                                      "${news[index]['title']}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    // Save Button
                                    IconButton(
                                      icon: const Icon(Icons.bookmark),
                                      onPressed: () {
                                        saveNews(news[index]['url'], context);
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          if (index == news.length - 1 && isLoading)
                            const Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.yellow,
                              ),
                            )
                          else
                            const SizedBox(),
                        ],
                      );
                    },
                    itemCount: news.length,
                  ),
      ),
    );
  }

  Future<void> getDataFromApi(String url) async {
    final http.Response res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      if (jsonDecode(res.body)['totalResults'] == 0) {
        notFound = !isLoading;
        setState(() => isLoading = false);
      } else {
        if (isLoading) {
          final newData = jsonDecode(res.body)['articles'] as List<dynamic>;
          for (final e in newData) {
            news.add(e);
          }
        } else {
          news = jsonDecode(res.body)['articles'] as List<dynamic>;
        }
        setState(() {
          notFound = false;
          isLoading = false;
        });
      }
    } else {
      setState(() => notFound = true);
    }
  }

  Future<void> getNews({
    String? channel,
    String? searchKey,
    bool reload = false,
  }) async {
    setState(() => notFound = false);

    if (!reload && !isLoading) {
      toggleDrawer();
    } else {
      country = null;
      category = null;
    }
    if (isLoading) {
      pageNum++;
    } else {
      setState(() => news = []);
      pageNum = 1;
    }
    baseApi = 'https://newsapi.org/v2/top-headlines?pageSize=10&page=$pageNum&';

    baseApi += country == null ? 'country=in&' : 'country=$country&';
    baseApi += category == null ? '' : 'category=$category&';
    baseApi += 'apiKey=$apiKey';
    if (channel != null) {
      country = null;
      category = null;
      baseApi =
          'https://newsapi.org/v2/top-headlines?pageSize=10&page=$pageNum&sources=$channel&apiKey=58b98b48d2c74d9c94dd5dc296ccf7b6';
    }
    if (searchKey != null) {
      country = null;
      category = null;
      baseApi =
          'https://newsapi.org/v2/top-headlines?pageSize=10&page=$pageNum&q=$searchKey&apiKey=58b98b48d2c74d9c94dd5dc296ccf7b6';
    }
    //print(baseApi);
    getDataFromApi(baseApi);
  }

  @override
  void initState() {
    controller = ScrollController()..addListener(_scrollListener);
    getNews();
    super.initState();
  }

  void _scrollListener() {
    if (controller.position.pixels == controller.position.maxScrollExtent) {
      setState(() => isLoading = true);
      getNews();
    }
  }

  // Save News Function
  void saveNews(String newsUrl, BuildContext context) {
    BookmarkManager().addBookmark(newsUrl).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('News saved to bookmarks')),
      );
      print('Bookmark added: $newsUrl'); // Debug print
    });
  }
}

// Bookmark Page
class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  _BookmarkPageState createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  List<String> bookmarks = [];

  @override
  void initState() {
    super.initState();
    loadBookmarks();
  }

  Future<void> loadBookmarks() async {
    bookmarks = await BookmarkManager().getBookmarks();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bookmarks')),
      body: bookmarks.isEmpty
          ? const Center(child: Text('No bookmarks'))
          : ListView.builder(
              itemCount: bookmarks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(bookmarks[index]),
                  onTap: () {
                    // Logic to open the bookmarked URL
                  },
                );
              },
            ),
    );
  }
}

class BookmarkManager {
  static const String _bookmarkKey = 'bookmarks';

  Future<void> addBookmark(String newsUrl) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> bookmarks = prefs.getStringList(_bookmarkKey) ?? [];
    if (!bookmarks.contains(newsUrl)) {
      bookmarks.add(newsUrl);
      await prefs.setStringList(_bookmarkKey, bookmarks);
    }
  }

  Future<List<String>> getBookmarks() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_bookmarkKey) ?? [];
  }
}
