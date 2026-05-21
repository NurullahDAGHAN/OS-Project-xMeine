# 🌐 Isometric Network Training Prototype

This repository contains an educational networking prototype developed using Flutter and the Flame 2D game engine. It features a single-room interactive environment designed to simplify abstract networking structures through engaging, gamified mechanics aligned with national educational standards.


## 🎯 Educational Framework & Curriculum Alignment

### Target Audience & Adaptability
The primary target audience consists of 5th and 6th-grade students (Ages 10-12) taking compulsory Information Technology courses. However, due to its modular architecture, the prototype is fully adaptable and can be utilized across all middle school grade levels (Grades 5-8) as an introductory or remedial learning tool for computer science.

### Alignment with the Turkish National Curriculum (MEB Kazanımları)
The interactive tasks in this prototype are mapped directly onto the Turkish Ministry of National Education (MEB) K-12 Information Technologies and Software Curriculum under the "Computer Networks" (Bilgisayar Ağları) unit:

- Task 1 (Ethernet Cable) ➡️ MEB BT.5.3.1.3 / BT.6.3.1.1: Lists connection technologies used in computer networks and explains necessary components (Modem, cables, network cards, etc.).
- Task 2 (LAN Subnet IP) ➡️ MEB BT.5.3.1.2 / BT.6.3.1.3: Explains basic network concepts and discusses differences in network types and sizes (LAN/WLAN environments).
- Tasks 3 & 4 (Gateway & DNS) ➡️ MEB BT.5.3.1.1: Explores the journey of data/information across networks (Understanding how local data routes out to the global internet via gateway and resolves via DNS).

### Pedagogical Foundations
- Instructional Scaffolding: The gameplay follows a structured, progressive order (from physical connectivity to logical domain name resolution). Players cannot move to advanced configurations without mastering the prerequisites, reducing cognitive overload.
- Constructivism (Learning by Doing): Instead of memorizing definitions, students actively construct mental models of network topologies by manipulating elements within the virtual isometric environment.
- Gamification in Education: Immediate visual feedback, a safe-to-fail room design, and objective-based challenges increase student intrinsic motivation while sharpening algorithmic problem-solving skills.



## 🎮 Prototype Scope & Gameplay

Players navigate a single isometric room to complete a step-by-step basic network setup through four short, interactive challenges:

1. Physical Connectivity: Connecting the Ethernet cable to the modem to establish the initial physical link.
2. Local Addressing: Selecting the correct IP address within the same Local Area Network (LAN) subnet.
3. Gateway Configuration: Choosing the proper Default Gateway to enable external internet routing.
4. Name Resolution: Selecting the correct DNS server to translate a domain name (website URL) into its corresponding IP address.



## 🚀 Getting Started & Execution

Follow these steps to fetch dependencies and run the networking prototype locally on your machine.

### Prerequisites
Before running the project, ensure you have the Flutter SDK installed. You can verify your environment configuration by running:
```bash
flutter doctor

2. Launch the Application
Choose your target platform to run the networking prototype:

Standard Run (Mobile / Desktop / Simulator):
flutter run
* **Web Run (Hosted on a specific port):**
  ```bash
  flutter run -d web-server --web-port 8080

Code Analysis
Check the project for any potential linting issues or errors:
flutter analyze

Run Tests
Execute the unit and widget test suites:
flutter test

Production Web Build
Compile the application into static assets optimized for web hosting:
flutter build web


## Asset Standarti

Ilk prototip cizim tabanli placeholder componentlerle calisir. Final PNG assetleri hazirlandiginda su klasorlere ayni isimlerle eklenmelidir:

```txt
assets/images/
assets/audio/
```

Gorsel assetler icin standart:

```txt
PNG
Transparent background
512x512 veya 1024x1024 kaynak boyut
Ayni izometrik kamera acisi
Ayni isik yonu
Pastel renk paleti
Net, okunabilir port ve cihaz detaylari
```

Beklenen gorseller:

```txt
room_tiles.png
wall_tiles.png
desk.png
computer.png
modem.png
ethernet_cable.png
character_idle.png
port_glow.png
success_sparkle.png
```

Beklenen sesler:

```txt
success.wav
click.wav
```

## Kod Yapisi

```txt
lib/main.dart
lib/game/network_game.dart
lib/game/components/
lib/game/levels/
lib/game/assets/
lib/ui/
```

Level verisi `lib/game/levels/` icinde tutulur. Sahne objeleri, kablo hedefi, secim hedefleri ve egitim metinleri level verisinden okunur.

## Planning Documents

Detailed English planning documents are available in:

```txt
docs/
```

Start with:

```txt
docs/PRODUCT_VISION.md
docs/GAME_DESIGN.md
docs/TECHNICAL_PLAN.md
docs/SQLITE_DATA_MODEL.md
docs/ROADMAP.md
```
