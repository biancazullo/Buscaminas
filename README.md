# Buscaminas Flutter

Juego de Buscaminas desarrollado con Flutter para el micro-proyecto del periodo 2526-3. El proyecto implementa una experiencia completa: splash, menu principal, seleccion de dificultad, tablero jugable, marcadores locales, configuracion, instrucciones, creditos, PWA offline y despliegue web automatizado.

Integrantes:
- Bianca Zullo
- Corina Vera

## Requisitos

- Flutter SDK estable con Dart 3.12 o superior.
- Chrome o un navegador compatible para Flutter Web.
- Firebase CLI solo si se desea desplegar en Firebase Hosting.

Dependencias principales:
- `material.dart` para toda la interfaz.
- `shared_preferences` para persistencia local.
- `animate_do` para animaciones permitidas.
- `cupertino_icons` como fuente estandar de iconos Flutter.

## Ejecucion Local

Instalar dependencias:

```bash
flutter pub get
```

Ejecutar en Chrome:

```bash
flutter run -d chrome
```

Ejecutar en un dispositivo o emulador disponible:

```bash
flutter devices
flutter run -d <device-id>
```

## Pruebas

Analisis estatico:

```bash
flutter analyze
```

Suite completa:

```bash
flutter test
```

La suite cubre motor del juego, persistencia, marcadores, configuracion, navegacion, pantallas informativas, flujo de partida y configuracion web/PWA.

## Build Web

Build local para revisar el resultado web:

```bash
flutter build web --release --no-web-resources-cdn --base-href /
```

Build compatible con GitHub Pages para un repositorio llamado `buscaminas`:

```bash
flutter build web --release --no-web-resources-cdn --base-href /buscaminas/
```

El resultado queda en `build/web`.

## GitHub Pages

El workflow [.github/workflows/deploy-pages.yml](.github/workflows/deploy-pages.yml) hace lo siguiente al hacer push a `main` o al ejecutarse manualmente:

1. Instala Flutter estable.
2. Ejecuta `flutter pub get`.
3. Ejecuta `flutter test`.
4. Construye Flutter Web con `--no-web-resources-cdn` y `--base-href "/${{ github.event.repository.name }}/"`.
5. Publica `build/web` en GitHub Pages.

En GitHub, configurar Pages con el origen `GitHub Actions`.

## Firebase Hosting

El archivo [firebase.json](firebase.json) esta listo para publicar `build/web` sin comprometer un proyecto especifico. No se incluye `.firebaserc` para evitar guardar un project ID en el repositorio.

Uso recomendado:

```bash
flutter build web --release --no-web-resources-cdn --base-href /
firebase deploy --only hosting --project <project-id>
```

Para previews:

```bash
firebase hosting:channel:deploy preview --project <project-id>
```

La configuracion incluye rewrites a `index.html`, cache conservadora para HTML/bootstrap/service worker y cache larga para assets estaticos.

## PWA Offline

La app incluye:
- [web/manifest.json](web/manifest.json) con metadata, iconos, scope y modo standalone.
- [web/flutter_bootstrap.js](web/flutter_bootstrap.js) con registro del service worker del proyecto.
- [web/buscaminas_service_worker.js](web/buscaminas_service_worker.js) con precache de recursos principales y fallback de navegacion.
- Iconos personalizados en `web/icons`.

Para verificar el build:

```bash
flutter build web --release --no-web-resources-cdn --base-href /buscaminas/
test -f build/web/manifest.json
test -f build/web/buscaminas_service_worker.js
test -f build/web/main.dart.js
```

## Arquitectura

La aplicacion esta separada por capas:

- `lib/domain`: modelos y motor de Buscaminas.
- `lib/data`: servicios y repositorios de persistencia local.
- `lib/ui/core`: tema y view model global.
- `lib/ui/features`: pantallas y view models por funcionalidad.
- `lib/app`: wiring de dependencias.

La logica del tablero vive en `MinesweeperEngine`; la UI consume estado mediante `ChangeNotifier` y `ListenableBuilder`, sin acoplar reglas de juego a widgets.

## Funcionalidades

- Splash con entrada animada y opcion de saltar.
- Menu principal con Jugar, Marcadores, Configuracion, Instrucciones y Creditos.
- Dificultades: Facil 6x6 con 10 minas, Medio 8x8 con 20 minas, Dificil 10x10 con 30 minas.
- Primer reveal seguro.
- Colocacion aleatoria de minas y calculo de adyacencias.
- Reveal de celdas, flood fill para zonas vacias, banderas por long press o click secundario.
- Contador de minas restantes, tiempo e intentos.
- Estados de partida: lista, en curso, victoria y derrota.
- Overlay de resultado con tiempo, intentos, dificultad, nuevo record, Continuar, Reintentar y Salir.
- Marcadores locales top 10 por dificultad, ordenados por tiempo y luego intentos.
- Borrado de marcadores con confirmacion.
- Tema claro, oscuro y automatico.
- Estilos de numeros: clasico, colorido, retro y minimalista.
- Toggles para animaciones y sonido opcional.
- Instrucciones y creditos.
- Layout responsive para mobile, tablet y desktop.

## Checklist Del Enunciado

- [x] Uso de Flutter con `material.dart`.
- [x] Persistencia local con `shared_preferences`.
- [x] Animaciones con libreria permitida (`animate_do`) y opcion para desactivarlas.
- [x] Splash screen y menu principal tematico.
- [x] Pantalla de configuracion con dificultad, tema, animaciones, sonido y estilos de numeros.
- [x] Pantalla de marcadores por dificultad con top 10, fecha, medallas, estado vacio y borrado confirmado.
- [x] Pantalla de instrucciones con reglas y resumen de dificultades.
- [x] Pantalla de juego con tablero configurable, minas aleatorias, primera celda segura y flood fill.
- [x] Cronometro, contador de intentos y contador de minas restantes.
- [x] Victoria, derrota, reveal de minas y overlay de fin de partida.
- [x] Persistencia de preferencias y high scores entre sesiones locales.
- [x] Separacion entre dominio, datos y UI.
- [x] Responsive mediante `LayoutBuilder`, constraints y layouts adaptativos.
- [x] PWA instalable con manifest e iconos.
- [x] Soporte offline mediante service worker propio.
- [x] GitHub Actions para test, build web y despliegue a GitHub Pages.
- [x] Firebase Hosting reutilizable mediante `firebase.json` sin `.firebaserc`.

## Commits Sugeridos Del Desarrollo

El proyecto fue trabajado en tramos para permitir commits de valor:

1. `chore: scaffold Flutter Buscaminas project`
2. `chore: add layered app architecture`
3. `feat: persist player settings locally`
4. `feat: implement minesweeper engine`
5. `feat: add splash and main menu`
6. `feat: add difficulty selection flow`
7. `feat: build responsive game board`
8. `feat: add game result overlay`
9. `feat: add high scores`
10. `feat: complete settings screen`
11. `feat: add instructions and credits`
12. `style: polish responsive game UI`
13. `test: cover game logic and UI flows`
14. `ci: deploy Flutter web to GitHub Pages`
15. `docs: add deployment docs and final checklist`
