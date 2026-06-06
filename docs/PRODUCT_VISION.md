# Product Vision

## Working Title

NetQues is an educational networking game built with Flutter and Flame. It teaches beginner computer-networking concepts through short, concrete interactions instead of long abstract explanations.

## Core Idea

Many students first meet words like Ethernet, IP address, gateway, DNS, subnet mask, DHCP, and firewall as disconnected technical terms. NetQues places those ideas inside simple daily-life network tasks.

Instead of only saying:

```txt
An IP address identifies a host on a network.
```

The game shows:

```txt
The computer is connected to the modem, but it still needs an address that fits this local network.
```

The student learns by fixing small network setup problems in a friendly room, office, data center, or security-themed scene.

## Target Audience

The app is designed for students who are beginning to learn computer networks. The target user may not have prior technical knowledge.

The educational style should be:

```txt
Concrete before abstract
Action before terminology
Short feedback before long explanation
Real-life analogy before formal definition
One concept per level
```

## Current Product Shape

The current prototype includes a complete seven-level learning path:

```txt
1. Ethernet Connection
2. IP Address
3. Default Gateway
4. DNS Server
5. Subnet Mask
6. DHCP Service
7. Firewall
```

The app also includes:

```txt
Email/password registration and login
User-based local progress
Level locking and completion states
Attempt and hint counts
Last played level restore
Turkish and English text support
Profile summary
Avatar selection
Tasks, badges, and daily streaks
Desktop, mobile, and web Flutter targets
```

## Why Daily-Life Networking?

Computer networks are part of everyday life:

```txt
Connecting a laptop to a modem
Getting an IP address
Opening a website
Using DNS without noticing it
Sharing a local network
Receiving automatic DHCP settings
Understanding firewall rules
Fixing a disconnected cable
```

These situations are easier to understand than starting with protocol definitions or the OSI model. NetQues should build intuition first, then gradually introduce technical vocabulary.

## Game Feel

The project takes inspiration from hyper-casual mobile games:

```txt
Short levels
Immediate interaction
Clear objective
Minimal text
Fast retry
Instant feedback
Simple success animation
Low cognitive friction
```

The app is not intended to be a complex simulation at this stage. It should remain readable, friendly, and satisfying to use.

## Orientation Decision

The primary design target is mobile-friendly portrait play, with a landscape layout available for wider screens.

Reasons:

```txt
Short educational sessions fit mobile usage
Portrait layout supports quick reading and quick action
Students can play with little setup
Landscape can show the level list and game scene side by side
```

## Product Boundaries

NetQues should not try to replace a textbook or a full network simulator. Its role is to prepare students to understand formal material better.

The current prototype should focus on:

```txt
Keeping the seven-level path stable
Improving visual polish
Keeping explanations short
Making progress reliable
Reducing friction in login and replay
```

## Long-Term Vision

The final app can become a sequence of small networking puzzles:

```txt
Plug in the cable
Choose an IP address
Set a gateway
Pick the correct DNS server
Choose a subnet mask
Use DHCP
Apply firewall rules
Compare LAN and internet traffic
Trace packets to a website
Troubleshoot common connection failures
```

Future classroom features may include progress export, teacher dashboards, and custom level packs, but those should wait until the core learning loop is proven and polished.
