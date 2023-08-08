// custom entrypoint for the app
import 'dart:io';

import 'package:csp_hasher/csp_hasher.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:path/path.dart' as path;

List<CspHash> cspScriptHashes = [];
List<CspHash> cspStyleHashes = [];

Future<HttpServer> run(Handler handler, InternetAddress ip, int port) {
  generateCspHashes();
  return serve(handler, ip, port, poweredByHeader: null);
}

/// Generates CSP hashes for the scripts and styles in the index.html file
void generateCspHashes() {
  final file = File(
    path.join(Directory.current.path, 'public', 'index.html'),
  );
  if (!file.existsSync()) {
    throw Exception('Index Not found\nPlease run build_web.sh first');
  }

  cspScriptHashes = hashScripts(htmlFile: file);
  cspStyleHashes = hashScripts(
    htmlFile: file,
    hashMode: HashMode.style,
  );
}
