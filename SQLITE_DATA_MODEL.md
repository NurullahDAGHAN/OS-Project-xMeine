# SQLite Data Model

## Purpose

SQLite is used for local account and progress data in the NetQues prototype. Level definitions are still stored in Dart files, while completion state, unlock state, attempts, hints, and last-played information are persisted locally.

The Flame game should not query SQLite directly. It receives loaded level data and progress state through repository/controller classes.

## Current Storage Overview

The app currently uses two SQLite databases on non-web targets:

```txt
network_cable_demo.db
  users

network_training.db
  level_progress
  app_state
```

The app also uses SharedPreferences for:

```txt
login session state
active user email
avatar selection
daily streak data
```

Web currently uses an in-memory progress repository for gameplay progress. That means web progress is prototype-only and does not survive reloads.

## Current Tables

### users

Created by `lib/data/database_helper.dart`.

```sql
CREATE TABLE users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  email TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

Responsibilities:

```txt
Store registered account email
Store SHA-256 password hash for the prototype login flow
Prevent duplicate emails with a unique constraint
```

Production note:

```txt
SHA-256 password hashing is acceptable only for this prototype. A production app should use salted slow password hashing and a backend-owned auth flow.
```

### level_progress

Created by `lib/data/sqlite_progress_repository.dart`.

```sql
CREATE TABLE level_progress (
  level_id TEXT NOT NULL,
  user_email TEXT NOT NULL,
  unlocked INTEGER NOT NULL,
  completed INTEGER NOT NULL DEFAULT 0,
  attempts INTEGER NOT NULL DEFAULT 0,
  hints_used INTEGER NOT NULL DEFAULT 0,
  PRIMARY KEY (level_id, user_email)
);
```

Responsibilities:

```txt
Track which levels are unlocked per user
Track completed levels per user
Count wrong attempts per level
Count hint usage per level
Keep progress separate between users
```

### app_state

Created by `lib/data/sqlite_progress_repository.dart`.

```sql
CREATE TABLE app_state (
  key TEXT NOT NULL,
  user_email TEXT NOT NULL,
  value TEXT NOT NULL,
  PRIMARY KEY (key, user_email)
);
```

Current key:

```txt
last_played_level_id
```

Responsibilities:

```txt
Restore the last played level for each user
Allow future small app-level state values without adding a table for each one
```

## Unlock Logic

Initial state:

```txt
The first level is unlocked.
All later levels are locked.
```

On completion:

```txt
Mark current level as completed and unlocked.
Unlock the next level if one exists.
Store the completed level as last_played_level_id.
```

During seed/load:

```txt
Insert missing level_progress rows without overwriting existing progress.
Insert last_played_level_id if missing.
Re-unlock the next level for any already-completed level.
```

## Current Level IDs

The current seven level IDs are:

```txt
ethernet_connection
ip_address
default_gateway
dns_lookup
subnet_mask
dhcp_service
firewall_rules
```

These IDs come from Dart level data and are passed into the progress repository.

## Repository Boundary

Current data flow:

```txt
DartLevelRepository loads LevelData
GameProgressController asks ProgressRepository for progress
SqliteProgressRepository stores progress on non-web targets
In-memory repository stores progress on web prototype runs
NetworkGame receives selected level data and reports completion/hints/attempts
```

This keeps database details outside Flame components.

## Planned Level Metadata Tables

Future versions may move level metadata from Dart files into SQLite seed data.

Candidate tables:

```sql
CREATE TABLE levels (
  id TEXT PRIMARY KEY,
  sort_order INTEGER NOT NULL,
  task_type TEXT NOT NULL,
  scene_theme TEXT NOT NULL,
  title TEXT NOT NULL,
  instruction TEXT NOT NULL,
  dialogue TEXT NOT NULL,
  hint_message TEXT NOT NULL,
  connected_message TEXT NOT NULL,
  success_message TEXT NOT NULL,
  learning_note TEXT NOT NULL,
  next_step_message TEXT NOT NULL,
  is_enabled INTEGER NOT NULL DEFAULT 1
);
```

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

```sql
CREATE TABLE selection_goals (
  id TEXT PRIMARY KEY,
  level_id TEXT NOT NULL,
  question TEXT NOT NULL,
  correct_option TEXT NOT NULL,
  FOREIGN KEY (level_id) REFERENCES levels(id)
);
```

```sql
CREATE TABLE selection_options (
  id TEXT PRIMARY KEY,
  goal_id TEXT NOT NULL,
  option_text TEXT NOT NULL,
  sort_order INTEGER NOT NULL,
  FOREIGN KEY (goal_id) REFERENCES selection_goals(id)
);
```

These tables should be introduced with explicit migrations, not by replacing the current progress schema in place.

## Versioning

Current SQLite schemas are version `1`.

When schema changes are needed:

```txt
Increase the database version
Add onUpgrade migrations
Preserve existing users and progress
Add tests for migration behavior
Avoid destructive resets during normal app startup
```

## Future Analytics

SQLite can later store local analytics:

```txt
time spent per level
most common wrong option
restart count
best completion path
concept mastery estimate
```

These should be added only after the core progress model remains stable.
