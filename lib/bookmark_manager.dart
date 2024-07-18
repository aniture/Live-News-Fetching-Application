import 'package:shared_preferences/shared_preferences.dart';

class BookmarkManager {
  static const String _bookmarksKey = 'bookmarks';

  Future<List<String>> getBookmarks() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_bookmarksKey) ?? [];
  }

  Future<void> addBookmark(String newsUrl) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> bookmarks = prefs.getStringList(_bookmarksKey) ?? [];
    if (!bookmarks.contains(newsUrl)) {
      bookmarks.add(newsUrl);
      await prefs.setStringList(_bookmarksKey, bookmarks);
    }
  }

  Future<void> removeBookmark(String newsUrl) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> bookmarks = prefs.getStringList(_bookmarksKey) ?? [];
    bookmarks.remove(newsUrl);
    await prefs.setStringList(_bookmarksKey, bookmarks);
  }
}
