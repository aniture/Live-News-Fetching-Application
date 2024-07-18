import 'package:flutter_test/flutter_test.dart';

void main() {
  group('getDataFromApi', () {
    test('should handle successful response', () async {
      final httpMock = MockHttp();
      httpMock.mockResponse(
        statusCode: 200,
        body: '{"totalResults": 1, "articles": [{"title": "Test Article"}]}',
      );

      final myAppState = _MyAppState(); 
      await myAppState.getDataFromApi(httpMock.mockUrl);

      expect(myAppState.news.length, 1);
      expect(myAppState.news[0]['title'], 'Test Article');
    });

    test('should handle error response', () async {
      final httpMock = MockHttp();
      httpMock.mockResponse(statusCode: 404, body: 'Not Found');

      final myAppState = _MyAppState(); 
      await myAppState.getDataFromApi(httpMock.mockUrl);

      expect(myAppState.notFound, true);
    });
  });

  group('getNews', () {
    test('should handle successful news retrieval', () async {
      final myAppState = _MyAppState(); 
      await myAppState.getNews();

      
      expect(myAppState.news.isNotEmpty, true);
    });

     });
}

_MyAppState() {
}

class MockHttp {
  final String mockUrl = 'https://example.com/mock';

  void mockResponse({required int statusCode, required String body}) {
      }
}
