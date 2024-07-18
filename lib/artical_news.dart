// artical_news.dart

// artical_news.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'bookmark_manager.dart';

class ArticleNews extends StatefulWidget {
  const ArticleNews({Key? key, required this.newsUrl}) : super(key: key);
  final String newsUrl;

  @override
  _ArticleNewsState createState() => _ArticleNewsState();
}

class _ArticleNewsState extends State<ArticleNews> {
  final Completer<WebViewController> _completer = Completer<WebViewController>();
  late bool _isLoadingPage;

  @override
  void initState() {
    super.initState();
    _isLoadingPage = true;
  }

  @override
  Widget build(BuildContext context) {
    var JavascriptMode;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('News'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () async {
              await BookmarkManager().addBookmark(widget.newsUrl);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Bookmarked!'),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          WebView(
            initialUrl: widget.newsUrl,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController controller) {
              _completer.complete(controller);
            },
            onPageFinished: (String finish) => setState(() => _isLoadingPage = false),
          ),
          if (_isLoadingPage)
            Container(
              alignment: FractionalOffset.center,
              child: const CircularProgressIndicator(
                backgroundColor: Colors.yellow,
              ),
            )
          else
            const SizedBox.shrink()
        ],
      ),
    );
  }
}

WebView({required String initialUrl, required javascriptMode, required Null Function(WebViewController controller) onWebViewCreated, required void Function(String finish) onPageFinished}) {
}
