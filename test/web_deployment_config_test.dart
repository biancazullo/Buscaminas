import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Web deployment configuration', () {
    test('manifest contains PWA metadata and required icons', () {
      final manifest =
          jsonDecode(File('web/manifest.json').readAsStringSync())
              as Map<String, Object?>;
      final icons = manifest['icons'] as List<Object?>;

      expect(manifest['name'], 'Buscaminas Flutter');
      expect(manifest['short_name'], 'Buscaminas');
      expect(manifest['lang'], 'es');
      expect(manifest['start_url'], './');
      expect(manifest['scope'], './');
      expect(manifest['display'], 'standalone');
      expect(manifest['theme_color'], '#1D6B7A');
      expect(icons, hasLength(greaterThanOrEqualTo(5)));
      expect(
        icons.where(
          (icon) =>
              icon is Map &&
              icon['src'] == 'icons/Icon-maskable-512.png' &&
              icon['purpose'] == 'maskable',
        ),
        isNotEmpty,
      );
    });

    test('index keeps Flutter base href placeholder and install metadata', () {
      final indexHtml = File('web/index.html').readAsStringSync();

      expect(indexHtml, contains('<html lang="es">'));
      expect(indexHtml, contains('<base href="\$FLUTTER_BASE_HREF">'));
      expect(indexHtml, contains('name="theme-color"'));
      expect(indexHtml, contains('rel="manifest"'));
      expect(indexHtml, contains('rel="apple-touch-icon"'));
    });

    test('custom bootstrap registers the project offline worker', () {
      final bootstrap = File('web/flutter_bootstrap.js').readAsStringSync();
      final worker = File(
        'web/buscaminas_service_worker.js',
      ).readAsStringSync();

      expect(bootstrap, contains('buscaminas_service_worker.js'));
      expect(bootstrap, isNot(contains('flutter_service_worker.js')));
      expect(worker, contains('CACHE_NAME'));
      expect(worker, contains('./main.dart.js'));
      expect(worker, contains('event.request.mode === \'navigate\''));
    });

    test('GitHub Pages workflow builds release web artifact', () {
      final workflow = File(
        '.github/workflows/deploy-pages.yml',
      ).readAsStringSync();

      expect(workflow, contains('flutter test'));
      expect(workflow, contains('flutter build web --release'));
      expect(workflow, contains('--no-web-resources-cdn'));
      expect(
        workflow,
        contains('--base-href "/\${{ github.event.repository.name }}/"'),
      );
      expect(workflow, contains('actions/upload-pages-artifact'));
      expect(workflow, contains('actions/deploy-pages'));
    });
  });
}
