# 🏔️ PakTours — Pakistan Tourism Flutter App
Developers: Sardar Mehtab, Muhammad Danyal and Muskan Khan


A full-featured Flutter tourism application for exploring and booking trips across Pakistan.

---

## 📱 Features

### User Side
- ✅ Splash screen with animation
- ✅ Login & Register screens
- ✅ Explore all destinations with search & region filter
- ✅ Trip cards with images, price, difficulty, activity badges
- ✅ Trip Detail Screen with 4 tabs:
  - **Overview** — description, highlights, inclusions, trip schedule
  - **Route** — step-by-step route itinerary
  - **Activities** — hiking, trekking, bonfire, BBQ, boating, etc.
  - **Meals** — breakfast, lunch, dinner, BBQ plan
- ✅ Booking flow (select persons → payment method → payment details)
- ✅ 4 Payment Options:
  - 💚 Easypaisa (number shown)
  - ❤️ JazzCash (number shown)
  - 🔵 Bank Transfer (IBAN shown)
  - 🟡 Payment on Spot (cash)
- ✅ Booking Confirmation with trip schedule & departure info
- ✅ My Trips / Bookings tab
- ✅ Profile screen with stats

### Admin Side
- ✅ Admin login (admin@paktours.pk / admin123)
- ✅ Manage Trips — view all, toggle active/inactive, delete
- ✅ Add New Trip form (bottom sheet)
- ✅ All Bookings view
- ✅ Stats dashboard — revenue, total bookings, trip fill rates

---

## 🚀 Setup & Run

### Prerequisites
- Flutter SDK 3.x+
- Dart 3.x+
- Android Studio / VS Code

### Steps

```bash
# 1. Navigate to project folder
cd pakistan_tourism_app

# 2. Get dependencies
flutter pub get

# 3. Run on device/emulator
flutter run
```

---

## 🔑 Demo Credentials

| Role  | Email                  | Password |
|-------|------------------------|----------|
| Admin | admin@paktours.pk      | admin123 |
| User  | ali@example.com        | user123  |

Or **Register** a new account from the login screen.

---

## 🗺️ Included Destinations

| Trip | Location | Price |
|------|----------|-------|
| Mushkpuri Peak | Nathiagali, KPK | Rs 4,500 |
| Naran & Lake Saiful Muluk | Kaghan Valley, KPK | Rs 9,500 |
| Fairy Meadows & Nanga Parbat | Diamer, GB | Rs 18,500 |
| Neelum Valley & Sharda | Azad Kashmir | Rs 8,500 |
| Hunza Valley & Attabad Lake | Hunza, GB | Rs 24,500 |
| Swat Valley & Malam Jabba | Swat, KPK | Rs 5,500 |

---

## 🏗️ Architecture

```
lib/
└── main.dart          ← Single-file app (all screens + models + state)
    ├── Data Models    (TripDestination, Booking, AppUser, etc.)
    ├── AppState       (In-memory state management)
    ├── AppTheme       (Color palette, design tokens)
    ├── SplashScreen
    ├── LoginScreen
    ├── RegisterScreen
    ├── HomeScreen     (Explore + My Trips + Profile)
    ├── TripDetailScreen (4-tab detail view)
    ├── BookingScreen  (3-step booking flow)
    ├── BookingConfirmationScreen
    └── AdminDashboard (Trips + Bookings + Stats)
```

---

## 🔮 Future Enhancements
- Firebase Firestore for real database
- Firebase Auth for real authentication
- Push notifications for trip reminders
- Google Maps integration for routes
- Image gallery for each destination
- User reviews & ratings
- Trip chat group (WhatsApp integration)
- PDF ticket generation
- 
