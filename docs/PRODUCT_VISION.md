# Product Vision

## Working Title

Network Cable Demo is the first playable prototype of a broader educational mobile game about everyday computer networking.

The long-term product should help students understand computer networks through concrete, familiar situations instead of abstract definitions. The game should feel like a simple casual mobile game, but each interaction should teach a real networking concept.

## Core Idea

Many students hear terms such as Ethernet, modem, IP address, gateway, DNS, Wi-Fi, packet, and firewall as disconnected technical words. The goal of this app is to place those concepts inside small daily-life tasks.

Instead of saying:

```txt
An IP address identifies a host on a network.
```

The game should show:

```txt
The computer is plugged into the modem, but it still needs an address so the modem can know where to send messages.
```

The player learns by fixing simple network problems in a small room, school, home, cafe, or office environment.

## Educational Goal

The app is designed for students who are beginning to learn computer networks. The target user may not have prior technical knowledge. Each level should focus on one small concept and explain it through an action.

The educational style should be:

```txt
Concrete before abstract
Action before terminology
Short feedback before long explanation
Real-life analogy before formal definition
One concept per level
```

## Why Daily-Life Networking?

Computer networks are part of everyday life:

```txt
Connecting a laptop to a modem
Joining Wi-Fi at home
Getting an IP address
Opening a website
Using DNS without knowing it
Sharing files on the same network
Dealing with weak signal
Fixing a disconnected cable
Understanding why internet may work on one device but not another
```

These situations are easier for students to understand than starting with the OSI model or protocol definitions. The game should build intuition first, then gradually introduce technical vocabulary.

## Game Feel

The project takes inspiration from hyper-casual mobile games:

```txt
Short levels
Immediate interaction
Clear objective
Minimal text
One-handed play
Fast restart
Instant feedback
Simple success animation
Low cognitive friction
```

The app is not intended to become a complex simulation at first. It should remain simple, readable, and satisfying to use.

## Orientation Decision

The intended primary orientation is vertical portrait mode.

Reasons:

```txt
Most hyper-casual mobile games are played vertically
Students can play with one hand
Short educational sessions fit mobile usage better
Portrait layout supports top instruction, center gameplay, bottom choice panel
It is easier to package as a casual learning app
```

The game should still avoid breaking on wider screens, but design decisions should prioritize portrait phones.

## First Prototype Summary

The current prototype contains:

```txt
Level 1: Ethernet Connection
The player drags an Ethernet cable from the computer to the modem.

Level 2: IP Address
The player selects a suitable local IP address for the connected computer.
```

These two levels establish the first learning sequence:

```txt
Physical connection comes first.
Then the device needs a network address.
```

## Long-Term Vision

The final app can become a sequence of small networking puzzles:

```txt
Plug in the cable
Choose an IP address
Set a gateway
Fix Wi-Fi signal
Pick the correct DNS server
Trace a packet to a website
Identify a firewall block
Connect multiple devices to the same LAN
Separate local network and internet concepts
```

The goal is not to replace a textbook. The goal is to prepare students to understand the textbook better.

