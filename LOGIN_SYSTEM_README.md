# Login Sistemi - Uygulama Rehberi

Bu dosya NetQues içindeki mevcut login, kayıt ve oturum akışını özetler.

## Yapılan Değişiklikler

### 1. Bağımlılıklar

`pubspec.yaml` içinde login ve veri saklama için şu paketler kullanılıyor:

```yaml
shared_preferences: ^2.2.2
sqflite: ^2.4.2
crypto: ^3.0.3
```

- `shared_preferences`: Oturum durumu, aktif kullanıcı, avatar ve seri bilgisi için.
- `sqflite`: Kullanıcı tablosu ve progress verisi için.
- `crypto`: Şifreleri SHA-256 hash'e çevirmek için.

### 2. AuthService

Dosya: `lib/data/auth_service.dart`

Mevcut özellikler:

- Email + şifre ile kayıt.
- Email + şifre ile giriş.
- Email format kontrolü.
- Minimum 4 karakter şifre kontrolü.
- Duplicate email kontrolü SQLite unique constraint üzerinden yapılıyor.
- Şifreler `password_hash` alanına SHA-256 hash olarak kaydediliyor.
- Giriş durumu SharedPreferences ile takip ediliyor.
- Çıkış işlemi aktif oturum bilgisini temizliyor.

### 3. DatabaseHelper

Dosya: `lib/data/database_helper.dart`

`network_cable_demo.db` içinde şu tabloyu oluşturur:

```sql
CREATE TABLE users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  email TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
)
```

### 4. LoginScreen

Dosya: `lib/ui/login_screen.dart`

Mevcut özellikler:

- Giriş modu.
- Hesap oluşturma modu.
- Şifre göster/gizle.
- Loading durumu.
- Form validasyonu.
- Hata ve başarı mesajları.
- Türkçe/İngilizce metin desteği.

### 5. Main.dart Akışı

Dosya: `lib/main.dart`

- `AuthWrapper` açılışta oturum durumunu kontrol eder.
- Oturum yoksa `LoginScreen` gösterilir.
- Giriş başarılıysa `GameScreen` açılır.
- Oyun ekranından çıkış yapıldığında oturum kapatılır ve login ekranına dönülür.
- Dil seçimi login ve oyun ekranı arasında korunur.

## Uygulama Akışı

```txt
App başlangıcı
  -> AuthWrapper
    -> Oturum yoksa LoginScreen
      -> Giriş yap veya hesap oluştur
      -> Başarılı giriş sonrası GameScreen
    -> Oturum varsa GameScreen
      -> Çıkış yapıldığında LoginScreen
```

## Kurulum ve Çalıştırma

```bash
flutter pub get
flutter run
```

İlk kullanımda önce "Hesap Oluştur" ile yeni kullanıcı açılır, ardından aynı email/şifre ile giriş yapılır.

## Güvenlik Notları

- Şifreler plain text saklanmıyor; SHA-256 hash olarak kaydediliyor.
- Bu yapı demo/prototip için yeterli kabul edilebilir.
- Production ortamında salt'lı ve yavaş parola hashleme algoritmaları kullanılmalı.
- Backend API, parola sıfırlama, rate limit ve hesap doğrulama akışları eklenmeli.
- SharedPreferences oturum takibi için pratik olsa da hassas token saklama gerektiren production yapılarında daha güvenli depolama tercih edilmeli.

## Gelecek İyileştirmeler

- Salt'lı bcrypt/argon2 tabanlı parola hashleme.
- Backend API entegrasyonu.
- Google/Apple login.
- Şifre sıfırlama.
- Email doğrulama.
- Öğrenci/öğretmen rolleri.
- Kullanıcıya bağlı bulut senkronizasyonu.
