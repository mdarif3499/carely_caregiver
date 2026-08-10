import 'package:get/get.dart';

class ProfileSetupScreenController extends GetxController {
  // ── Skills & Specializations ──
  final List<String> allSkills = [
    'Elder Care',
    'First Aid',
    'Memory Care',
    'Mobility Support',
    'Medication Admin',
  ];

  final RxSet<String> selectedSkills = <String>{'Elder Care', 'First Aid'}.obs;
  final RxBool showAllSkills = false.obs;

  static const int collapsedCount = 4;

  List<String> get visibleSkills {
    if (showAllSkills.value || allSkills.length <= collapsedCount) {
      return allSkills;
    }
    return allSkills.take(collapsedCount).toList();
  }

  bool get hasMoreSkills =>
      !showAllSkills.value && allSkills.length > collapsedCount;

  void toggleSkill(String skill) {
    if (selectedSkills.contains(skill)) {
      selectedSkills.remove(skill);
    } else {
      selectedSkills.add(skill);
    }
  }

  void expandSkills() => showAllSkills.value = true;

  // ── Work Experience ──
  final List<String> experienceOptions = [
    '0 – 1 year',
    '1 – 2 years',
    '2 – 5 years',
    '5 – 10 years',
    '10+ years',
  ];

  final Rxn<String> selectedExperience = Rxn<String>();

  void onExperienceChanged(String? val) => selectedExperience.value = val;

  // ── Certifications ──
  final RxList<Map<String, String>> certifications = <Map<String, String>>[
    {
      'title': 'Certified Nursing Assistant (CNA)',
      'subtitle': 'Red Cross . Exp: Jan 2026',
    },
  ].obs;

  void deleteCertification(int index) => certifications.removeAt(index);

  void addCertification({required String title, required String subtitle}) {
    certifications.add({'title': title, 'subtitle': subtitle});
  }
}
