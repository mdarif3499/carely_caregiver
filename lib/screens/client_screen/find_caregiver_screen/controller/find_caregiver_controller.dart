import 'package:carely_caregiver/widgets/bottom_shit_widget.dart';
import 'package:get/get.dart';

// ── Data Model ──────────────────────────────────────────
class CaregiverModel {
  final String name;
  final String role;
  final String specialty;
  final String description;
  final double rating;
  final double hourlyRate;
  final String avatarUrl;

  const CaregiverModel({
    required this.name,
    required this.role,
    required this.specialty,
    required this.description,
    required this.rating,
    required this.hourlyRate,
    this.avatarUrl = '',
  });
}

// ── Controller ───────────────────────────────────────────
class FindCaregiverController extends GetxController {
  // ── Search ──
  final RxString searchQuery = ''.obs;
  void onSearchChanged(String val) => searchQuery.value = val;

  // ── Filter chips ──
  final List<String> filterCategories = [
    'All',
    'RN',
    'Companion',
    'Specialized',
    'Therapist',
  ];
  final RxString selectedFilter = 'All'.obs;
  void onFilterSelected(String filter) => selectedFilter.value = filter;

  // ── Advanced filter state ──
  final Rx<FilterState> filterState = FilterState().obs;

  void onFilterTap() async {
    final context = Get.context;
    if (context == null) return;
    final result = await showFilterBottomSheet(
      context,
      initial: filterState.value,
    );
    if (result != null) filterState.value = result;
  }


  // ── Dummy data ──
  final List<CaregiverModel> _allCaregivers = const [
    CaregiverModel(
      avatarUrl:
          'https://static.vecteezy.com/system/resources/thumbnails/026/375/249/small/ai-generative-portrait-of-confident-male-doctor-in-white-coat-and-stethoscope-standing-with-arms-crossed-and-looking-at-camera-photo.jpg',
      name: 'Sarah Jenkins',
      role: 'RN',
      specialty: 'Companion & Daily Living',
      description:
          'Dedicated companion providing emotional support and physical assistance for daily tasks.',
      rating: 4.9,
      hourlyRate: 25,
    ),
    CaregiverModel(
      avatarUrl: 'https://market-resized.envatousercontent.com/photodune.net/EVA/TRX/2c/5e/35/e2/76/v1_E10/E109CG4V.jpg?auto=format&q=94&mark=https%3A%2F%2Fassets.market-storefront.envato-static.com%2Fwatermarks%2Fphoto-260724.png&opacity=0.2&cf_fit=contain&w=590&h=885&s=4b95f37d2220201e10c2b6791a9a3cf37f308f0315b4ba0ba8308067486aac91',
      name: 'Marcus Lee',
      role: 'Companion',
      specialty: 'Elderly Care',
      description:
          'Compassionate caregiver specialising in senior companionship and mobility support.',
      rating: 4.7,
      hourlyRate: 20,
    ),
    CaregiverModel(
      name: 'Priya Sharma',
      role: 'Specialized',
      specialty: 'Dementia & Memory Care',
      description:
          'Certified specialist in memory-care techniques and cognitive stimulation activities.',
      rating: 4.8,
      hourlyRate: 30,
    ),
    CaregiverModel(
      name: 'Tom Rivera',
      role: 'Therapist',
      specialty: 'Physical & Occupational',
      description:
          'Licensed occupational therapist helping clients regain independence after injury.',
      rating: 4.6,
      hourlyRate: 35,
    ),
    CaregiverModel(
      name: 'Aisha Nwosu',
      role: 'RN',
      specialty: 'Post-Surgical Care',
      description:
          'Registered nurse with 8 years of post-op recovery and wound-care experience.',
      rating: 5.0,
      hourlyRate: 28,
    ),
  ];

  // Filtered + searched list
  List<CaregiverModel> get filteredCaregivers {
    final query = searchQuery.value.toLowerCase();
    final filter = selectedFilter.value;

    return _allCaregivers.where((c) {
      final matchesFilter = filter == 'All' || c.role == filter;
      final matchesSearch =
          query.isEmpty ||
          c.name.toLowerCase().contains(query) ||
          c.role.toLowerCase().contains(query) ||
          c.specialty.toLowerCase().contains(query);
      return matchesFilter && matchesSearch;
    }).toList();
  }
}
