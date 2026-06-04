# Login Sistemi - Uygulama Rehberi

## ✅ Yapılan Değişiklikler

### 1. **Bağımlılıklar** (`pubspec.yaml`)
```yaml
shared_preferences: ^2.2.2
```
- Local cihazda giriş durumunu tutmak için eklendi

### 2. **AuthService** (`lib/data/auth_service.dart`)
Özellikler:
- ✅ Email + Şifre ile kayıt
- ✅ Email + Şifre ile giriş
- ✅ Email doğrulaması
- ✅ Minimum 4 karakter şifre
- ✅ Duplicate email kontrolü
- ✅ SharedPreferences ile veri saklama
- ✅ Giriş durumu takibi
- ✅ Çıkış işlemi

### 3. **LoginScreen** (`lib/ui/login_screen.dart`)
Özellikler:
- 🎨 Modern UI (Material Design 3)
- ✅ Giriş modu
- ✅ Kayıt modu
- ✅ Şifre göster/gizle
- ✅ Hata mesajları
- ✅ Loading durumu
- ✅ Form validasyonu

### 4. **Main.dart Güncellemeleri**
Değişiklikler:
- `AuthWrapper` widget'ı eklendi (giriş durumunu yönetir)
- Login başarılı → GameScreen göster
- Çıkış → LoginScreen göster
- GameScreen'e Çıkış butonu eklendi (AppBar'da)

## 🔄 Akış

```
App Başlangıcı
    ↓
AuthWrapper (giriş durumunu kontrol)
    ├─ Giriş yapılı değilse → LoginScreen
    │   ├─ Giriş Yap
    │   ├─ Kayıt Ol
    │   └─ Giriş Başarı → GameScreen
    │
    └─ Giriş yapılı ise → GameScreen
        └─ Çıkış Yap → LoginScreen
```

## 📝 Test Kullanıcıları

Şu adresleri test edebilirsiniz:
- **Email:** test@example.com
- **Şifre:** 1234

## ⚙️ Kurulum Adımları

1. Bağımlılıkları kur:
```bash
flutter pub get
```

2. Uygulamayı çalıştır:
```bash
flutter run
```

3. İlk kez kullanırken "Hesap Oluştur" tıkla

## 🔐 Güvenlik Notları

- ⚠️ Şu anda şifreler plain text olarak kaydediliyor (demo amaçlı)
- 🔒 Production'da şifreleme eklenmeli
- 🔒 Backend API ile entegrasyon yapılmalı

## 🎯 Gelecek İyileştirmeler

- [ ] Şifre hashleme (bcrypt/argon2)
- [ ] Backend API entegrasyonu
- [ ] Google/Apple login
- [ ] Şifre sıfırlama
- [ ] İki aşamalı kimlik doğrulama
- [ ] Öğrenci/Öğretmen rolleri
