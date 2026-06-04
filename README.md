# İzometrik Ağ Eğitimi Prototipi

Bu proje, Flutter ve Flame ile geliştirilen kısa bir ağ temelleri eğitim oyunudur. Hedef kullanıcılar ortaokul seviyesindeki öğrenciler olarak düşünülmüştür. Uygulama tek bir izometrik oda içinde dört temel ağ kavramını adım adım işler.

## Mevcut Oynanış

Oyun şu bölümleri içerir:

1. Ethernet bağlantısı: Bilgisayarı modeme kabloyla bağlama.
2. IP adresi: Aynı yerel ağdaki doğru IP adresini seçme.
3. Varsayılan ağ geçidi: İnternete çıkış için modem/router adresini seçme.
4. DNS sunucusu: Alan adını IP adresine çeviren servisi seçme.

Başarı sonrası bir sonraki bölüm açılır. Tamamlanan ve kilitli bölümler level seçim panelinde gösterilir. Kullanıcı ilerlemesi SQLite ile yerel olarak saklanır.

## Çalıştırma

Ön koşul olarak Flutter SDK kurulu olmalıdır.

```bash
flutter doctor
flutter pub get
flutter run
```

Web sunucusu olarak çalıştırmak için:

```bash
flutter run -d web-server --web-port 8080
```

## Doğrulama

```bash
flutter analyze
flutter test
flutter build web
```

## Kod Yapısı

```txt
lib/main.dart                  # App shell, level seçimi ve oyun ekranı
lib/data/                      # Level repository, SQLite progress, controller
lib/game/network_game.dart     # Flame oyun sahnesi ve etkileşimleri
lib/game/levels/               # Dart tabanlı level verileri
lib/game/components/           # Kodla çizilen sahne componentleri
lib/ui/                        # HUD, başarı paneli, seçim panelleri
test/                          # Model, progress ve controller testleri
```

## Asset Durumu

Bu MVP fazında görseller ve efektler kodla çizilen placeholder componentlerle çalışır. Final PNG/WAV asset üretimi bu faza dahil değildir. Asset klasörleri hazır tutulmuştur:

```txt
assets/images/
assets/audio/
```

Beklenen final görseller:

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

Beklenen final sesler:

```txt
success.wav
click.wav
```

## Plan Dokümanları

Ayrıntılı ürün ve teknik planlar `docs/` klasöründedir:

```txt
docs/PRODUCT_VISION.md
docs/GAME_DESIGN.md
docs/TECHNICAL_PLAN.md
docs/SQLITE_DATA_MODEL.md
docs/ROADMAP.md
```
