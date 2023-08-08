import 'package:dart_frog/dart_frog.dart';
import 'package:shelf_helmet/shelf_helmet.dart';

import '../main.dart';

Handler middleware(Handler handler) {
  return handler.use(requestLogger()).use(
        fromShelfMiddleware(
          helmet(
            options: HelmetOptions(
              cspOptions: ContentSecurityPolicyOptions.useDefaults(
                directives: {
                  'script-src': [
                    "'strict-dynamic'",
                    "'wasm-unsafe-eval'",
                    cspScriptHashes.join(' ').replaceAll('"', ''),
                    "'self'",
                    'blob:',
                    'https://unpkg.com/',
                    'https://www.gstatic.com/flutter-canvaskit/',
                  ],
                  'script-src-elem': [
                    cspScriptHashes.join(' ').replaceAll('"', ''),
                    "'self'",
                    'blob:',
                    'https://unpkg.com/',
                    'https://www.gstatic.com/flutter-canvaskit/',
                  ],
                  'connect-src': [
                    "'self'",
                    'https://unpkg.com/',
                    'https://www.gstatic.com/flutter-canvaskit/',
                    'https://fonts.gstatic.com/s/roboto/v20/KFOmCnqEu92Fr1Me5WZLCzYlKw.ttf ',
                  ],
                  'style-src': [
                    "'self'",
                    'https:',
                    cspStyleHashes.join(' ').replaceAll('"', ''),
                  ],
                  'require-trusted-types-for': ["'script'"],
                },
              ),
            ),
          ),
        ),
      );
}
