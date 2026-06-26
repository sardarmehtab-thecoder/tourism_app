import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const PakTourismApp());
}

// ─────────────────────────────────────────────
//  DATA MODELS
// ─────────────────────────────────────────────

class TripDestination {
  final String id;
  final String name;
  final String location;
  final String region;
  final String heroImage;
  final String description;
  final String duration;
  final String departureCity;
  final String departureSpot;
  final DateTime departureDate;
  final DateTime returnDate;
  final String departureTime;
  final double pricePerPerson;
  final int totalSeats;
  int bookedSeats;
  final List<String> routes;
  final List<String> inclusions;
  final List<ActivityItem> activities;
  final List<MealPlan> meals;
  final List<String> highlights;
  final String difficulty;
  final String maxAltitude;
  bool isActive;

  TripDestination({
    required this.id,
    required this.name,
    required this.location,
    required this.region,
    required this.heroImage,
    required this.description,
    required this.duration,
    required this.departureCity,
    required this.departureSpot,
    required this.departureDate,
    required this.returnDate,
    required this.departureTime,
    required this.pricePerPerson,
    required this.totalSeats,
    this.bookedSeats = 0,
    required this.routes,
    required this.inclusions,
    required this.activities,
    required this.meals,
    required this.highlights,
    required this.difficulty,
    this.maxAltitude = 'N/A',
    this.isActive = true,
  });

  int get availableSeats => totalSeats - bookedSeats;
}

class ActivityItem {
  final String name;
  final IconData icon;
  final String description;
  ActivityItem(
      {required this.name, required this.icon, required this.description});
}

class MealPlan {
  final String type; // Breakfast, Lunch, Dinner, BBQ
  final String description;
  final IconData icon;
  MealPlan({required this.type, required this.description, required this.icon});
}

class AppUser {
  final String id;
  final String name;
  final String email;
  final String phone;
  final bool isAdmin;
  List<Booking> bookings;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.isAdmin = false,
    this.bookings = const [],
  });
}

class Booking {
  final String bookingId;
  final String tripId;
  final String tripName;
  final int persons;
  final double totalAmount;
  final String paymentMethod;
  final DateTime bookedOn;
  String paymentStatus;

  Booking({
    required this.bookingId,
    required this.tripId,
    required this.tripName,
    required this.persons,
    required this.totalAmount,
    required this.paymentMethod,
    required this.bookedOn,
    this.paymentStatus = 'Pending',
  });
}

// ─────────────────────────────────────────────
//  APP STATE (simple in-memory state)
// ─────────────────────────────────────────────

class AppState {
  static AppUser? currentUser;
  static final List<AppUser> users = [
    AppUser(
      id: 'admin_01',
      name: 'Admin',
      email: 'admin@paktours.pk',
      phone: '0300-0000000',
      isAdmin: true,
    ),
    AppUser(
      id: 'user_01',
      name: 'Ali Hassan',
      email: 'ali@example.com',
      phone: '0321-1234567',
      bookings: [],
    ),
  ];

  static List<TripDestination> trips = [
    TripDestination(
      id: 't1',
      name: 'Mushkpuri Peak',
      location: 'Nathiagali, Abbottabad',
      region: 'KPK',
      heroImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3e/Mushkpuri_summit.jpg/1280px-Mushkpuri_summit.jpg',
      description:
          'Mushkpuri is the highest peak in the Galyat range at 9,234 ft. A stunning trek through dense forests of pine and oak, offering breathtaking panoramic views of the Kaghan Valley and Himalayan ranges.',
      duration: '2 Days / 1 Night',
      departureCity: 'Abbottabad',
      departureSpot: 'Abbottabad Bus Stand, Near Imambargah Chowk',
      departureDate: DateTime(2026, 7, 5, 5, 0),
      returnDate: DateTime(2026, 7, 6, 18, 0),
      departureTime: '5:00 AM',
      pricePerPerson: 4500,
      totalSeats: 30,
      bookedSeats: 12,
      routes: [
        '🚌 Abbottabad → Nathiagali (2 hrs via Dunga Gali road)',
        '🥾 Nathiagali Bazaar → Mushkpuri Trailhead (15 min walk)',
        '🏔️ Trailhead → Mushkpuri Summit (3.5 km, ~3 hrs ascent)',
        '⛺ Summit Camp → Overnight stay',
        '🌄 Sunrise viewing point (optional early morning)',
        '🔽 Summit → Base (2.5 hrs descent)',
        '🚌 Nathiagali → Abbottabad (return)',
      ],
      inclusions: [
        'Transport (AC Coach both ways)',
        'Accommodation (Camp / Guest House)',
        'Breakfast Day 2',
        'BBQ Dinner Night 1',
        'Bonfire',
        'Trek Guide',
        'Safety Equipment',
        'Photography spots assistance',
      ],
      activities: [
        ActivityItem(
            name: 'Hiking',
            icon: Icons.hiking,
            description: '3.5 km trek to 9,234 ft summit'),
        ActivityItem(
            name: 'Bonfire',
            icon: Icons.local_fire_department,
            description: 'Night bonfire with music under the stars'),
        ActivityItem(
            name: 'BBQ',
            icon: Icons.outdoor_grill,
            description: 'Traditional BBQ dinner at camp'),
        ActivityItem(
            name: 'Photography',
            icon: Icons.camera_alt,
            description: 'Sunrise & valley panorama shoots'),
        ActivityItem(
            name: 'Bird Watching',
            icon: Icons.flutter_dash,
            description: 'Rare Himalayan bird species spotting'),
      ],
      meals: [
        MealPlan(
            type: 'BBQ Dinner',
            description: 'Tikka, Seekh Kabab, Naan, Salad',
            icon: Icons.outdoor_grill),
        MealPlan(
            type: 'Breakfast',
            description: 'Paratha, Egg, Tea, Juice',
            icon: Icons.free_breakfast),
      ],
      highlights: [
        '360° Himalayan panorama',
        'Dense pine forests',
        'Cloud-level experience',
        'Kaghan Valley views',
      ],
      difficulty: 'Moderate',
      maxAltitude: '9,234 ft (2,815 m)',
    ),
    TripDestination(
      id: 't2',
      name: 'Naran & Lake Saiful Muluk',
      location: 'Kaghan Valley, KPK',
      region: 'KPK',
      heroImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e3/Lake_Saiful_Muluk.jpg/1280px-Lake_Saiful_Muluk.jpg',
      description:
          'Experience the magical Naran valley with the legendary Lake Saiful Muluk — a fairy-tale alpine lake at 10,578 ft surrounded by snow-capped peaks. One of Pakistan\'s most iconic destinations.',
      duration: '3 Days / 2 Nights',
      departureCity: 'Abbottabad',
      departureSpot: 'Abbottabad Morr, Mansehra Road',
      departureDate: DateTime(2026, 7, 12, 4, 30),
      returnDate: DateTime(2026, 7, 14, 20, 0),
      departureTime: '4:30 AM',
      pricePerPerson: 9500,
      totalSeats: 25,
      bookedSeats: 8,
      routes: [
        '🚌 Abbottabad → Mansehra (45 min)',
        '🚌 Mansehra → Balakot (45 min)',
        '🚌 Balakot → Kaghan → Naran (4 hrs via scenic KKH)',
        '🏔️ Naran Bazaar → Lake Saiful Muluk (Jeep, 45 min)',
        '🚶 Lake trail walk (2 km circuit)',
        '⛺ Overnight in Naran (Hotel / Camp)',
        'Day 2: Babusar Top excursion (optional)',
        '🚌 Return journey Day 3',
      ],
      inclusions: [
        'Transport (AC Coach + Local Jeeps)',
        'Hotel / Guest House (2 nights)',
        'All Breakfasts (2)',
        'All Dinners (2)',
        'Lake Saiful Muluk jeep ride',
        'Guided lake tour',
        'Bonfire Night 1',
        'Travel insurance',
      ],
      activities: [
        ActivityItem(
            name: 'Trekking',
            icon: Icons.hiking,
            description: 'Lake circuit and valley treks'),
        ActivityItem(
            name: 'Boating',
            icon: Icons.rowing,
            description: 'Rowboat rides on Saiful Muluk'),
        ActivityItem(
            name: 'Bonfire',
            icon: Icons.local_fire_department,
            description: 'Starlit bonfire in Kaghan Valley'),
        ActivityItem(
            name: 'BBQ',
            icon: Icons.outdoor_grill,
            description: 'BBQ at lakeside camp'),
        ActivityItem(
            name: 'Photography',
            icon: Icons.camera_alt,
            description: 'Fairy Meadows style shoots'),
        ActivityItem(
            name: 'Fishing',
            icon: Icons.set_meal,
            description: 'Trout fishing in Kunhar River'),
      ],
      meals: [
        MealPlan(
            type: 'Breakfast (×2)',
            description: 'Halwa Puri, Egg, Chai',
            icon: Icons.free_breakfast),
        MealPlan(
            type: 'Dinner (×2)',
            description: 'Karahi, Naan, Salad, Dessert',
            icon: Icons.dinner_dining),
        MealPlan(
            type: 'BBQ Night',
            description: 'Full BBQ spread with tikka & boti',
            icon: Icons.outdoor_grill),
      ],
      highlights: [
        'Fairy-tale alpine lake',
        'Snow-capped Malika Parbat views',
        'Kunhar River rapids',
        'Babusar Top (13,690 ft)',
      ],
      difficulty: 'Easy-Moderate',
      maxAltitude: '13,690 ft (Babusar Top)',
    ),
    TripDestination(
      id: 't3',
      name: 'Fairy Meadows & Nanga Parbat',
      location: 'Diamer, Gilgit-Baltistan',
      region: 'GB',
      heroImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/55/Fairy_meadows.jpg/1280px-Fairy_meadows.jpg',
      description:
          'Fairy Meadows (Joot) is a stunning grassland at 10,827 ft offering the world\'s best base camp view of Nanga Parbat — the 9th highest mountain and the "Killer Mountain" at 8,126 m.',
      duration: '4 Days / 3 Nights',
      departureCity: 'Rawalpindi / Islamabad',
      departureSpot: 'Faizabad Interchange, Islamabad',
      departureDate: DateTime(2026, 7, 20, 3, 0),
      returnDate: DateTime(2026, 7, 23, 22, 0),
      departureTime: '3:00 AM',
      pricePerPerson: 18500,
      totalSeats: 20,
      bookedSeats: 5,
      routes: [
        '🚌 Islamabad → Chilas via KKH (8 hrs)',
        '🛻 Chilas → Raikot Bridge (1 hr)',
        '🚐 Raikot Bridge → Tato Village (dangerous jeep track, 1.5 hrs)',
        '🥾 Tato → Fairy Meadows (3 km hike, 2 hrs)',
        '⛺ Fairy Meadows Camp (2 nights)',
        '🏔️ Optional: Trek to Nanga Parbat Base Camp (6 hrs)',
        '🔽 Descent same route',
      ],
      inclusions: [
        'Transport (AC Coach + 4×4 Jeeps)',
        'Luxury Camping at Fairy Meadows',
        'All Meals (3 Breakfasts, 3 Lunches, 3 Dinners)',
        'Certified Mountain Guide',
        'Porter service',
        'Camping equipment',
        'Bonfire every night',
        'Medical kit',
        'Emergency satellite phone',
      ],
      activities: [
        ActivityItem(
            name: 'Base Camp Trek',
            icon: Icons.hiking,
            description: 'Trek to Nanga Parbat Base Camp'),
        ActivityItem(
            name: 'Camping',
            icon: Icons.cabin,
            description: 'Luxury glamping at 10,827 ft'),
        ActivityItem(
            name: 'Bonfire',
            icon: Icons.local_fire_department,
            description: 'Nightly bonfire under Milky Way'),
        ActivityItem(
            name: 'Stargazing',
            icon: Icons.star,
            description: 'Zero light pollution stargazing'),
        ActivityItem(
            name: 'Photography',
            icon: Icons.camera_alt,
            description: 'World-class mountain photography'),
        ActivityItem(
            name: 'Paragliding',
            icon: Icons.paragliding,
            description: 'Paragliding over the meadows'),
      ],
      meals: [
        MealPlan(
            type: 'Breakfast (×3)',
            description: 'Omelette, Paratha, Fruits, Tea',
            icon: Icons.free_breakfast),
        MealPlan(
            type: 'Lunch (×3)',
            description: 'Daal, Rice, Chapati, Lassi',
            icon: Icons.lunch_dining),
        MealPlan(
            type: 'Dinner (×3)',
            description: 'Mutton Karahi, Naan, Salad',
            icon: Icons.dinner_dining),
        MealPlan(
            type: 'BBQ Night',
            description: 'Grand BBQ: Chops, Kabab, Corn',
            icon: Icons.outdoor_grill),
      ],
      highlights: [
        'Nanga Parbat sunrise view',
        'World\'s 9th highest peak',
        'Milky Way stargazing',
        'KKH scenic drive',
      ],
      difficulty: 'Challenging',
      maxAltitude: '13,747 ft (Base Camp)',
    ),
    TripDestination(
      id: 't4',
      name: 'Neelum Valley & Sharda',
      location: 'Azad Kashmir',
      region: 'AJK',
      heroImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8e/Neelum_Valley_AJK.jpg/1280px-Neelum_Valley_AJK.jpg',
      description:
          'Neelum Valley is a breathtaking gem of Azad Kashmir, carved by the emerald Neelum River. Visit Sharda, ancient university ruins, crystal-clear streams, and the legendary Kel village.',
      duration: '3 Days / 2 Nights',
      departureCity: 'Muzaffarabad',
      departureSpot: 'Muzaffarabad City Center, Near AJK Bank',
      departureDate: DateTime(2026, 8, 2, 5, 0),
      returnDate: DateTime(2026, 8, 4, 19, 0),
      departureTime: '5:00 AM',
      pricePerPerson: 8500,
      totalSeats: 28,
      bookedSeats: 10,
      routes: [
        '🚌 Muzaffarabad → Athmuqam (3 hrs, Neelum Road)',
        '🚌 Athmuqam → Sharda (2 hrs)',
        '🚶 Sharda ruins exploration & temple visit',
        '🚌 Sharda → Kel (1.5 hrs)',
        '🥾 Kel → Arang Kel (aerial chairlift or 1.5 hr hike)',
        '⛺ Overnight in Kel (Camp/Guest House)',
        '🔽 Return journey Day 3',
      ],
      inclusions: [
        'Transport (Coaster both ways)',
        'Accommodation (2 nights)',
        'Breakfast (×2) + Dinner (×2)',
        'Arang Kel chairlift / trek',
        'Local guide',
        'Bonfire at riverside',
        'BBQ dinner',
      ],
      activities: [
        ActivityItem(
            name: 'River Crossing',
            icon: Icons.water,
            description: 'Swing bridge & stream crossings'),
        ActivityItem(
            name: 'Trekking',
            icon: Icons.hiking,
            description: 'Kel to Arang Kel mountain hike'),
        ActivityItem(
            name: 'Bonfire',
            icon: Icons.local_fire_department,
            description: 'Riverside bonfire under stars'),
        ActivityItem(
            name: 'BBQ',
            icon: Icons.outdoor_grill,
            description: 'BBQ by the Neelum River'),
        ActivityItem(
            name: 'Swimming',
            icon: Icons.pool,
            description: 'Natural stream swimming (summer)'),
        ActivityItem(
            name: 'Cultural Tour',
            icon: Icons.museum,
            description: 'Sharda ancient university ruins'),
      ],
      meals: [
        MealPlan(
            type: 'Breakfast (×2)',
            description: 'Paratha, Desi Ghee, Chai',
            icon: Icons.free_breakfast),
        MealPlan(
            type: 'BBQ Dinner',
            description: 'Riverside BBQ with tikka',
            icon: Icons.outdoor_grill),
        MealPlan(
            type: 'Dinner',
            description: 'Traditional Kashmiri Wazwan',
            icon: Icons.dinner_dining),
      ],
      highlights: [
        'Neelum River emerald waters',
        'Arang Kel floating village',
        'Ancient Sharda University',
        'AJK mountain villages',
      ],
      difficulty: 'Easy',
      maxAltitude: '8,366 ft (Arang Kel)',
    ),
    TripDestination(
      id: 't5',
      name: 'Hunza Valley & Attabad Lake',
      location: 'Hunza, Gilgit-Baltistan',
      region: 'GB',
      heroImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e9/Attabad_Lake.jpg/1280px-Attabad_Lake.jpg',
      description:
          'Hunza Valley — the paradise on earth. Visit the turquoise Attabad Lake, ancient Baltit Fort, Karimabad bazaar, and Eagle\'s Nest viewpoint with Rakaposhi (7,788 m) in full glory.',
      duration: '5 Days / 4 Nights',
      departureCity: 'Islamabad',
      departureSpot: 'Pak-China Friendship Centre, Islamabad',
      departureDate: DateTime(2026, 8, 10, 2, 30),
      returnDate: DateTime(2026, 8, 14, 23, 0),
      departureTime: '2:30 AM',
      pricePerPerson: 24500,
      totalSeats: 22,
      bookedSeats: 3,
      routes: [
        '🚌 Islamabad → Gilgit via KKH (12 hrs)',
        '🚌 Gilgit → Hunza / Karimabad (2 hrs)',
        '🚤 Attabad Lake boat ride',
        '🏰 Baltit Fort & Altit Fort tour',
        '🥾 Eagle\'s Nest sunset hike',
        '🚌 Hunza → Khunjerab Pass (3 hrs, 15,397 ft)',
        '🔽 Return to Islamabad Day 5',
      ],
      inclusions: [
        'Transport (AC Tourist Coach)',
        'Hotel (4 nights, 3-star)',
        'All Breakfasts & Dinners',
        'Attabad Lake boat ride',
        'Baltit Fort entry',
        'Khunjerab Pass permit',
        'Local Hunzai guide',
        'BBQ at lakeshore',
        'Travel insurance',
      ],
      activities: [
        ActivityItem(
            name: 'Boating',
            icon: Icons.rowing,
            description: 'Turquoise Attabad Lake boat tour'),
        ActivityItem(
            name: 'Fort Tour',
            icon: Icons.fort,
            description: 'Baltit & Altit fort exploration'),
        ActivityItem(
            name: 'Hiking',
            icon: Icons.hiking,
            description: 'Eagle\'s Nest sunset hike'),
        ActivityItem(
            name: 'BBQ',
            icon: Icons.outdoor_grill,
            description: 'Lakeshore BBQ party'),
        ActivityItem(
            name: 'Cultural Tour',
            icon: Icons.museum,
            description: 'Hunza culture & heritage'),
        ActivityItem(
            name: 'Photography',
            icon: Icons.camera_alt,
            description: 'Rakaposhi & Karakoram shoots'),
      ],
      meals: [
        MealPlan(
            type: 'Breakfast (×4)',
            description: 'Local Hunzai breakfast spread',
            icon: Icons.free_breakfast),
        MealPlan(
            type: 'Dinner (×4)',
            description: 'Traditional GB cuisine',
            icon: Icons.dinner_dining),
        MealPlan(
            type: 'BBQ Night',
            description: 'Lakeshore BBQ extravaganza',
            icon: Icons.outdoor_grill),
      ],
      highlights: [
        'Turquoise Attabad Lake',
        'Rakaposhi 7,788 m view',
        'Khunjerab Pass (China border)',
        'Ancient Silk Road route',
      ],
      difficulty: 'Easy',
      maxAltitude: '15,397 ft (Khunjerab Pass)',
    ),
    TripDestination(
      id: 't6',
      name: 'Swat Valley & Malam Jabba',
      location: 'Swat, KPK',
      region: 'KPK',
      heroImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c3/Malam_Jabba_ski_resort.jpg/1280px-Malam_Jabba_ski_resort.jpg',
      description:
          'The Switzerland of Pakistan! Swat offers lush green valleys, the Swat River, Buddhist ruins, and Malam Jabba ski resort. Perfect for adventure and cultural tourism combined.',
      duration: '2 Days / 1 Night',
      departureCity: 'Peshawar',
      departureSpot: 'Peshawar Qissa Khwani Bazaar Bus Stand',
      departureDate: DateTime(2026, 7, 26, 6, 0),
      returnDate: DateTime(2026, 7, 27, 20, 0),
      departureTime: '6:00 AM',
      pricePerPerson: 5500,
      totalSeats: 35,
      bookedSeats: 15,
      routes: [
        '🚌 Peshawar → Mingora, Swat (3 hrs via M-1)',
        '🚌 Mingora → Fizagat Park (30 min)',
        '🚌 Mingora → Malam Jabba (2 hrs)',
        '🎿 Malam Jabba resort activities',
        '🏰 Butkara Stupa & Buddhist ruins',
        '⛺ Overnight in Mingora or Malam Jabba',
        '🔽 Return Day 2',
      ],
      inclusions: [
        'Transport (AC Coach)',
        'Hotel / Resort (1 night)',
        'Breakfast Day 2',
        'BBQ Dinner',
        'Chairlift ride (Malam Jabba)',
        'Buddhist ruins guide',
        'Bonfire',
      ],
      activities: [
        ActivityItem(
            name: 'Chairlift',
            icon: Icons.cable,
            description: 'Malam Jabba chairlift experience'),
        ActivityItem(
            name: 'Trekking',
            icon: Icons.hiking,
            description: 'Forest trails around Malam Jabba'),
        ActivityItem(
            name: 'BBQ',
            icon: Icons.outdoor_grill,
            description: 'BBQ dinner in the valley'),
        ActivityItem(
            name: 'Bonfire',
            icon: Icons.local_fire_department,
            description: 'Nightly bonfire in the forest'),
        ActivityItem(
            name: 'Cultural Tour',
            icon: Icons.museum,
            description: 'Gandhara & Buddhist heritage'),
        ActivityItem(
            name: 'River Side',
            icon: Icons.water,
            description: 'Swat River leisure time'),
      ],
      meals: [
        MealPlan(
            type: 'BBQ Dinner',
            description: 'Full BBQ spread — tikka, kabab, corn',
            icon: Icons.outdoor_grill),
        MealPlan(
            type: 'Breakfast',
            description: 'Hotel breakfast: paratha, egg, chai',
            icon: Icons.free_breakfast),
      ],
      highlights: [
        'Switzerland of Pakistan',
        'Buddhist heritage sites',
        'Malam Jabba ski resort',
        'Swat River scenery',
      ],
      difficulty: 'Easy',
      maxAltitude: '8,858 ft (Malam Jabba)',
    ),
  ];

  static List<Booking> allBookings = [];

  static final FirebaseAuth _auth = FirebaseAuth.instance;

static Future<String?> loginWithFirebase(String email, String password) async {
  try {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    // Check if admin (hardcoded admin email check)
    final isAdmin = email == 'admin@paktours.pk';
    currentUser = AppUser(
      id: credential.user!.uid,
      name: credential.user!.displayName ?? (isAdmin ? 'Admin' : email.split('@')[0]),
      email: email,
      phone: credential.user!.phoneNumber ?? '',
      isAdmin: isAdmin,
      bookings: [],
    );
    return null; // null means success
  } on FirebaseAuthException catch (e) {
    return e.message ?? 'Login failed';
  }
}

static Future<String?> registerWithFirebase(
    String name, String email, String phone, String password) async {
  try {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await credential.user!.updateDisplayName(name);
    currentUser = AppUser(
      id: credential.user!.uid,
      name: name,
      email: email,
      phone: phone,
      isAdmin: false,
      bookings: [],
    );
    return null; // null means success
  } on FirebaseAuthException catch (e) {
    return e.message ?? 'Registration failed';
  }
}
  static Future<void> logout() async {
  await _auth.signOut();
  currentUser = null;
}
  static Booking addBooking(
      TripDestination trip, int persons, String paymentMethod) {
    final booking = Booking(
      bookingId: 'BK${DateTime.now().millisecondsSinceEpoch}',
      tripId: trip.id,
      tripName: trip.name,
      persons: persons,
      totalAmount: trip.pricePerPerson * persons,
      paymentMethod: paymentMethod,
      bookedOn: DateTime.now(),
      paymentStatus: paymentMethod == 'Payment on Spot' ? 'Pay on Spot' : 'Pending',
    );
    trip.bookedSeats += persons;
    allBookings.add(booking);
    currentUser?.bookings = [...(currentUser?.bookings ?? []), booking];
    return booking;
  }
}

// ─────────────────────────────────────────────
//  THEME & CONSTANTS
// ─────────────────────────────────────────────

class AppTheme {
  static const Color primary = Color(0xFF1B6B4A); // Deep forest green
  static const Color primaryLight = Color(0xFF2D9A6B);
  static const Color accent = Color(0xFFE8A825); // Golden amber
  static const Color bgDark = Color(0xFF0F1F17); // Near-black forest
  static const Color surface = Color(0xFF1A2E22);
  static const Color cardBg = Color(0xFF243B2C);
  static const Color textPrimary = Color(0xFFF0EDE5);
  static const Color textSecondary = Color(0xFFB0C4B9);
  static const Color danger = Color(0xFFE05454);
  static const Color easyGreen = Color(0xFF4CAF50);
  static const Color moderateOrange = Color(0xFFFF9800);
  static const Color hardRed = Color(0xFFE53935);

  static Color difficultyColor(String d) {
    if (d.contains('Easy')) return easyGreen;
    if (d.contains('Moderate')) return moderateOrange;
    return hardRed;
  }
}

// ─────────────────────────────────────────────
//  MAIN APP
// ─────────────────────────────────────────────

class PakTourismApp extends StatelessWidget {
  const PakTourismApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PakTours',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppTheme.bgDark,
        primaryColor: AppTheme.primary,
        colorScheme: const ColorScheme.dark(
          primary: AppTheme.primary,
          secondary: AppTheme.accent,
          surface: AppTheme.surface,
        ),
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: AppTheme.bgDark,
          elevation: 0,
          titleTextStyle: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700),
          iconTheme: IconThemeData(color: AppTheme.textPrimary),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppTheme.cardBg,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.primaryLight)),
          labelStyle: const TextStyle(color: AppTheme.textSecondary),
          hintStyle: const TextStyle(color: AppTheme.textSecondary),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primary,
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

// ─────────────────────────────────────────────
//  SPLASH SCREEN
// ─────────────────────────────────────────────

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoCtrl;
  late Animation<double> _logoFade;
  late Animation<double> _logoScale;
  late AnimationController _textCtrl;
  late Animation<double> _textFade;

  @override
  void initState() {
    super.initState();
    _logoCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _logoFade = CurvedAnimation(parent: _logoCtrl, curve: Curves.easeIn);
    _logoScale = Tween<double>(begin: 0.7, end: 1.0)
        .animate(CurvedAnimation(parent: _logoCtrl, curve: Curves.elasticOut));

    _textCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _textFade = CurvedAnimation(parent: _textCtrl, curve: Curves.easeIn);

    _logoCtrl.forward();
    Future.delayed(const Duration(milliseconds: 600),
        () => _textCtrl.forward());
    Future.delayed(const Duration(milliseconds: 2600), () {
      if (mounted) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const LoginScreen()));
      }
    });
  }

  @override
  void dispose() {
    _logoCtrl.dispose();
    _textCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.bgDark, Color(0xFF0A3D1F)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _logoScale,
                child: FadeTransition(
                  opacity: _logoFade,
                  child: Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.primary,
                      boxShadow: [
                        BoxShadow(
                            color: AppTheme.primaryLight.withOpacity(0.4),
                            blurRadius: 30,
                            spreadRadius: 5)
                      ],
                    ),
                    child: const Icon(Icons.terrain,
                        size: 60, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              FadeTransition(
                opacity: _textFade,
                child: Column(
                  children: [
                    const Text('PakTours',
                        style: TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textPrimary,
                            letterSpacing: 1.5)),
                    const SizedBox(height: 6),
                    Text('Explore. Trek. Discover Pakistan.',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.accent.withOpacity(0.9),
                            letterSpacing: 0.5)),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              const SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppTheme.accent),
                  strokeWidth: 2.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  LOGIN SCREEN
// ─────────────────────────────────────────────

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  String? _error;

  void _login() async {
  setState(() {
    _loading = true;
    _error = null;
  });
  final error = await AppState.loginWithFirebase(
      _emailCtrl.text.trim(), _passCtrl.text.trim());
  if (error == null) {
    if (mounted) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => AppState.currentUser!.isAdmin
                  ? const AdminDashboard()
                  : const HomeScreen()));
    }
  } else {
    setState(() {
      _error = error;
      _loading = false;
    });
  }
  }

  void _demoLogin(bool admin) {
    if (admin) {
      _emailCtrl.text = 'admin@paktours.pk';
      _passCtrl.text = 'admin123';
    } else {
      _emailCtrl.text = 'ali@example.com';
      _passCtrl.text = 'user123';
    }
    _login();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.bgDark, Color(0xFF0D2E1C)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 48),
                // Logo
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.primary,
                      boxShadow: [
                        BoxShadow(
                            color: AppTheme.primaryLight.withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 3)
                      ],
                    ),
                    child:
                        const Icon(Icons.terrain, size: 42, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Text('PakTours',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textPrimary)),
                ),
                Center(
                  child: Text('Pakistan\'s Premier Tour Platform',
                      style: TextStyle(
                          color: AppTheme.textSecondary.withOpacity(0.8),
                          fontSize: 13)),
                ),
                const SizedBox(height: 48),
                const Text('Welcome back',
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary)),
                const SizedBox(height: 4),
                const Text('Sign in to continue your adventure',
                    style: TextStyle(
                        color: AppTheme.textSecondary, fontSize: 14)),
                const SizedBox(height: 28),

                // Email
                TextField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: AppTheme.textPrimary),
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    prefixIcon:
                        Icon(Icons.email_outlined, color: AppTheme.primaryLight),
                  ),
                ),
                const SizedBox(height: 14),
                // Password
                TextField(
                  controller: _passCtrl,
                  obscureText: _obscure,
                  style: const TextStyle(color: AppTheme.textPrimary),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline,
                        color: AppTheme.primaryLight),
                    suffixIcon: IconButton(
                      icon: Icon(
                          _obscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppTheme.textSecondary),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 10),
                  Text(_error!,
                      style: const TextStyle(
                          color: AppTheme.danger, fontSize: 12)),
                ],
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _login,
                    child: _loading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2))
                        : const Text('Sign In',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(height: 28),

                // Demo buttons
                const Row(
                  children: [
                    Expanded(child: Divider(color: AppTheme.cardBg)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text('Quick Demo Login',
                          style: TextStyle(
                              color: AppTheme.textSecondary, fontSize: 12)),
                    ),
                    Expanded(child: Divider(color: AppTheme.cardBg)),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _demoLogin(false),
                        icon: const Icon(Icons.person_outline,
                            size: 18, color: AppTheme.primaryLight),
                        label: const Text('User Login',
                            style: TextStyle(color: AppTheme.primaryLight)),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppTheme.primaryLight),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _demoLogin(true),
                        icon: const Icon(Icons.admin_panel_settings_outlined,
                            size: 18, color: AppTheme.accent),
                        label: const Text('Admin Login',
                            style: TextStyle(color: AppTheme.accent)),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppTheme.accent),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const RegisterScreen())),
                    child: RichText(
                      text: const TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(color: AppTheme.textSecondary),
                        children: [
                          TextSpan(
                              text: 'Register',
                              style: TextStyle(
                                  color: AppTheme.primaryLight,
                                  fontWeight: FontWeight.w700))
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  REGISTER SCREEN
// ─────────────────────────────────────────────

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  void _register() async {
  if (_nameCtrl.text.isEmpty ||
      _emailCtrl.text.isEmpty ||
      _passCtrl.text.isEmpty) return;
  setState(() => _loading = true);
  final error = await AppState.registerWithFirebase(
    _nameCtrl.text.trim(),
    _emailCtrl.text.trim(),
    _phoneCtrl.text.trim(),
    _passCtrl.text.trim(),
  );
  if (error == null) {
    if (mounted) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (_) => false);
    }
  } else {
    setState(() => _loading = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: AppTheme.danger),
      );
    }
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Join PakTours',
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary)),
            const SizedBox(height: 4),
            const Text('Start your adventure today',
                style:
                    TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
            const SizedBox(height: 28),
            TextField(
              controller: _nameCtrl,
              style: const TextStyle(color: AppTheme.textPrimary),
              decoration: const InputDecoration(
                labelText: 'Full Name',
                prefixIcon: Icon(Icons.person_outline,
                    color: AppTheme.primaryLight),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: AppTheme.textPrimary),
              decoration: const InputDecoration(
                labelText: 'Email Address',
                prefixIcon:
                    Icon(Icons.email_outlined, color: AppTheme.primaryLight),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _phoneCtrl,
              keyboardType: TextInputType.phone,
              style: const TextStyle(color: AppTheme.textPrimary),
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: Icon(Icons.phone_outlined,
                    color: AppTheme.primaryLight),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _passCtrl,
              obscureText: _obscure,
              style: const TextStyle(color: AppTheme.textPrimary),
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock_outline,
                    color: AppTheme.primaryLight),
                suffixIcon: IconButton(
                  icon: Icon(
                      _obscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppTheme.textSecondary),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _register,
                child: _loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                    : const Text('Create Account',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  HOME SCREEN (User)
// ─────────────────────────────────────────────

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tab = 0;
  String _searchQuery = '';
  String _selectedRegion = 'All';
  final List<String> _regions = ['All', 'KPK', 'GB', 'AJK', 'Punjab', 'Sindh'];

  List<TripDestination> get _filteredTrips {
    return AppState.trips.where((t) {
      final matchesSearch = t.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          t.location.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesRegion = _selectedRegion == 'All' || t.region == _selectedRegion;
      return matchesSearch && matchesRegion && t.isActive;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _tab,
        children: [
          _buildExploreTab(),
          _buildMyTripsTab(),
          _buildProfileTab(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.surface,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, -3))
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _tab,
          onTap: (i) => setState(() => _tab = i),
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: AppTheme.accent,
          unselectedItemColor: AppTheme.textSecondary,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.explore_outlined),
                activeIcon: Icon(Icons.explore),
                label: 'Explore'),
            BottomNavigationBarItem(
                icon: Icon(Icons.confirmation_number_outlined),
                activeIcon: Icon(Icons.confirmation_number),
                label: 'My Trips'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _buildExploreTab() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 180,
          floating: false,
          pinned: true,
          backgroundColor: AppTheme.bgDark,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.bgDark, Color(0xFF0E3D22)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hello, ${AppState.currentUser?.name.split(' ').first ?? 'Explorer'} 👋',
                                style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: AppTheme.textPrimary),
                              ),
                              const Text(
                                'Where to next?',
                                style: TextStyle(
                                    color: AppTheme.textSecondary,
                                    fontSize: 13),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Container(
                            width: 42,
                            height: 42,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppTheme.primary,
                            ),
                            child: const Icon(Icons.terrain,
                                size: 22, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(52),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: TextField(
                onChanged: (v) => setState(() => _searchQuery = v),
                style: const TextStyle(color: AppTheme.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Search destinations...',
                  prefixIcon: const Icon(Icons.search,
                      color: AppTheme.textSecondary),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  fillColor: AppTheme.cardBg,
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none),
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: SizedBox(
              height: 36,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _regions.length,
                itemBuilder: (_, i) {
                  final r = _regions[i];
                  final selected = r == _selectedRegion;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(r),
                      selected: selected,
                      onSelected: (_) =>
                          setState(() => _selectedRegion = r),
                      selectedColor: AppTheme.primary,
                      backgroundColor: AppTheme.cardBg,
                      labelStyle: TextStyle(
                          color: selected
                              ? Colors.white
                              : AppTheme.textSecondary,
                          fontSize: 13,
                          fontWeight: selected
                              ? FontWeight.w700
                              : FontWeight.normal),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, i) {
                final trips = _filteredTrips;
                if (trips.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 60),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.search_off,
                              size: 48, color: AppTheme.textSecondary),
                          SizedBox(height: 12),
                          Text('No destinations found',
                              style: TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: 16)),
                        ],
                      ),
                    ),
                  );
                }
                return _TripCard(trip: trips[i], onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => TripDetailScreen(trip: trips[i])));
                  setState(() {});
                });
              },
              childCount: _filteredTrips.isEmpty ? 1 : _filteredTrips.length,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
      ],
    );
  }

  Widget _buildMyTripsTab() {
    final bookings = AppState.currentUser?.bookings ?? [];
    return Scaffold(
      appBar: AppBar(title: const Text('My Bookings')),
      body: bookings.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.luggage_outlined,
                      size: 64,
                      color: AppTheme.textSecondary.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  const Text('No bookings yet',
                      style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 18,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text('Explore destinations and book your first trip!',
                      style: TextStyle(
                          color: AppTheme.textSecondary.withOpacity(0.7),
                          fontSize: 13)),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => setState(() => _tab = 0),
                    icon: const Icon(Icons.explore),
                    label: const Text('Explore Trips'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: bookings.length,
              itemBuilder: (_, i) => _BookingCard(booking: bookings[i]),
            ),
    );
  }

  Widget _buildProfileTab() {
    final u = AppState.currentUser!;
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar
            Container(
              width: 90,
              height: 90,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                    colors: [AppTheme.primary, AppTheme.primaryLight]),
              ),
              child: Center(
                child: Text(
                  u.name.isNotEmpty ? u.name[0].toUpperCase() : 'U',
                  style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(u.name,
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary)),
            Text(u.email,
                style: const TextStyle(
                    color: AppTheme.textSecondary, fontSize: 14)),
            const SizedBox(height: 24),

            // Stats
            Row(
              children: [
                _statCard('Trips Booked', '${u.bookings.length}',
                    Icons.confirmation_number),
                const SizedBox(width: 12),
                _statCard('Total Spent',
                    'Rs ${u.bookings.fold(0.0, (s, b) => s + b.totalAmount).toStringAsFixed(0)}',
                    Icons.payments_outlined),
              ],
            ),
            const SizedBox(height: 20),

            // Info cards
            _infoTile(Icons.phone_outlined, 'Phone', u.phone),
            _infoTile(Icons.email_outlined, 'Email', u.email),

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () async {
  await AppState.logout();
  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (_) => false);
                },
                icon: const Icon(Icons.logout, color: AppTheme.danger),
                label: const Text('Sign Out',
                    style: TextStyle(color: AppTheme.danger)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppTheme.danger),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.cardBg,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppTheme.accent, size: 22),
            const SizedBox(height: 10),
            Text(value,
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary)),
            Text(label,
                style: const TextStyle(
                    color: AppTheme.textSecondary, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryLight, size: 20),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      color: AppTheme.textSecondary, fontSize: 11)),
              Text(value,
                  style: const TextStyle(
                      color: AppTheme.textPrimary, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  TRIP CARD WIDGET
// ─────────────────────────────────────────────

class _TripCard extends StatelessWidget {
  final TripDestination trip;
  final VoidCallback onTap;
  const _TripCard({required this.trip, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        decoration: BoxDecoration(
          color: AppTheme.cardBg,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 3))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(18)),
              child: Stack(
                children: [
                  Image.network(
                    trip.heroImage,
                    height: 190,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 190,
                      color: AppTheme.surface,
                      child: const Center(
                          child: Icon(Icons.terrain,
                              size: 60, color: AppTheme.primaryLight)),
                    ),
                  ),
                  // Region badge
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(trip.region,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700)),
                    ),
                  ),
                  // Price badge
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.accent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text('Rs ${trip.pricePerPerson.toStringAsFixed(0)}/person',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w800)),
                    ),
                  ),
                  // Difficulty
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.difficultyColor(trip.difficulty)
                            .withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(trip.difficulty,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(trip.name,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 14, color: AppTheme.primaryLight),
                      const SizedBox(width: 4),
                      Text(trip.location,
                          style: const TextStyle(
                              color: AppTheme.textSecondary, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _chip(Icons.schedule_outlined, trip.duration),
                      const SizedBox(width: 8),
                      _chip(Icons.people_outline,
                          '${trip.availableSeats} seats left'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Activities preview
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: trip.activities
                        .take(4)
                        .map((a) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.surface,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(a.icon,
                                      size: 12,
                                      color: AppTheme.primaryLight),
                                  const SizedBox(width: 4),
                                  Text(a.name,
                                      style: const TextStyle(
                                          fontSize: 11,
                                          color: AppTheme.textSecondary)),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppTheme.accent),
          const SizedBox(width: 4),
          Text(text,
              style:
                  const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  TRIP DETAIL SCREEN
// ─────────────────────────────────────────────

class TripDetailScreen extends StatefulWidget {
  final TripDestination trip;
  const TripDetailScreen({super.key, required this.trip});
  @override
  State<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  final int _persons = 1;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.trip;
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: AppTheme.bgDark,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    t.heroImage,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppTheme.surface,
                      child: const Center(
                          child: Icon(Icons.terrain,
                              size: 80, color: AppTheme.primaryLight)),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          AppTheme.bgDark.withOpacity(0.85)
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.primary.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(t.region,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700)),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.difficultyColor(t.difficulty)
                                    .withOpacity(0.9),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(t.difficulty,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(t.name,
                            style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: Colors.white)),
                        Row(
                          children: [
                            const Icon(Icons.location_on,
                                size: 14, color: AppTheme.accent),
                            const SizedBox(width: 4),
                            Text(t.location,
                                style: const TextStyle(
                                    color: AppTheme.textSecondary,
                                    fontSize: 13)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: AppTheme.bgDark,
              child: TabBar(
                controller: _tabCtrl,
                indicatorColor: AppTheme.accent,
                labelColor: AppTheme.accent,
                unselectedLabelColor: AppTheme.textSecondary,
                indicatorWeight: 3,
                tabs: const [
                  Tab(text: 'Overview'),
                  Tab(text: 'Route'),
                  Tab(text: 'Activities'),
                  Tab(text: 'Meals'),
                ],
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabCtrl,
          children: [
            _overviewTab(t),
            _routeTab(t),
            _activitiesTab(t),
            _mealsTab(t),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(t),
    );
  }

  Widget _overviewTab(TripDestination t) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick info row
          Row(
            children: [
              _quickInfo(Icons.schedule_outlined, t.duration, 'Duration'),
              _quickInfo(Icons.people_outline,
                  '${t.availableSeats} left', 'Available'),
              _quickInfo(Icons.terrain_outlined,
                  t.maxAltitude, 'Max Alt.'),
            ],
          ),
          const SizedBox(height: 18),

          // Description
          const Text('About this Trip',
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary)),
          const SizedBox(height: 8),
          Text(t.description,
              style: TextStyle(
                  color: AppTheme.textSecondary.withOpacity(0.9),
                  fontSize: 14,
                  height: 1.6)),
          const SizedBox(height: 18),

          // Highlights
          const Text('Highlights',
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary)),
          const SizedBox(height: 10),
          ...t.highlights
              .map((h) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.star,
                            size: 16, color: AppTheme.accent),
                        const SizedBox(width: 10),
                        Expanded(
                            child: Text(h,
                                style: const TextStyle(
                                    color: AppTheme.textPrimary,
                                    fontSize: 14))),
                      ],
                    ),
                  )),
          const SizedBox(height: 18),

          // Departure info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: AppTheme.primary.withOpacity(0.4), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.departure_board,
                        color: AppTheme.accent, size: 18),
                    SizedBox(width: 8),
                    Text('Trip Schedule',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppTheme.accent,
                            fontSize: 15)),
                  ],
                ),
                const SizedBox(height: 12),
                _scheduleRow('Departure',
                    '${_formatDate(t.departureDate)} at ${t.departureTime}'),
                const SizedBox(height: 6),
                _scheduleRow(
                    'Return', '${_formatDate(t.returnDate)} (evening)'),
                const SizedBox(height: 6),
                _scheduleRow('Duration', t.duration),
                const SizedBox(height: 6),
                _scheduleRow('Departure From', t.departureCity),
                const SizedBox(height: 6),
                _scheduleRow('Meeting Point', t.departureSpot),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Inclusions
          const Text('What\'s Included',
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: t.inclusions
                .map((inc) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: AppTheme.primary.withOpacity(0.4)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.check_circle,
                              size: 13, color: AppTheme.easyGreen),
                          const SizedBox(width: 6),
                          Text(inc,
                              style: const TextStyle(
                                  color: AppTheme.textPrimary,
                                  fontSize: 12)),
                        ],
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _routeTab(TripDestination t) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Route Itinerary',
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary)),
          const SizedBox(height: 4),
          const Text('Step-by-step travel plan',
              style:
                  TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          const SizedBox(height: 16),
          ...List.generate(t.routes.length, (i) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: i == 0
                            ? AppTheme.accent
                            : AppTheme.primary,
                      ),
                      child: Center(
                          child: Text('${i + 1}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700))),
                    ),
                    if (i < t.routes.length - 1)
                      Container(
                          width: 2, height: 48, color: AppTheme.cardBg),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 6, bottom: 32),
                    child: Text(t.routes[i],
                        style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 14,
                            height: 1.4)),
                  ),
                ),
              ],
            );
          }),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _activitiesTab(TripDestination t) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Activities & Adventures',
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary)),
          const SizedBox(height: 4),
          Text('${t.activities.length} activities included',
              style:
                  const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          const SizedBox(height: 16),
          ...t.activities.map((a) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.cardBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(a.icon,
                          color: AppTheme.primaryLight, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(a.name,
                              style: const TextStyle(
                                  color: AppTheme.textPrimary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15)),
                          const SizedBox(height: 2),
                          Text(a.description,
                              style: const TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: 12)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.easyGreen.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('Included',
                          style: TextStyle(
                              color: AppTheme.easyGreen,
                              fontSize: 11,
                              fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _mealsTab(TripDestination t) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Meal Plan',
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary)),
          const SizedBox(height: 4),
          const Text('All meals included in package',
              style:
                  TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          const SizedBox(height: 16),
          ...t.meals.map((m) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.cardBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppTheme.accent.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child:
                          Icon(m.icon, color: AppTheme.accent, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(m.type,
                              style: const TextStyle(
                                  color: AppTheme.textPrimary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15)),
                          const SizedBox(height: 2),
                          Text(m.description,
                              style: const TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildBottomBar(TripDestination t) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, -3))
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rs ${t.pricePerPerson.toStringAsFixed(0)}',
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.accent),
                ),
                const Text('per person',
                    style: TextStyle(
                        color: AppTheme.textSecondary, fontSize: 11)),
              ],
            ),
            const Spacer(),
            t.availableSeats == 0
                ? Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppTheme.cardBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text('Fully Booked',
                        style: TextStyle(
                            color: AppTheme.danger,
                            fontWeight: FontWeight.w700)),
                  )
                : ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => BookingScreen(trip: t)),
                      ).then((_) => setState(() {}));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28, vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Book Now',
                        style: TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 16)),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _quickInfo(IconData icon, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: AppTheme.cardBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppTheme.primaryLight, size: 20),
            const SizedBox(height: 6),
            Text(value,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 12)),
            Text(label,
                style: const TextStyle(
                    color: AppTheme.textSecondary, fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _scheduleRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text('$label:',
              style: const TextStyle(
                  color: AppTheme.textSecondary, fontSize: 13)),
        ),
        Expanded(
          child: Text(value,
              style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }

  String _formatDate(DateTime d) =>
      '${d.day} ${['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][d.month - 1]} ${d.year}';
}

// ─────────────────────────────────────────────
//  BOOKING SCREEN
// ─────────────────────────────────────────────

class BookingScreen extends StatefulWidget {
  final TripDestination trip;
  const BookingScreen({super.key, required this.trip});
  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int _persons = 1;
  int _step = 0; // 0 = select persons, 1 = payment method, 2 = payment details

  String? _selectedPayment;

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'name': 'Easypaisa',
      'icon': Icons.phone_android,
      'color': const Color(0xFF00A651),
      'subtitle': 'Send to mobile account',
      'number': '0300-1234567',
      'account_name': 'PakTours Pvt Ltd',
    },
    {
      'name': 'JazzCash',
      'icon': Icons.account_balance_wallet_outlined,
      'color': const Color(0xFFE30513),
      'subtitle': 'Send to mobile account',
      'number': '0321-7654321',
      'account_name': 'PakTours Official',
    },
    {
      'name': 'Bank Transfer',
      'icon': Icons.account_balance_outlined,
      'color': const Color(0xFF1565C0),
      'subtitle': 'Direct bank transfer',
      'number': 'PK36HABB0000000012345678',
      'account_name': 'PakTours Pvt Ltd',
      'bank': 'HBL - Habib Bank Limited',
    },
    {
      'name': 'Payment on Spot',
      'icon': Icons.payments_outlined,
      'color': const Color(0xFFE8A825),
      'subtitle': 'Pay cash at departure',
      'note': 'Cash only, exact amount required',
    },
  ];

  double get _totalAmount =>
      widget.trip.pricePerPerson * _persons;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_step == 0
            ? 'Book Trip'
            : _step == 1
                ? 'Payment Method'
                : 'Payment Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            if (_step > 0) {
              setState(() => _step--);
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: _step == 0
          ? _buildPersonStep()
          : _step == 1
              ? _buildPaymentMethodStep()
              : _buildPaymentDetailsStep(),
    );
  }

  Widget _buildPersonStep() {
    final t = widget.trip;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Trip summary card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.cardBg,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    t.heroImage,
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 70,
                      height: 70,
                      color: AppTheme.surface,
                      child: const Icon(Icons.terrain,
                          color: AppTheme.primaryLight),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                              fontSize: 15)),
                      const SizedBox(height: 4),
                      Text(t.location,
                          style: const TextStyle(
                              color: AppTheme.textSecondary, fontSize: 12)),
                      const SizedBox(height: 4),
                      Text(t.duration,
                          style: const TextStyle(
                              color: AppTheme.primaryLight, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          const Text('Number of Persons',
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary)),
          const SizedBox(height: 4),
          Text('Max ${t.availableSeats} seats available',
              style: const TextStyle(
                  color: AppTheme.textSecondary, fontSize: 12)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.cardBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _persons > 1
                      ? () => setState(() => _persons--)
                      : null,
                  icon: const Icon(Icons.remove_circle,
                      color: AppTheme.primary, size: 36),
                ),
                const SizedBox(width: 20),
                Column(
                  children: [
                    Text('$_persons',
                        style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textPrimary)),
                    const Text('persons',
                        style: TextStyle(
                            color: AppTheme.textSecondary, fontSize: 12)),
                  ],
                ),
                const SizedBox(width: 20),
                IconButton(
                  onPressed: _persons < t.availableSeats
                      ? () => setState(() => _persons++)
                      : null,
                  icon: const Icon(Icons.add_circle,
                      color: AppTheme.primary, size: 36),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Price breakdown
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.cardBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                _priceRow('Price per person',
                    'Rs ${t.pricePerPerson.toStringAsFixed(0)}'),
                const SizedBox(height: 8),
                _priceRow('No. of persons', '× $_persons'),
                const Divider(color: AppTheme.surface, height: 20),
                _priceRow('Total Amount',
                    'Rs ${_totalAmount.toStringAsFixed(0)}',
                    isTotal: true),
              ],
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => setState(() => _step = 1),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: Text(
                  'Continue — Rs ${_totalAmount.toStringAsFixed(0)}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w800)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Choose Payment Method',
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary)),
          const SizedBox(height: 4),
          Text(
              'Total: Rs ${_totalAmount.toStringAsFixed(0)} for $_persons person(s)',
              style:
                  const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
          const SizedBox(height: 20),
          ..._paymentMethods.map((pm) {
            final selected = _selectedPayment == pm['name'];
            return GestureDetector(
              onTap: () => setState(() => _selectedPayment = pm['name']),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: selected
                      ? (pm['color'] as Color).withOpacity(0.15)
                      : AppTheme.cardBg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: selected
                        ? pm['color'] as Color
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: (pm['color'] as Color).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(pm['icon'] as IconData,
                          color: pm['color'] as Color, size: 26),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(pm['name'] as String,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.textPrimary,
                                  fontSize: 16)),
                          Text(pm['subtitle'] as String,
                              style: const TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: 12)),
                        ],
                      ),
                    ),
                    Radio<String>(
                      value: pm['name'] as String,
                      groupValue: _selectedPayment,
                      onChanged: (v) =>
                          setState(() => _selectedPayment = v),
                      activeColor: pm['color'] as Color,
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selectedPayment == null
                  ? null
                  : () => setState(() => _step = 2),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                disabledBackgroundColor: AppTheme.cardBg,
              ),
              child: const Text('Confirm Payment Method',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w800)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentDetailsStep() {
    final pm = _paymentMethods
        .firstWhere((p) => p['name'] == _selectedPayment);
    final isSpot = _selectedPayment == 'Payment on Spot';
    final t = widget.trip;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Payment method card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  (pm['color'] as Color).withOpacity(0.25),
                  (pm['color'] as Color).withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: (pm['color'] as Color).withOpacity(0.4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(pm['icon'] as IconData,
                        color: pm['color'] as Color, size: 28),
                    const SizedBox(width: 12),
                    Text(pm['name'] as String,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: pm['color'] as Color)),
                  ],
                ),
                const SizedBox(height: 14),
                if (!isSpot) ...[
                  const Text('Send Payment To:',
                      style: TextStyle(
                          color: AppTheme.textSecondary, fontSize: 12)),
                  const SizedBox(height: 8),
                  if (pm.containsKey('bank'))
                    _paymentDetailRow('Bank', pm['bank'] as String),
                  _paymentDetailRow('Account Name',
                      pm['account_name'] as String),
                  _paymentDetailRow(
                      _selectedPayment == 'Bank Transfer'
                          ? 'IBAN'
                          : 'Number',
                      pm['number'] as String),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.surface.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.info_outline,
                            size: 16, color: AppTheme.accent),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Send exact amount and screenshot the transfer. Share with admin on WhatsApp: 0300-0000000',
                            style: TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 11,
                                height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  Text(pm['note'] as String,
                      style: const TextStyle(
                          color: AppTheme.textSecondary, fontSize: 13)),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Amount
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.cardBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                _priceRow('Trip', t.name),
                const SizedBox(height: 6),
                _priceRow('Persons', '$_persons person(s)'),
                const SizedBox(height: 6),
                _priceRow('Per Person',
                    'Rs ${t.pricePerPerson.toStringAsFixed(0)}'),
                const Divider(color: AppTheme.surface, height: 20),
                _priceRow(
                    'TOTAL TO PAY',
                    'Rs ${_totalAmount.toStringAsFixed(0)}',
                    isTotal: true),
              ],
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _confirmBooking,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.easyGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, size: 22),
                  SizedBox(width: 8),
                  Text('Confirm Booking',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w800)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _paymentDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text('$label:',
                style: const TextStyle(
                    color: AppTheme.textSecondary, fontSize: 13)),
          ),
          Expanded(
            child: SelectableText(
              value,
              style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmBooking() {
    final booking = AppState.addBooking(
        widget.trip, _persons, _selectedPayment!);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (_) => BookingConfirmationScreen(
                booking: booking,
                trip: widget.trip,
              )),
      (route) => route.isFirst,
    );
  }

  Widget _priceRow(String label, String value, {bool isTotal = false}) {
    return Row(
      children: [
        Text(label,
            style: TextStyle(
                color: isTotal
                    ? AppTheme.textPrimary
                    : AppTheme.textSecondary,
                fontSize: isTotal ? 15 : 13,
                fontWeight:
                    isTotal ? FontWeight.w700 : FontWeight.normal)),
        const Spacer(),
        Text(value,
            style: TextStyle(
                color: isTotal ? AppTheme.accent : AppTheme.textPrimary,
                fontSize: isTotal ? 18 : 13,
                fontWeight: isTotal ? FontWeight.w800 : FontWeight.w600)),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  BOOKING CONFIRMATION SCREEN
// ─────────────────────────────────────────────

class BookingConfirmationScreen extends StatelessWidget {
  final Booking booking;
  final TripDestination trip;
  const BookingConfirmationScreen(
      {super.key, required this.booking, required this.trip});

  String _formatDate(DateTime d) =>
      '${d.day} ${['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][d.month - 1]} ${d.year}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.bgDark, Color(0xFF0D2E1C)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                // Success icon
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.easyGreen.withOpacity(0.2),
                    border: Border.all(
                        color: AppTheme.easyGreen, width: 3),
                  ),
                  child: const Icon(Icons.check_rounded,
                      size: 54, color: AppTheme.easyGreen),
                ),
                const SizedBox(height: 20),
                const Text('Booking Confirmed!',
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary)),
                const SizedBox(height: 6),
                Text('Booking ID: ${booking.bookingId}',
                    style: const TextStyle(
                        color: AppTheme.textSecondary, fontSize: 13)),
                const SizedBox(height: 30),

                // Trip info card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.cardBg,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(trip.name,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.textPrimary)),
                      const SizedBox(height: 4),
                      Text(trip.location,
                          style: const TextStyle(
                              color: AppTheme.textSecondary, fontSize: 13)),
                      const SizedBox(height: 16),
                      _row('Departure',
                          '${_formatDate(trip.departureDate)} at ${trip.departureTime}'),
                      const SizedBox(height: 8),
                      _row('Return', _formatDate(trip.returnDate)),
                      const SizedBox(height: 8),
                      _row('Persons', '${booking.persons} person(s)'),
                      const SizedBox(height: 8),
                      _row('Payment', booking.paymentMethod),
                      const SizedBox(height: 8),
                      _row('Total', 'Rs ${booking.totalAmount.toStringAsFixed(0)}'),
                      const SizedBox(height: 8),
                      _row('Status', booking.paymentStatus,
                          valueColor: booking.paymentStatus == 'Pay on Spot'
                              ? AppTheme.accent
                              : AppTheme.moderateOrange),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Important notice
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppTheme.accent.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: AppTheme.accent.withOpacity(0.4)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.notifications_active_outlined,
                              color: AppTheme.accent, size: 20),
                          SizedBox(width: 8),
                          Text('Important — Please Read',
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.accent,
                                  fontSize: 15)),
                        ],
                      ),
                      const SizedBox(height: 14),
                      _notice('🕐 Trip departs on ${_formatDate(trip.departureDate)} at ${trip.departureTime} sharp'),
                      const SizedBox(height: 8),
                      _notice('📍 Meet at: ${trip.departureSpot}'),
                      const SizedBox(height: 8),
                      _notice('⚠️ Be at the departure spot at least 30 minutes early'),
                      const SizedBox(height: 8),
                      _notice('🎒 Pack light: warm clothes, water, snacks, ID card'),
                      const SizedBox(height: 8),
                      if (booking.paymentMethod != 'Payment on Spot')
                        _notice('💳 Share payment screenshot on WhatsApp: 0300-0000000')
                      else
                        _notice('💵 Bring exact cash: Rs ${booking.totalAmount.toStringAsFixed(0)}'),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const HomeScreen()),
                          (_) => false);
                    },
                    icon: const Icon(Icons.explore),
                    label: const Text('Back to Explore',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700)),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String value, {Color? valueColor}) {
    return Row(
      children: [
        SizedBox(
          width: 90,
          child: Text('$label:',
              style: const TextStyle(
                  color: AppTheme.textSecondary, fontSize: 13)),
        ),
        Expanded(
          child: Text(value,
              style: TextStyle(
                  color: valueColor ?? AppTheme.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 13)),
        ),
      ],
    );
  }

  Widget _notice(String text) {
    return Text(text,
        style: const TextStyle(
            color: AppTheme.textPrimary, fontSize: 13, height: 1.4));
  }
}

// ─────────────────────────────────────────────
//  ADMIN DASHBOARD
// ─────────────────────────────────────────────

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});
  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _tab,
        children: [
          _AdminTripsTab(onRefresh: () => setState(() {})),
          _AdminBookingsTab(),
          _AdminStatsTab(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(color: AppTheme.surface),
        child: BottomNavigationBar(
          currentIndex: _tab,
          onTap: (i) => setState(() => _tab = i),
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: AppTheme.accent,
          unselectedItemColor: AppTheme.textSecondary,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.terrain_outlined),
                activeIcon: Icon(Icons.terrain),
                label: 'Trips'),
            BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long_outlined),
                activeIcon: Icon(Icons.receipt_long),
                label: 'Bookings'),
            BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart_outlined),
                activeIcon: Icon(Icons.bar_chart),
                label: 'Stats'),
          ],
        ),
      ),
    );
  }
}

class _AdminTripsTab extends StatefulWidget {
  final VoidCallback onRefresh;
  const _AdminTripsTab({required this.onRefresh});
  @override
  State<_AdminTripsTab> createState() => _AdminTripsTabState();
}

class _AdminTripsTabState extends State<_AdminTripsTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🛡️ Admin — Trips'),
        actions: [
          TextButton.icon(
            onPressed: () async {
  await AppState.logout();
  Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (_) => false);
            },
            icon: const Icon(Icons.logout, color: AppTheme.danger, size: 18),
            label: const Text('Logout',
                style: TextStyle(color: AppTheme.danger)),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddTripDialog(),
        backgroundColor: AppTheme.accent,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Trip',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w700)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: AppState.trips.length,
        itemBuilder: (_, i) {
          final t = AppState.trips[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: AppTheme.cardBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  t.heroImage,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 60,
                    height: 60,
                    color: AppTheme.surface,
                    child: const Icon(Icons.terrain,
                        color: AppTheme.primaryLight),
                  ),
                ),
              ),
              title: Text(t.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.location,
                      style: const TextStyle(
                          color: AppTheme.textSecondary, fontSize: 12)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                          'Rs ${t.pricePerPerson.toStringAsFixed(0)} • ',
                          style: const TextStyle(
                              color: AppTheme.accent, fontSize: 12)),
                      Text(
                          '${t.bookedSeats}/${t.totalSeats} booked',
                          style: const TextStyle(
                              color: AppTheme.textSecondary, fontSize: 12)),
                    ],
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Switch(
                    value: t.isActive,
                    onChanged: (v) => setState(() => t.isActive = v),
                    activeColor: AppTheme.easyGreen,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline,
                        color: AppTheme.danger, size: 20),
                    onPressed: () {
                      setState(() => AppState.trips.removeAt(i));
                      widget.onRefresh();
                    },
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showAddTripDialog() {
    final nameCtrl = TextEditingController();
    final locationCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final seatsCtrl = TextEditingController(text: '20');
    final durationCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    String region = 'KPK';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
              left: 20,
              right: 20,
              top: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Add New Destination',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary)),
                const SizedBox(height: 16),
                TextField(
                  controller: nameCtrl,
                  style: const TextStyle(color: AppTheme.textPrimary),
                  decoration:
                      const InputDecoration(labelText: 'Trip Name *'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: locationCtrl,
                  style: const TextStyle(color: AppTheme.textPrimary),
                  decoration:
                      const InputDecoration(labelText: 'Location *'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descCtrl,
                  style: const TextStyle(color: AppTheme.textPrimary),
                  maxLines: 2,
                  decoration:
                      const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: durationCtrl,
                  style: const TextStyle(color: AppTheme.textPrimary),
                  decoration: const InputDecoration(
                      labelText: 'Duration (e.g. 2 Days / 1 Night)'),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: priceCtrl,
                        keyboardType: TextInputType.number,
                        style:
                            const TextStyle(color: AppTheme.textPrimary),
                        decoration: const InputDecoration(
                            labelText: 'Price / Person *'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: seatsCtrl,
                        keyboardType: TextInputType.number,
                        style:
                            const TextStyle(color: AppTheme.textPrimary),
                        decoration:
                            const InputDecoration(labelText: 'Total Seats'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: region,
                  dropdownColor: AppTheme.cardBg,
                  style: const TextStyle(color: AppTheme.textPrimary),
                  decoration: const InputDecoration(labelText: 'Region'),
                  items: ['KPK', 'GB', 'AJK', 'Punjab', 'Sindh']
                      .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                      .toList(),
                  onChanged: (v) => setModalState(() => region = v!),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (nameCtrl.text.isNotEmpty &&
                          locationCtrl.text.isNotEmpty &&
                          priceCtrl.text.isNotEmpty) {
                        setState(() {
                          AppState.trips.add(TripDestination(
                            id: 'trip_${DateTime.now().millisecondsSinceEpoch}',
                            name: nameCtrl.text,
                            location: locationCtrl.text,
                            region: region,
                            heroImage:
                                'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3e/Mushkpuri_summit.jpg/1280px-Mushkpuri_summit.jpg',
                            description: descCtrl.text.isNotEmpty
                                ? descCtrl.text
                                : 'Explore this amazing destination in Pakistan.',
                            duration: durationCtrl.text.isNotEmpty
                                ? durationCtrl.text
                                : '2 Days / 1 Night',
                            departureCity: 'Islamabad',
                            departureSpot: 'Faizabad Interchange, Islamabad',
                            departureDate: DateTime.now()
                                .add(const Duration(days: 30)),
                            returnDate: DateTime.now()
                                .add(const Duration(days: 32)),
                            departureTime: '5:00 AM',
                            pricePerPerson:
                                double.tryParse(priceCtrl.text) ?? 5000,
                            totalSeats: int.tryParse(seatsCtrl.text) ?? 20,
                            routes: ['Route details to be added'],
                            inclusions: ['Transport', 'Guide', 'Meals'],
                            activities: [
                              ActivityItem(
                                  name: 'Trekking',
                                  icon: Icons.hiking,
                                  description: 'Scenic trek'),
                              ActivityItem(
                                  name: 'Bonfire',
                                  icon: Icons.local_fire_department,
                                  description: 'Night bonfire'),
                            ],
                            meals: [
                              MealPlan(
                                  type: 'Breakfast',
                                  description: 'Full breakfast',
                                  icon: Icons.free_breakfast),
                            ],
                            highlights: ['Scenic views', 'Adventure'],
                            difficulty: 'Moderate',
                          ));
                          widget.onRefresh();
                        });
                        Navigator.pop(ctx);
                      }
                    },
                    child: const Text('Add Destination',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AdminBookingsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Bookings')),
      body: AppState.allBookings.isEmpty
          ? const Center(
              child: Text('No bookings yet',
                  style: TextStyle(color: AppTheme.textSecondary)))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: AppState.allBookings.length,
              itemBuilder: (_, i) =>
                  _BookingCard(booking: AppState.allBookings[i]),
            ),
    );
  }
}

class _AdminStatsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final totalRevenue = AppState.allBookings
        .fold(0.0, (s, b) => s + b.totalAmount);
    final totalBookings = AppState.allBookings.length;
    final totalTrips = AppState.trips.length;
    final activeTrips = AppState.trips.where((t) => t.isActive).length;
    final totalPersons =
        AppState.allBookings.fold(0, (s, b) => s + b.persons);

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Stats')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Overview',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary)),
            const SizedBox(height: 16),
            Row(
              children: [
                _adminStatCard('Total Revenue',
                    'Rs ${totalRevenue.toStringAsFixed(0)}', Icons.payments,
                    AppTheme.accent),
                const SizedBox(width: 12),
                _adminStatCard('Total Bookings', '$totalBookings',
                    Icons.confirmation_number, AppTheme.primaryLight),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _adminStatCard('Active Trips', '$activeTrips / $totalTrips',
                    Icons.terrain, AppTheme.easyGreen),
                const SizedBox(width: 12),
                _adminStatCard('Total Tourists', '$totalPersons persons',
                    Icons.people, AppTheme.moderateOrange),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Trip Performance',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary)),
            const SizedBox(height: 12),
            ...AppState.trips.map((t) {
              final pct =
                  t.totalSeats > 0 ? t.bookedSeats / t.totalSeats : 0.0;
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.cardBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(t.name,
                              style: const TextStyle(
                                  color: AppTheme.textPrimary,
                                  fontWeight: FontWeight.w700)),
                        ),
                        Text('${t.bookedSeats}/${t.totalSeats}',
                            style: const TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: pct,
                      backgroundColor: AppTheme.surface,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          pct > 0.8
                              ? AppTheme.danger
                              : pct > 0.5
                                  ? AppTheme.moderateOrange
                                  : AppTheme.easyGreen),
                      borderRadius: BorderRadius.circular(4),
                      minHeight: 6,
                    ),
                    const SizedBox(height: 4),
                    Text(
                        '${(pct * 100).toStringAsFixed(0)}% booked — Rs ${t.pricePerPerson.toStringAsFixed(0)}/person',
                        style: const TextStyle(
                            color: AppTheme.textSecondary, fontSize: 11)),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _adminStatCard(
      String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.cardBg,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 10),
            Text(value,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: color)),
            const SizedBox(height: 2),
            Text(label,
                style: const TextStyle(
                    color: AppTheme.textSecondary, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  REUSABLE BOOKING CARD
// ─────────────────────────────────────────────

class _BookingCard extends StatelessWidget {
  final Booking booking;
  const _BookingCard({required this.booking});

  String _formatDate(DateTime d) =>
      '${d.day}/${d.month}/${d.year}';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(booking.tripName,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                        fontSize: 15)),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color:
                      (booking.paymentStatus == 'Pay on Spot'
                              ? AppTheme.accent
                              : booking.paymentStatus == 'Pending'
                                  ? AppTheme.moderateOrange
                                  : AppTheme.easyGreen)
                          .withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(booking.paymentStatus,
                    style: TextStyle(
                        color: booking.paymentStatus == 'Pay on Spot'
                            ? AppTheme.accent
                            : booking.paymentStatus == 'Pending'
                                ? AppTheme.moderateOrange
                                : AppTheme.easyGreen,
                        fontSize: 11,
                        fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.confirmation_number_outlined,
                  size: 13, color: AppTheme.textSecondary),
              const SizedBox(width: 4),
              Text(booking.bookingId,
                  style: const TextStyle(
                      color: AppTheme.textSecondary, fontSize: 11)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _chip(
                  '${booking.persons} person(s)', Icons.people_outline),
              const SizedBox(width: 8),
              _chip('Rs ${booking.totalAmount.toStringAsFixed(0)}',
                  Icons.payments_outlined),
              const SizedBox(width: 8),
              _chip(booking.paymentMethod.replaceAll(' ', '\n'),
                  Icons.payment),
            ],
          ),
          const SizedBox(height: 6),
          Text('Booked: ${_formatDate(booking.bookedOn)}',
              style: const TextStyle(
                  color: AppTheme.textSecondary, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _chip(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppTheme.primaryLight),
          const SizedBox(width: 4),
          Text(text,
              style: const TextStyle(
                  color: AppTheme.textSecondary, fontSize: 11)),
        ],
      ),
    );
  }
}
