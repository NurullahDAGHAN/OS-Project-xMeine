# Game Design Document

## Design Pillars

The game should follow these pillars:

```txt
Simple interaction
Clear visual cause and effect
Short educational message
One concept per level
Portrait-first mobile layout
Hyper-casual pacing
Low penalty for mistakes
```

## Level Structure

Each level should include:

```txt
Title
Instruction
Short dialogue
Playable task
Hint message
Success message
Learning note
Next step
```

A level should be understandable within a few seconds. If a student cannot understand what to do after reading one short sentence, the level is too complex.

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

Feedback:

```txt
Wrong drop: explain that the cable must be placed into the Ethernet port.
Correct drop: modem lights turn on, computer screen becomes connected, success panel opens.
```

Learning outcome:

```txt
The student understands that a cable is a physical connection between the computer and the modem/router.
```

### Level 2: IP Address

Concept:

```txt
A device needs a compatible IP address to communicate on a local network.
```

Player action:

```txt
Choose the correct IP address from multiple options.
```

Current correct answer:

```txt
192.168.1.24
```

Reason:

```txt
The modem is presented as being on the 192.168.1.x network. A computer on the same local network should use an address in that range.
```

Wrong answers:

```txt
10.0.0.9
172.16.4.2
```

These are valid private IP ranges in real networking, but they do not match the current local network in this level. This lets the level teach that an IP address must fit the network, not only look like a valid address.

## Future Level Ideas

### Level 3: Default Gateway

Concept:

```txt
The gateway is the device that sends traffic outside the local network.
```

Possible task:

```txt
Select the modem/router as the default gateway for the computer.
```

Real-life analogy:

```txt
The gateway is like the exit door from the local room to the outside world.
```

### Level 4: DNS

Concept:

```txt
DNS translates website names into IP addresses.
```

Possible task:

```txt
Match example.com to a DNS lookup result.
```

Real-life analogy:

```txt
DNS is like a contact list that turns names into numbers.
```

### Level 5: Wi-Fi Signal

Concept:

```txt
Wireless connection quality depends on distance and obstacles.
```

Possible task:

```txt
Move the laptop closer to the router or remove an obstacle.
```

### Level 6: Packet Route

Concept:

```txt
Data travels in small packets through network devices.
```

Possible task:

```txt
Guide packet bubbles from the computer to the website through modem, ISP, and server.
```

### Level 7: Firewall

Concept:

```txt
A firewall allows or blocks traffic according to rules.
```

Possible task:

```txt
Allow browser traffic but block suspicious traffic.
```

## Failure Design

Failure should be soft and educational.

The player should not lose lives or be punished heavily. A wrong action should:

```txt
Return the object to a safe state
Show a short hint
Highlight the correct area if useful
Allow immediate retry
```

## UI Layout

Portrait layout should generally use:

```txt
Top: task panel and status
Middle: interactive scene
Bottom: action choices or draggable objects
Overlay: success panel
```

This matches mobile hyper-casual rhythm while keeping the educational message visible.

## Text Guidelines

Text must be short.

Good:

```txt
Choose an IP address in the same network as the modem.
```

Too long:

```txt
In order for devices to communicate at Layer 3 of the OSI model, the host must have an address within the same subnet as its default gateway...
```

Formal terminology can appear later, but the first explanation should be practical.

