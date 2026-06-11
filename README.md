# BTO3102 TEAM 5 NETQUES MOBILE APPLICATION DEVELOPMENT REPORT

## Project File

**Project Name:** NetQues  
**Project Type:** Mobile Educational Game  
**Technology Stack:** Flutter, Flame, Dart, SQLite, SharedPreferences  
**GitHub Repository:** Connected through the active project remote

## Team Information

**Team Number:** TEAM-5

**Team Members:**

Emre Çoban  
Muazzez Şen  
Esra Aydın  
Nurullah Dağhan  
İdris Baki Uzun

 **Project:** Computer Networks and Operating Systems Educational Game
 
 **Target Audience:** Middle school and early high school students who are beginning to learn basic computing concepts

---

## 1. Project Overview & Academic Background

This report encompasses the design, pedagogical framework, and software development processes of the NetQues mobile application, developed as a collaborative joint term project for the Computer Networks and Operating Systems courses within the Department of Computer Education and Instructional Technology (CEIT).

The theoretical and content foundation of the project is strictly built upon the core competencies of both academic curricula, focusing on two primary areas:

**Computer Networks: Ethernet connection, IP address, default gateway, DNS, subnet mask, DHCP, and firewall.**

**Operating Systems: Process, RAM, and file system management.**

NetQues transforms abstract, complex, and invisible technical concepts into small, playable, interactive learning tasks. Instead of presenting definitions via passive text, the platform utilizes an interactive isometric room scene, tactile game mechanics, structured hints, and immediate evaluation feedback. By interacting directly with visual assets such as cables, configuration cards, stars, and badges, students can connect abstract computing vocabulary with meaningful, concrete actions. Guided by progress tracking and a profile-based gamification ecosystem, the application stands as a comprehensive platform engineered to support middle school and early high school students through sustainable active learning.

---

## 2. Design Methodology: The ADDIE Model

NetQues was designed according to the ADDIE instructional design model: Analysis, Design, Development, Implementation, and Evaluation.

### 2.1. Analysis

- **Content Analysis:** Network and operating system concepts were separated into short, digestible learning steps. Each level focuses on one concept and one clear learning objective.
- **Target Audience Analysis:** The application is designed for students who may find abstract computing concepts difficult when explained only with text. Therefore, each topic is supported with interaction, visual feedback, and simple language.
- **Learning Problem:** Concepts such as gateway, DNS, process, and RAM are often invisible to beginners. NetQues makes these ideas concrete through visual metaphors and task-based interaction.

### 2.2. Design

- **Pedagogical & Conceptual Design:** The application leverages small-step learning paradigms integrated with immediate feedback mechanism loops. A primary focus is placed on transforming abstract computer science concepts into concrete, sensory representations (Piaget's concrete operational stage schemas). By interacting with spatial components in a virtual environment, invisible systems become fully visible and structural to the learner.
  
- **Gamification & Reinforcement Design (Skinner’s Operant Conditioning):** To sustain high learner motivation, a multi-tier reinforcement ecosystem consisting of stars, badges, daily streaks, and profile certificates is embedded. To satisfy the need for immediate positive reinforcement, correct actions instantly trigger dynamic multi-sensory feedback, including playful sound effects and an animated avatar jump mechanic that visually celebrates the user's success.
  
- **Interface & UX Design:** The interface is mobile-friendly and supports both portrait and landscape layouts natively. To prevent cognitive overload, the final UI was streamlined by removing non-essential auxiliary screens, focusing the user's attention entirely on the active learning simulation flow.

### 2.3. Development

- **Architecture & Framework:** The cross-platform application layer is programmed using the Flutter SDK and Dart, leveraging Object-Oriented Programming (OOP) principles to enforce a clean, maintainable, and reactive code architecture.
  
- **Game Engine Integration:** The interactive, tactile gameplay layers—including the isometric room environments, cable dragging mechanisms, and success animations—are powered by the Flame Engine, embedded directly within the Flutter widget tree.
  
- **Local Persistence:** SQLite stores users and level progress. SharedPreferences stores lightweight user preferences.
  
- **Audio & Multimedia Optimization:** To prevent runtime memory leaks, sound effects are optimized via audioplayers, and synchronized text-to-speech voice reading is processed natively through flutter_tts.
  
- **Localization Layer:** Native multilingual infrastructure provides full, contextual Turkish and English text and asset support across all interfaces and data models.
  
- **State Management:** Module completion flags, dynamic XP calculations, real-time visual color transitions, and character level advancements are handled entirely by Flutter's reactive state layer, ensuring seamless UI re-rendering.

### 2.4. Implementation

The current implementation is a playable prototype with login, module selection, level progression, profile tracking, audio settings, and two completed learning modules. Students can complete levels, unlock the next level, earn stars, and retry levels to improve their best star score.

### 2.5. Evaluation

-**In-App Data Analytics & Formative Assessment:** To natively measure instructional effectiveness, evaluation tools are integrated into the database level. The system tracks completion logs, total attempts, hint usage, daily streak metadata, and badge milestones.

-**Formative Assessment Feedback:** At the end of operational modules,  enabling a self-contained evaluation layer that measures the application's true impact on the learner's technical retention.

## 3. System Architecture and User Experience Flow

### 3.1. Authentication and Account Management

Users register and log in with an email and password. Passwords are stored as SHA-256 hashes in the local SQLite database. Login state, active user email, and display name are preserved with SharedPreferences.

### 3.2. Module Selection

After login, users arrive at the module selection screen. The current application includes:

1. **Network Basics**
2. **Operating System Basics**

Each module has its own level list, progress state, and educational context.

### 3.3. Gameplay Flow

The game uses a level-based structure:

1. The student reads the task instruction.
2. The student performs the required action.
3. If the answer is wrong, the system gives corrective feedback.
4. If the answer is correct, the success panel explains the learned concept.
5. The next level unlocks.
6. The student can replay a completed level to improve the star score.

### 3.4. Profile Page & Gamification

The profile page displays:

- Completed levels
- Total stars
- Daily streak
- Badges
- Tasks
- Certificate
- Avatar selection
- Character customization

Hair and outfit colors unlock through collected stars. This connects progress with a visible reward loop.

---

## 4. Current Learning Modules

### 4.1. Network Basics Module

The Network Basics module contains 7 levels:

1. **Ethernet Connection:** Connect the computer to the modem with a cable.
2. **IP Address:** Identify the device address on the network.
3. **Default Gateway:** Select the exit point to the internet.
4. **DNS Server:** Recognize the service that converts website names to IP addresses.
5. **Subnet Mask:** Understand the local network boundary.
6. **DHCP Service:** Identify the service that automatically distributes network settings.
7. **Firewall:** Choose the security rule that controls traffic.

### 4.2. Operating System Basics Module

The Operating System Basics module contains 3 levels:

1. **Process:** Identify a running program instance.
2. **RAM:** Select the temporary working memory.
3. **File System:** Recognize the structure that organizes persistent files and folders.

---

## 5. Current Feature Set

- Flutter + Flame interactive game scene
- Email/password login and registration
- Module selection screen
- Network Basics module
- Operating System Basics module
- Cable connection mechanic
- Selection-card based tasks
- Hints and wrong-answer feedback
- Success panel with learning notes
- Star scoring system
- Star improvement through replay
- Profile page
- Avatar selection
- Character customization
- Daily streak tracking
- Tasks and badges
- Certificate screen
- Mini glossary
- Matching game
- Sound effects
- Voice reading synced with the active app language
- Turkish and English localization
- Mobile portrait and landscape layout support

---

## 6. Simplified or Removed Features

The final interface was simplified to keep the learning flow focused. The following features were removed from the active UI:

- Easy reading mode
- Separate voice reading language option
- High contrast mode
- Color-blind support
- Concept map
- Review mode
- Parent/teacher summary
- Matching cards

The matching game remains available as the active reinforcement activity.

---

## 7. Technical and Software Infrastructure

### 7.1. Main Code Structure

```txt
lib/main.dart                         # App shell, auth flow, module flow, game screen, settings
lib/data/                             # Auth, progress, preferences, profile, streak, and repositories
lib/game/network_game.dart            # Flame game scene and gameplay logic
lib/game/levels/                      # Network and operating system level data
lib/game/components/                  # Game scene components drawn in code
lib/l10n/app_localizations.dart       # Turkish/English strings and localized module lists
lib/ui/                               # Login, module selection, level selection, profile, success panels
assets/audio/                         # Sound effect assets
assets/images/                        # Image asset directory
test/                                 # Model, repository, controller, layout, and profile tests
```

### 7.2. Data Storage

NetQues uses local persistence:

- `network_cable_demo.db`: Stores user email and password hash data.
- `network_training.db`: Stores level progress, unlock state, completion, attempts, hint usage, best stars, retry state, and last played level.
- `SharedPreferences`: Stores login state, user display name, avatar, character customization, daily streak, and learning/audio preferences.

For the web target, progress is handled with an in-memory repository because SQLite is not used there.

### 7.3. Dependencies

- `flutter`
- `flame`
- `sqflite`
- `shared_preferences`
- `crypto`
- `audioplayers`
- `flutter_tts`
- `flutter_test`
- `sqflite_common_ffi`

---

## 8. How to Run

Install Flutter SDK, then run:

```bash
flutter doctor
flutter pub get
flutter run
```

To run as a web server:

```bash
flutter run -d web-server --web-port 8080
```

---

## 9. Validation Commands

The project can be checked with:

```bash
flutter analyze
flutter test
flutter build web
```

---

## 10. Current Limitations

- The login system is suitable for an educational prototype; a production version would require backend authentication and password reset flows.
- The web target uses temporary in-memory progress instead of persistent SQLite progress.
- Most scene visuals are drawn with code; a final production version could use custom illustration assets.

---

## 11. Conclusion

NetQues stands as a complete, pedagogically grounded educational mobile game prototype that successfully bridges the gap between complex computer science theories and active learning. Driven by the ADDIE framework and powered by Flutter and Flame, the application effectively demonstrates how Computer Networks and Operating Systems concepts can be transformed into accessible, highly engaging micro-learning tasks for young learners.
