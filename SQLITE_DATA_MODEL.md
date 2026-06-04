# SQLite Data Model Plan

## Purpose

SQLite will be used to store level definitions, progression, and student-facing content. The database should make it easy to add, unlock, reorder, and update levels without scattering level data across many Dart files.

## Database Responsibilities

SQLite should store:

```txt
Level list
Level order
Level title
Level instruction
Level educational messages
Level task type
Level object positions
Level goals
Answer options for choice-based tasks
Player progress
Completion state
Attempt count
```

SQLite should not store:

```txt
Large image files
Large audio files
Runtime-only animation state
Temporary drag positions
Per-frame game state
```

Assets should stay in the app bundle. SQLite should store references or keys, not large binary files.

## Proposed Tables

### levels

Stores basic level metadata.

```sql
CREATE TABLE levels (
  id TEXT PRIMARY KEY,
  sort_order INTEGER NOT NULL,
  task_type TEXT NOT NULL,
  title TEXT NOT NULL,
  instruction TEXT NOT NULL,
  dialogue TEXT NOT NULL,
  hint_message TEXT NOT NULL,
  connected_message TEXT NOT NULL,
  success_message TEXT NOT NULL,
  is_enabled INTEGER NOT NULL DEFAULT 1
);
```

Example rows:

```txt
ethernet_connection
ip_address
```

### level_objects

Stores scene objects and their positions.

```sql
CREATE TABLE level_objects (
  id TEXT PRIMARY KEY,
  level_id TEXT NOT NULL,
  object_type TEXT NOT NULL,
  x REAL NOT NULL,
  y REAL NOT NULL,
  text TEXT,
  FOREIGN KEY (level_id) REFERENCES levels(id)
);
```

Example object types:

```txt
computer
modem
cable
character
dialogueBubble
```

### cable_goals

Stores cable connection goals.

```sql
CREATE TABLE cable_goals (
  id TEXT PRIMARY KEY,
  level_id TEXT NOT NULL,
  cable_id TEXT NOT NULL,
  from_object_id TEXT NOT NULL,
  to_object_id TEXT NOT NULL,
  start_x REAL NOT NULL,
  start_y REAL NOT NULL,
  rest_end_x REAL NOT NULL,
  rest_end_y REAL NOT NULL,
  target_x REAL NOT NULL,
  target_y REAL NOT NULL,
  FOREIGN KEY (level_id) REFERENCES levels(id)
);
```

### ip_selection_goals

Stores IP selection questions.

```sql
CREATE TABLE ip_selection_goals (
  id TEXT PRIMARY KEY,
  level_id TEXT NOT NULL,
  question TEXT NOT NULL,
  correct_option TEXT NOT NULL,
  FOREIGN KEY (level_id) REFERENCES levels(id)
);
```

### ip_selection_options

Stores multiple-choice options for IP tasks.

```sql
CREATE TABLE ip_selection_options (
  id TEXT PRIMARY KEY,
  goal_id TEXT NOT NULL,
  option_text TEXT NOT NULL,
  sort_order INTEGER NOT NULL,
  FOREIGN KEY (goal_id) REFERENCES ip_selection_goals(id)
);
```

### player_progress

Stores local player progress.

```sql
CREATE TABLE player_progress (
  level_id TEXT PRIMARY KEY,
  is_unlocked INTEGER NOT NULL DEFAULT 0,
  is_completed INTEGER NOT NULL DEFAULT 0,
  best_attempts INTEGER,
  last_attempts INTEGER NOT NULL DEFAULT 0,
  completed_at TEXT,
  FOREIGN KEY (level_id) REFERENCES levels(id)
);
```

## Unlock Logic

Initial state:

```txt
Level 1 unlocked
Level 2 locked or unlocked depending on prototype preference
```

Recommended production behavior:

```txt
Only the first level is unlocked at first.
Completing a level unlocks the next level.
```

Example:

```txt
Complete ethernet_connection
Unlock ip_address
```

## Seed Data

The app should seed the database on first launch.

Seed strategy:

```txt
Check database version
Create tables if missing
Insert base levels if missing
Insert progress rows if missing
Do not overwrite player progress
```

This allows app updates to add new levels without deleting existing progress.

## Versioning

The database should have a version number.

Example:

```txt
version 1: ethernet + IP levels
version 2: gateway level
version 3: DNS level
```

When the schema changes, migrations should be written explicitly.

## Mapping to Dart Models

SQLite rows should be converted into existing Dart models:

```txt
LevelData
LevelObjectData
CableConnectionData
IpSelectionData
LevelGoalData
```

This keeps the game engine independent from the database layer.

The Flame game should not query SQLite directly. It should receive already-loaded level data from a repository or app controller.

## Future Analytics

SQLite can later store local analytics:

```txt
wrong attempt count
time spent per level
most common wrong option
number of restarts
hint usage
```

This can help improve level design even before adding cloud analytics.

