# NetQues - Ağ Temelleri Eğitim Oyunu

Team Information

Team Number: TEAM-5

Developers:
Emre Çoban
Muazzez Şen
Esranur Aydın
Nurullah Dağhan
İdris Baki Uzun

NetQues, Flutter ve Flame ile geliştirilen kısa bir ağ temelleri eğitim oyunudur. Proje, ortaokul/lise başlangıç seviyesindeki öğrencilerin kablo, IP adresi, gateway, DNS, subnet maskesi, DHCP ve firewall gibi temel ağ kavramlarını oyun içinde deneyerek öğrenmesini hedefler.

Uygulama izometrik bir oda sahnesi üzerinde ilerler. Oyuncu önce Ethernet kablosunu doğru porta bağlar, sonraki bölümlerde ise doğru ağ ayar kartlarını bilgisayara sürükleyip bırakır.

## Şu Ana Kadar Yapılanlar

- Flutter + Flame tabanlı oynanabilir oyun akışı kuruldu.
- NetQues uygulama kabuğu, giriş ekranı ve oyun ekranı eklendi.
- Email/şifre ile kayıt ve giriş sistemi hazırlandı.
- Şifreler SQLite tarafında SHA-256 hash olarak saklanıyor.
- Giriş durumu ve kullanıcı bilgisi SharedPreferences ile korunuyor.
- 7 bölümlük ağ eğitimi akışı tamamlandı.
- Level kilidi, tamamlanma durumu, son oynanan bölüm, deneme sayısı ve ipucu sayısı kaydediliyor.
- Mobil odaklı yatay/dikey yerleşim destekleniyor.
- Türkçe ve İngilizce dil seçimi eklendi.
- Profil ekranı, avatar seçimi, görevler, rozetler ve günlük seri takibi eklendi.
- SQLite progress repository ve web için bellek içi progress repository hazırlandı.
- Model, progress controller, SQLite repository, profil özeti ve streak davranışları için testler eklendi.

## Oynanış

Oyun şu bölümlerden oluşur:

1. Ethernet Bağlantısı: Bilgisayarı modeme kabloyla bağlama.
2. IP Adresi: Aynı yerel ağdaki doğru IP adresini seçme.
3. Varsayılan Ağ Geçidi: İnternete çıkış için modem/router adresini seçme.
4. DNS Sunucusu: Alan adını IP adresine çeviren servisi seçme.
5. Alt Ağ Maskesi: Yerel ağ sınırını doğru subnet maskesiyle belirleme.
6. DHCP Servisi: IP, maske, gateway ve DNS ayarlarını otomatik dağıtan servisi seçme.
7. Güvenlik Duvarı: Web erişimi için doğru trafik kuralını seçme.

Her bölüm tamamlandığında bir sonraki bölüm açılır. Kilitli, açık ve tamamlanmış bölümler level seçim panelinde görünür. Final bölümden sonra oyuncu başa dönebilir, çıkış yapabilir veya uygulamayı kapatabilir.

## Temel Özellikler

- Sürükle-bırak kablo bağlama mekaniği.
- Sürükle-bırak seçim kartları.
- Başarı paneli, öğrenilen konu ve sonraki adım metinleri.
- İpuçları ve hatalı deneme geri bildirimi.
- Kullanıcı bazlı ilerleme kaydı.
- Profil özeti: tamamlanan bölümler, görevler, rozetler ve seri bilgisi.
- Avatar seçimi.
- Türkçe/İngilizce lokalizasyon.
- Desktop, mobil ve web hedefleri için Flutter proje yapısı.

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
lib/main.dart                  # App shell, auth wrapper, level seçimi ve oyun ekranı
lib/data/                      # Auth, SQLite progress, profil/streak ve controller katmanı
lib/game/network_game.dart     # Flame oyun sahnesi, sürükle-bırak ve level akışı
lib/game/levels/               # Dart tabanlı 7 level verisi
lib/game/components/           # Kodla çizilen oyun componentleri
lib/l10n/                      # Türkçe/İngilizce metinler ve lokalize level kopyaları
lib/ui/                        # Login, HUD, profil, level seçimi ve başarı panelleri
test/                          # Model, repository, controller, layout ve profil testleri
assets/images/                 # Görsel asset alanı
assets/audio/                  # Ses asset alanı
docs/                          # Ürün, teknik plan ve roadmap dokümanları
```

## Veri Saklama

- `users` tablosu kullanıcı email ve şifre hash bilgisini tutar.
- `level_progress` tablosu kullanıcı bazlı bölüm kilidi, tamamlanma, deneme ve ipucu verilerini tutar.
- `app_state` tablosu son oynanan bölüm gibi uygulama durumlarını saklar.
- Web hedefinde progress için geçici bellek içi repository kullanılır.
- Profil avatar seçimi ve günlük seri bilgisi SharedPreferences ile saklanır.

## Dokümanlar

```txt
docs/PRODUCT_VISION.md       # Ürün vizyonu
docs/GAME_DESIGN.md          # Oyun tasarımı ve level mantığı
docs/TECHNICAL_PLAN.md       # Teknik mimari ve geliştirme planı
docs/SQLITE_DATA_MODEL.md    # SQLite veri modeli
docs/ROADMAP.md              # Geliştirme yol haritası
LOGIN_SYSTEM_README.md       # Login sistemi rehberi
```

## Mevcut Sınırlar ve Sonraki Adımlar

- Final PNG/WAV assetleri henüz üretilmedi; sahne ve efektler kodla çizilen componentlerle çalışıyor.
- Web tarafında SQLite yerine bellek içi progress kullanıldığı için web progress kalıcı değil.
- Login sistemi demo seviyesinde; production için backend, daha güçlü şifreleme/parola saklama ve şifre sıfırlama akışı eklenmeli.
- Dokümanlardaki plan dosyaları, uygulama büyüdükçe yeni özelliklere göre tekrar güncellenmeli.
