# Game Design Document

## Design Pillars

NetQues should stay small, clear, and practical. The player should understand each task quickly, try it immediately, and leave with one networking idea that feels connected to daily life.

```txt
Simple interaction
Clear visual cause and effect
Short educational feedback
One concept per level
Mobile-first layout
Low penalty for mistakes
Replayable learning loop
```

## Core Loop

Each level follows the same learning rhythm:

```txt
Read one short task
Interact with the scene
Receive immediate feedback
Use a hint if needed
Complete the level
Read the learning note
Unlock the next concept
```

The Flame scene handles the interactive object work. Flutter overlays handle the level selector, hint HUD, profile entry point, and success panel.

## Level Structure

Each level includes:

```txt
Stable id
Task type
Scene theme
Title
Instruction
Short dialogue
Hint message
Connected feedback
Success message
Learning note
Next step message
Scene objects
Connection goal
Optional selection goal
```

Level definitions currently live in Dart files under `lib/game/levels/`. Turkish text is the source level data, and English copies are generated through `lib/l10n/app_localizations.dart`.

## Current Levels

### Level 1: Ethernet Connection

Concept:

```txt
Internet access starts with physical connectivity.
```

Player action:

```txt
Drag the Ethernet cable plug to the modem port.
```

Learning outcome:

```txt
The student understands that a cable creates the physical network connection between a computer and a modem/router.
```

### Level 2: IP Address

Concept:

```txt
A device needs an IP address that fits the local network.
```

Player action:

```txt
Drag the correct IP address card to the computer.
```

Correct answer:

```txt
192.168.1.24
```

### Level 3: Default Gateway

Concept:

```txt
The gateway is the exit point from the local network to other networks.
```

Player action:

```txt
Choose the modem/router address as the default gateway.
```

Correct answer:

```txt
192.168.1.1 (Modem)
```

### Level 4: DNS Server

Concept:

```txt
DNS translates readable website names into IP addresses.
```

Player action:

```txt
Choose the DNS server card.
```

Correct answer:

```txt
DNS Sunucusu
```

### Level 5: Subnet Mask

Concept:

```txt
The subnet mask tells the computer which addresses are local.
```

Player action:

```txt
Choose the correct mask for a 192.168.1.x network.
```

Correct answer:

```txt
255.255.255.0
```

### Level 6: DHCP Service

Concept:

```txt
DHCP automatically distributes network settings.
```

Player action:

```txt
Choose the service that gives IP, mask, gateway, and DNS settings automatically.
```

Correct answer:

```txt
DHCP Sunucusu
```

### Level 7: Firewall

Concept:

```txt
A firewall allows or blocks traffic according to rules.
```

Player action:

```txt
Choose the rule that allows web access.
```

Correct answer:

```txt
HTTP/HTTPS trafigine izin ver
```

## Failure Design

Failure should be soft and educational. A wrong action should:

```txt
Return the object or card to a safe state
Show short feedback
Increase the attempt count
Keep the player in the same level
Allow immediate retry
```

Hints should help the player think about the concept instead of only revealing the answer.

## Progression

The first level is unlocked by default. Completing a level marks it as completed, records the last played level, and unlocks the next level. The level selection panel shows locked, open, completed, and selected states.

Progress is user-based on non-web platforms through SQLite. Web uses an in-memory progress repository for the prototype.

## Profile Layer

The profile screen supports:

```txt
Completed level count
Task progress
Badge progress
Avatar selection
Daily streak display
```

These features are motivational wrappers around the core learning loop. They should stay lightweight and should not distract from level clarity.

## UI Layout

Portrait layout should generally use:

```txt
Top: level selector and settings
Middle: interactive scene
Overlay: hint HUD, profile button, success panel
```

Landscape layout uses a side level-selection panel and keeps the game scene readable. Both layouts should avoid long text blocks during play.

## Text Guidelines

Text must be short and practical.

Good:

```txt
Choose an IP address in the same network as the modem.
```

Too long:

```txt
In order for devices to communicate at Layer 3 of the OSI model, the host must have an address within the same subnet as its default gateway...
```

Formal terminology can appear in the learning note, but the first instruction should always be action-oriented.

## Future Level Ideas

Possible future levels:

```txt
Wi-Fi signal strength
LAN vs internet
Public vs private IP
Packet route
Basic troubleshooting
```

New levels should reuse the same short interaction pattern unless a new mechanic clearly improves the concept.
