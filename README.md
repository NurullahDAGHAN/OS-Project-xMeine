# Network Cable Demo

Flutter + Flame ile hazirlanan tek odali ag egitimi prototipi.

## Prototip Kapsami

Oyuncu izometrik odada temel ag kurulumunu adim adim tamamlar. Prototipte dort kisa bolum vardir:

```txt
1. Ethernet kablosunu modeme baglama
2. Ayni yerel ag icin dogru IP adresini secme
3. Internete cikis icin varsayilan ag gecidini secme
4. Site adini IP adresine cevirmek icin DNS sunucusunu secme
```

## Calistirma

```bash
flutter pub get
flutter run
```

Web icin:

```bash
flutter run -d web-server --web-port 8080
```

## Dogrulama

```bash
flutter analyze
flutter test
flutter build web
```

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
