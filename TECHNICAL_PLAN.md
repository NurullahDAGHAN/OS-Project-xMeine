# Technical Plan

## Current Stack

The prototype currently uses:

```txt
Flutter 3.44
Dart 3.12
Flame for the game scene
Flutter Material UI for app shell and overlays
ValueNotifier and ChangeNotifier for prototype state
Dart-defined LevelData files
SQLite for local account/progress data on non-web targets
SharedPreferences for session, avatar, and streak data
In-memory progress repository for web prototype runs
Turkish and English localization through app-level Dart data
Android, iOS, web, Linux, macOS, and Windows project folders
```

## Current Architecture

Main runtime flow:

```txt
AuthWrapper checks login state
LoginScreen handles account creation and sign-in
GameScreen creates repositories and GameProgressController
DartLevelRepository loads localized LevelData
ProgressRepository loads user progress
NetworkGame renders the Flame scene
Flutter overlays show HUD, profile, level selector, and success panel
```

Key files:

```txt
lib/main.dart
lib/data/auth_service.dart
lib/data/database_helper.dart
lib/data/game_progress_controller.dart
lib/data/level_repository.dart
lib/data/progress_repository.dart
lib/data/sqlite_progress_repository.dart
lib/game/network_game.dart
lib/game/levels/
lib/l10n/app_localizations.dart
lib/ui/
```

## Why Flutter

Flutter is suitable because:

```txt
It targets Android, iOS, web, and desktop from one codebase
It provides strong UI tools for HUDs, panels, forms, and dialogs
It supports responsive portrait and landscape layouts
It makes APK and web builds straightforward
```

## Why Flame

Flame is suitable because:

```txt
It provides a game loop
It has a component model
It supports drag interaction
It supports camera scaling
It keeps game-scene logic separate from Flutter UI
```

## Why SQLite

SQLite is used because:

```txt
The app needs offline local progress
The app needs per-user level unlock state
The app tracks completion, attempts, hints, and last played level
The login prototype needs a local user table
SQLite is lightweight and reliable on mobile/desktop
```

SQLite is not being used for online features. It is local prototype storage.

## Current Limitation

Level metadata is still stored in Dart files:

```txt
lib/game/levels/level_1.dart
lib/game/levels/level_2.dart
lib/game/levels/level_3.dart
lib/game/levels/level_4.dart
lib/game/levels/level_5.dart
lib/game/levels/level_6.dart
lib/game/levels/level_7.dart
```

This is acceptable for the current seven-level prototype. If the curriculum grows, level metadata should move into seed data while keeping `LevelData` as the game-facing model.

## SQLite Status

The MVP stores:

```txt
users
completed levels
unlocked levels
attempt counts
hint usage counts
last played level
```

The future implementation may move level metadata into SQLite tables:

```txt
level title/instruction/messages
scene theme
object positions
connection goals
selection questions and options
```

Game logic should continue to use Dart models loaded by repositories. Flame components should not query SQLite.

## Suggested Packages

Current direct dependencies:

```txt
flame
sqflite
shared_preferences
crypto
path
cupertino_icons
```

Current dev dependencies:

```txt
flutter_lints
sqflite_common_ffi
flutter_test
```

Possible future packages:

```txt
path_provider, if direct document/file paths are needed
drift, if queries and migrations become significantly more complex
```

For now, `sqflite` is enough.

## Suggested Code Structure

Current structure:

```txt
lib/
  data/
    auth_service.dart
    database_helper.dart
    game_progress_controller.dart
    level_repository.dart
    player_profile_preferences.dart
    player_progress_summary.dart
    player_streak_preferences.dart
    progress_repository.dart
    progress_repository_provider.dart
    progress_state.dart
    sqlite_progress_repository.dart
  game/
    network_game.dart
    components/
    levels/
  l10n/
    app_localizations.dart
  ui/
    game_hud.dart
    landscape_hint_hud.dart
    level_selection_panel.dart
    login_screen.dart
    player_progress_panel.dart
    success_panel.dart
```

This structure should remain until there is enough complexity to justify splitting features into deeper packages.

## State Management

The current app uses:

```txt
ValueNotifier inside NetworkGame
ChangeNotifier inside GameProgressController
FutureBuilder for startup/loading states
SharedPreferences for simple persisted preferences
```

This is acceptable for the prototype. Riverpod, Bloc, or another heavier state layer should wait until cross-screen state becomes harder to reason about.

## Testing Strategy

Current test coverage includes:

```txt
Level model behavior
Game progress controller behavior
SQLite progress repository behavior
Level selection layout behavior
Player progress summary behavior
Player streak preference behavior
```

Future tests should prioritize:

```txt
Database migrations
Login validation edge cases
Per-user progress isolation
Language switching with progress intact
Web progress persistence if web storage is added
```

## Asset Strategy

Current visuals are drawn with code. This keeps the prototype flexible.

Final visuals should gradually move to PNG or similar bitmap assets:

```txt
computer.png
modem_router.png
ethernet_cable.png
helper_character_idle.png
room_tiles.png
selection_cards.png
profile_avatars.png
success_sparkle.png
```

The current code should remain functional while assets are replaced incrementally.
