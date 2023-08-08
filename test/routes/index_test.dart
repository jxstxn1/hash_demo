import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import '../../routes/index.dart' as route;

class _MockRequestContext extends Mock implements RequestContext {}

final htmlString = File(
  '${Directory.current.path}/public/index.html',
).readAsStringSync();

void main() {
  group('GET /', () {
    test('responds with a 200, an html and the content_type header text/html',
        () async {
      final context = _MockRequestContext();
      final response = route.onRequest(context);
      expect(response.statusCode, equals(200));
      expect(
        response.headers,
        equals({
          'Content-Type': 'text/html',
          'content-length': '1830',
        }),
      );
      expect(response.body(), completion(htmlString));
    });
  });
}
