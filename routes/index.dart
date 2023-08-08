import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:path/path.dart' as path;

Response onRequest(RequestContext context) {
  final file = File(
    path.join(Directory.current.path, 'public', 'index.html'),
  );
  final indexHtml = file.readAsStringSync();
  return Response(body: indexHtml, headers: {'Content-Type': 'text/html'});
}
