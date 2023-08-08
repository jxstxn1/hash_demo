import 'package:csp_hasher/csp_hasher.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../main.dart';
import '../../routes/_middleware.dart';

class _MockRequestContext extends Mock implements RequestContext {}

void main() {
  group('Middleware', () {
    setUp(() {
      cspScriptHashes.addAll([
        CspHash(
          lineNumber: 1,
          hashType: sha256,
          hash: 'abcdef',
          hashMode: HashMode.script,
        ),
      ]);
      cspStyleHashes.addAll([
        CspHash(
          lineNumber: 1,
          hashType: sha256,
          hash: 'ghijkl',
          hashMode: HashMode.style,
        ),
      ]);
    });
    test('add all required headers', () async {
      final handler = middleware((context) => Response());
      final request = Request.get(Uri.parse('http://localhost/'));
      final context = _MockRequestContext();

      when(() => context.request).thenReturn(request);

      final finishedHandler = await handler(context);

      const cspRules =
          '''script-src 'unsafe-inline' 'strict-dynamic' 'wasm-unsafe-eval' 'sha256-abcdef' 'self' blob: https://unpkg.com/ https://www.gstatic.com/flutter-canvaskit/;script-src-elem 'sha256-abcdef' 'self' blob: https://unpkg.com/ https://www.gstatic.com/flutter-canvaskit/;connect-src 'self' https://unpkg.com/ https://www.gstatic.com/flutter-canvaskit/ https://fonts.gstatic.com/s/roboto/v20/KFOmCnqEu92Fr1Me5WZLCzYlKw.ttf ;style-src 'self' https: 'sha256-ghijkl';require-trusted-types-for 'script';default-src 'self';base-uri 'self';font-src 'self' https: data:;form-action 'self';frame-ancestors 'self';img-src 'self' data:;object-src 'none';script-src-attr 'none';upgrade-insecure-requests''';
      _expectedHeaders(finishedHandler.headers, cspRules);
    });
  });
}

void _expectedHeaders(Map<String, String> headers, String cspRules) {
  expect(headers['content-length'], '0');
  expect(headers['x-xss-protection'], '0');
  expect(headers['x-permitted-cross-domain-policies'], 'none');
  expect(headers['x-frame-options'], 'SAMEORIGIN');
  expect(headers['x-download-options'], 'noopen');
  expect(headers['x-dns-prefetch-control'], 'off');
  expect(headers['x-content-type-options'], 'nosniff');
  expect(
    headers['strict-transport-security'],
    'max-age=15552000; includeSubDomains',
  );
  expect(headers['referrer-policy'], 'no-referrer');
  expect(headers['origin-agent-cluster'], '?1');
  expect(headers['cross-origin-resource-policy'], 'same-origin');
  expect(headers['cross-origin-opener-policy'], 'same-origin');
  expect(headers['Content-Security-Policy'], cspRules);
}
