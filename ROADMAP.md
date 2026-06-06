# Roadmap

## Current Status

The current prototype includes:

```txt
Flutter 3.44 / Dart 3.12 project
Flame-based interactive game scene
Seven-level networking curriculum
Cable drag interaction
Selection-card drag interaction
Level selection panel with locked/completed states
SQLite-backed user progress on non-web targets
In-memory progress repository for web prototype runs
Email/password login
SharedPreferences-backed session, avatar, and streak data
Turkish and English text support
Profile screen with tasks, badges, and daily streaks
HUD, hint flow, success panel, and final-level actions
Android, iOS, web, Linux, macOS, and Windows project folders
Automated model, repository, controller, layout, profile, and streak tests
```

## Completed Curriculum

The current learning path is:

```txt
1. Ethernet Connection
2. IP Address
3. Default Gateway
4. DNS Server
5. Subnet Mask
6. DHCP Service
7. Firewall
```

## Short-Term Plan

### 1. Polish Existing Levels

Focus:

```txt
Improve visual consistency
Replace rough code-drawn placeholders gradually
Clarify card and drop-zone placement
Tune phone and tablet layouts
Make hints more concept-focused
Keep success flow fast
```

Reason:

```txt
The seven-level path exists, so the next value is making the learning loop feel clearer and more finished.
```

### 2. Stabilize Local Persistence

Focus:

```txt
Keep user-specific progress reliable
Document SQLite database ownership clearly
Add migrations before schema changes
Persist web progress if web becomes a real target
Keep test coverage around unlock and last-played behavior
```

Reason:

```txt
Progress data is now part of the product experience. Regressions here directly affect student motivation.
```

### 3. Improve Login and Profile

Focus:

```txt
Better validation messages
Password reset placeholder or guidance
Clearer profile task and badge copy
Avatar persistence checks per user
Daily streak edge-case tests
```

Reason:

```txt
The app now has a user layer, so account friction should stay low and prototype security boundaries should be explicit.
```

### 4. Move Level Metadata Toward Seed Data

Focus:

```txt
Keep Dart LevelData models as the game-facing API
Prepare SQLite tables for level metadata
Seed level text and selection options
Avoid mixing Flame scene code with database queries
```

Reason:

```txt
Hardcoded level files are acceptable for seven levels, but a larger curriculum will be easier to maintain with structured seed data.
```

## Medium-Term Plan

### Asset Replacement

Replace code-drawn placeholders with final visual assets:

```txt
computer
modem/router
Ethernet cable
helper character
room tiles
selection cards
profile/avatar graphics
success effects
```

The asset style should remain:

```txt
friendly
pastel
isometric
simple
readable on mobile
```

### Sound and Haptics

Add:

```txt
button tap sound
wrong action sound
success sound
soft haptic feedback on correct actions
```

### Better Level Feedback

Add:

```txt
animated hints
highlighted target areas
short concept cards
replay explanation button
wrong-answer explanations per option
```

## Long-Term Plan

### Larger Curriculum

Possible future sequence:

```txt
Wi-Fi signal
LAN vs internet
Public vs private IP
Packet route
Basic troubleshooting
Ports and services
Safe password and account habits
Classroom network scenario
```

### Student Progress

Potential additions:

```txt
best completion time
most common wrong option
restart count
concept mastery status
local progress export
teacher-visible summary
```

### Teacher/Instructor Possibilities

Future version may include:

```txt
classroom mode
progress export
custom level packs
teacher dashboard
assignment links
```

These should not be built until the core learning loop is polished and validated.

## Product Risk

Main risks:

```txt
Too much text
Levels becoming lectures instead of games
Network concepts becoming too abstract too early
Visual style becoming inconsistent
Login/security expectations exceeding prototype scope
Database schema changing without migrations
```

Mitigation:

```txt
Keep each level small
Test on phone screens early
Use one concept per level
Keep the account layer clearly documented
Add migrations before schema changes
Keep automated tests around progress behavior
```
