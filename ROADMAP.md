# Roadmap

## Current Status

The current prototype includes:

```txt
Flutter + Flame project
Portrait-friendly scaling
Level 1: Ethernet cable connection
Level 2: IP address selection
HUD and success panel
Basic visual effects
Android APK release build
Web build for testing
Asset folder structure
```

## Short-Term Plan

### 1. Improve Existing Levels

Focus:

```txt
Better visual consistency
Clearer object placement
More polished cable and port visuals
Better phone layout testing
Cleaner success flow
```

Reason:

```txt
Before adding many levels, the first two levels should feel correct and understandable.
```

### 2. Add SQLite

Focus:

```txt
Add local database
Move level metadata to seed data
Store completion state
Unlock next level after success
Track attempts and hint usage
```

Reason:

```txt
SQLite will let the app manage level progression and make future level additions easier.
```

### 3. Add Level Selection Screen

Focus:

```txt
Show unlocked and locked levels
Show completed levels
Allow replay
Display simple concept names
```

Example:

```txt
1. Ethernet Connection
2. IP Address
3. Gateway
4. DNS
```

### 4. Add Gateway Level

Learning goal:

```txt
The default gateway is the route from local network to outside networks.
```

Possible task:

```txt
Select the modem as the gateway for the computer.
```

### 5. Add DNS Level

Learning goal:

```txt
DNS turns website names into IP addresses.
```

Possible task:

```txt
Match a website name to the DNS server and then to an IP result.
```

## Medium-Term Plan

### Asset Replacement

Replace code-drawn placeholders with final visual assets:

```txt
computer
modem
cable
character
room tiles
UI icons
success effects
```

The asset style should remain:

```txt
pastel
friendly
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
```

## Long-Term Plan

### Larger Curriculum

Possible curriculum sequence:

```txt
Physical connection
IP address
Subnet idea
Default gateway
DNS
Wi-Fi signal
Packet route
Firewall
LAN vs internet
Public vs private IP
Basic troubleshooting
```

### Student Progress

Track:

```txt
completed levels
wrong attempts
hint usage
time to complete
concept mastery
```

### Teacher/Instructor Possibilities

Future version may include:

```txt
classroom mode
progress export
custom level packs
teacher dashboard
```

These should not be built until the core learning loop is proven.

## Product Risk

Main risks:

```txt
Too much text
Levels becoming lectures instead of games
Network concepts becoming too abstract too early
Visual style becoming inconsistent
Adding database complexity before level design is stable
```

Mitigation:

```txt
Keep each level small
Test on phone screen early
Use one concept per level
Add SQLite after the level model is stable
Keep assets consistent
```

