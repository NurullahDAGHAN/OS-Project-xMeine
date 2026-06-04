# Technical Plan

## Current Stack

The prototype currently uses:

```txt
Flutter
Flame
CustomPainter-style component rendering
ValueNotifier-based UI state
Level data defined in Dart files
SQLite-backed local progress
Level selection panel
Android APK release build
Web build for quick testing
```

## Target Stack

The planned stack is:

```txt
Flutter for app shell and UI
Flame for game scene, components, interactions, and effects
SQLite for persistent level/progress/content data
PNG assets for final visual production
Short WAV/OGG sounds for feedback
```

## Why Flutter

Flutter is suitable because:

```txt
It targets Android, iOS, web, and desktop from one codebase
It provides strong UI tools for HUD, panels, buttons, and dialogs
It works well for portrait mobile apps
It makes packaging APK builds straightforward
```

## Why Flame

Flame is suitable because:

```txt
It provides a game loop
It has a component model
It supports drag interaction
It supports camera scaling
It allows custom rendering and sprite rendering
It keeps game logic separate from Flutter UI
```

## Why SQLite

SQLite will be used as the local database.

Main reasons:

```txt
The app needs to store level definitions
The app needs to know which levels are unlocked
The app needs to track completion state
The app may need to store stars, attempts, or best time later
The app should work offline
SQLite is lightweight and reliable on mobile
SQLite is enough for this app before adding any backend
```

SQLite is not being chosen for complex online features. It is being chosen because level progression and educational content should be structured, queryable, and persistent on the device.

## Current Limitation

At the moment, level metadata is still stored in Dart files:

```txt
lib/game/levels/level_1.dart
lib/game/levels/level_2.dart
lib/game/levels/level_3.dart
lib/game/levels/level_4.dart
```

This is acceptable for the current four-level MVP, but it becomes harder to manage when the number of levels grows. Player progress is already separated into SQLite and should stay outside the Flame game scene.

## SQLite Migration Status

The MVP stores player progress in SQLite:

```txt
completed levels
unlocked levels
attempt counts
hint usage counts
last played level
```

The future implementation should move level metadata into SQLite tables.

Game logic can still use Dart models, but models should be loaded from SQLite instead of being hardcoded.

Proposed flow:

```txt
App starts
SQLite database opens
Seed data is inserted if needed
Available levels are loaded
Current level is selected
Level content is mapped to Dart models
Flame scene is built from the loaded model
Progress is saved after level completion
Next level is unlocked after success
```

## Suggested Flutter Packages

Possible package options:

```txt
sqflite
sqflite_common_ffi for desktop/testing
path
path_provider
```

Alternative:

```txt
drift
```

For this project, starting with `sqflite` is enough. Drift can be considered later if query complexity grows.

## Suggested Code Structure

Future structure:

```txt
lib/
  data/
    game_progress_controller.dart
    level_repository.dart
    progress_repository.dart
    sqlite_progress_repository.dart
  game/
    network_game.dart
    levels/
      level_data.dart
  ui/
    game_hud.dart
    ip_task_panel.dart
```

## State Management

The current app uses `ValueNotifier`, which is acceptable for the prototype.

Possible future state layers:

```txt
ValueNotifier for small prototype state
ChangeNotifier for simple app-wide progress
Riverpod or Bloc only if the app becomes larger
```

The project should not add heavy state management too early.

## Asset Strategy

Current visuals are drawn with code. This is useful for fast prototyping.

Final visuals should gradually move to PNG assets:

```txt
computer.png
modem.png
ethernet_cable.png
character_idle.png
room_tiles.png
port_glow.png
success_sparkle.png
```

The current code should remain functional even if final assets are not ready. This prevents asset production from blocking level design.
