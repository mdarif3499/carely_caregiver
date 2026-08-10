import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:carely_caregiver/constant/app_constant.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ══════════════════════════════════════════════════════
//  Filter Model – holds the current filter state
// ══════════════════════════════════════════════════════
class FilterState {
  final List<String> selectedSkills;
  final List<String> selectedDays;
  final RangeValues priceRange;
  final String? selectedRating;
  final String? selectedLanguage;

  const FilterState({
    this.selectedSkills = const [],
    this.selectedDays = const [],
    this.priceRange = const RangeValues(100, 650),
    this.selectedRating,
    this.selectedLanguage,
  });

  FilterState copyWith({
    List<String>? selectedSkills,
    List<String>? selectedDays,
    RangeValues? priceRange,
    String? selectedRating,
    String? selectedLanguage,
    bool clearRating = false,
    bool clearLanguage = false,
  }) {
    return FilterState(
      selectedSkills: selectedSkills ?? this.selectedSkills,
      selectedDays: selectedDays ?? this.selectedDays,
      priceRange: priceRange ?? this.priceRange,
      selectedRating: clearRating
          ? null
          : (selectedRating ?? this.selectedRating),
      selectedLanguage: clearLanguage
          ? null
          : (selectedLanguage ?? this.selectedLanguage),
    );
  }
}

// ══════════════════════════════════════════════════════
//  Public helper – call this to open the bottom sheet
// ══════════════════════════════════════════════════════
Future<FilterState?> showFilterBottomSheet(
  BuildContext context, {
  FilterState? initial,
}) {
  return showModalBottomSheet<FilterState>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _FilterBottomSheet(initial: initial ?? const FilterState()),
  );
}

// ══════════════════════════════════════════════════════
//  Internal bottom-sheet widget
// ══════════════════════════════════════════════════════
class _FilterBottomSheet extends StatefulWidget {
  final FilterState initial;
  const _FilterBottomSheet({required this.initial});

  @override
  State<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<_FilterBottomSheet> {
  // ── Data ──────────────────────────────────────────────
  static const _allSkills = [
    'Dementia Care',
    'Mobility Support',
    'Post-Op Care',
    'Meal Prep',
    'CPR Certified',
  ];

  static const _weekDays = [
    _Day('MON', 'M'),
    _Day('TUE', 'T'),
    _Day('WED', 'W'),
    _Day('THU', 'T'),
    _Day('FRI', 'F'),
    _Day('SAT', 'S'),
    _Day('SUN', 'S'),
  ];

  static const _ratings = ['⭐ 5.0', '⭐ 4.0+', '⭐ 3.0+', '⭐ 2.0+'];
  static const _languages = ['EN', 'AR', 'FR', 'ES', 'HI'];

  // ── State ─────────────────────────────────────────────
  late List<String> _selectedSkills;
  late List<String> _selectedDays;
  late RangeValues _priceRange;
  String? _selectedRating;
  String? _selectedLanguage;

  @override
  void initState() {
    super.initState();
    _selectedSkills = List.from(widget.initial.selectedSkills);
    _selectedDays = List.from(widget.initial.selectedDays);
    _priceRange = widget.initial.priceRange;
    _selectedRating = widget.initial.selectedRating;
    _selectedLanguage = widget.initial.selectedLanguage;
  }

  void _clearAll() => setState(() {
    _selectedSkills.clear();
    _selectedDays.clear();
    _priceRange = const RangeValues(100, 650);
    _selectedRating = null;
    _selectedLanguage = null;
  });

  void _apply() => Navigator.of(context).pop(
    FilterState(
      selectedSkills: _selectedSkills,
      selectedDays: _selectedDays,
      priceRange: _priceRange,
      selectedRating: _selectedRating,
      selectedLanguage: _selectedLanguage,
    ),
  );

  // ── Build ──────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    final bottomPad = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.only(bottom: bottomPad),
      decoration: BoxDecoration(
        color: colors.screenBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Drag handle ──
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 4),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // ── Header ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(
                    Icons.close_rounded,
                    size: 22,
                    color: colors.primaryTextColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CommonText(
                    text: 'Filter',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    textColor: colors.primaryTextColor,
                    isDescription: true,
                    preventScaling: true,
                  ),
                ),
                GestureDetector(
                  onTap: _clearAll,
                  child: CommonText(
                    text: 'Clear all',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    textColor: colors.secondaryColor,
                    isDescription: true,
                    preventScaling: true,
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // ── Scrollable content ──
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Skills ──────────────────────────────
                  _SectionTitle(title: 'Skills'),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _allSkills
                        .map(
                          (s) => _ToggleChip(
                            label: s,
                            isSelected: _selectedSkills.contains(s),
                            onTap: () => setState(() {
                              _selectedSkills.contains(s)
                                  ? _selectedSkills.remove(s)
                                  : _selectedSkills.add(s);
                            }),
                          ),
                        )
                        .toList(),
                  ),

                  const SizedBox(height: 24),
                  const Divider(height: 1),
                  const SizedBox(height: 24),

                  // ── Availability ─────────────────────────
                  _SectionTitle(title: 'Availability'),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: _weekDays
                        .map(
                          (d) => _DayButton(
                            day: d,
                            isSelected: _selectedDays.contains(d.key),
                            onTap: () => setState(() {
                              _selectedDays.contains(d.key)
                                  ? _selectedDays.remove(d.key)
                                  : _selectedDays.add(d.key);
                            }),
                          ),
                        )
                        .toList(),
                  ),

                  const SizedBox(height: 24),
                  const Divider(height: 1),
                  const SizedBox(height: 24),

                  // ── Price Range ──────────────────────────
                  _SectionTitle(title: 'Price Range'),
                  const SizedBox(height: 8),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: colors.primary,
                      inactiveTrackColor: colors.border,
                      thumbColor: colors.primary,
                      overlayColor: colors.primary.withAlpha(30),
                      rangeThumbShape: const RoundRangeSliderThumbShape(
                        enabledThumbRadius: 10,
                      ),
                      trackHeight: 4,
                    ),
                    child: RangeSlider(
                      values: _priceRange,
                      min: 0,
                      max: 1000,
                      onChanged: (v) => setState(() => _priceRange = v),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonText(
                        text: '\$${_priceRange.start.toStringAsFixed(0)}',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        textColor: colors.primaryTextColor,
                        isDescription: true,
                        preventScaling: true,
                      ),
                      CommonText(
                        text: '\$${_priceRange.end.toStringAsFixed(0)}',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        textColor: colors.primaryTextColor,
                        isDescription: true,
                        preventScaling: true,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  const Divider(height: 1),
                  const SizedBox(height: 24),

                  // ── Rating + Language ────────────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Rating
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _SectionTitle(title: 'Rating'),
                            const SizedBox(height: 12),
                            _DropdownSelector<String>(
                              hint: 'Select rating',
                              value: _selectedRating,
                              items: _ratings,
                              onChanged: (v) =>
                                  setState(() => _selectedRating = v),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Language
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _SectionTitle(title: 'Language'),
                            const SizedBox(height: 12),
                            _DropdownSelector<String>(
                              hint: 'EN',
                              value: _selectedLanguage,
                              items: _languages,
                              onChanged: (v) =>
                                  setState(() => _selectedLanguage = v),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // ── Apply button ─────────────────────────
                  CommonButton(
                    titleText: 'Apply',
                    buttonWidth: double.infinity,
                    onTap: _apply,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════
//  Helper data class for day buttons
// ══════════════════════════════════════════════════════
class _Day {
  final String key; // e.g. 'MON'
  final String label; // e.g. 'M'
  const _Day(this.key, this.label);
}

// ══════════════════════════════════════════════════════
//  Section title
// ══════════════════════════════════════════════════════
class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return CommonText(
      text: title,
      fontSize: 20,
      fontWeight: FontWeight.w500,
      textColor: AppColors.instance.primaryTextColor,
      isDescription: true,
      preventScaling: true,
    );
  }
}

// ══════════════════════════════════════════════════════
//  Toggle chip (Skills)
// ══════════════════════════════════════════════════════
class _ToggleChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ToggleChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected ? colors.primary : colors.white,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: isSelected ? colors.primary : colors.border,
          ),
        ),
        child: CommonText(
          text: label,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          textColor: isSelected ? colors.white : colors.textPrimary,
          isDescription: true,
          preventScaling: true,
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════
//  Day button (Availability)
// ══════════════════════════════════════════════════════
class _DayButton extends StatelessWidget {
  final _Day day;
  final bool isSelected;
  final VoidCallback onTap;

  const _DayButton({
    required this.day,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    final border = isSelected ? colors.secondaryColor : colors.border;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 42,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? colors.secondaryColor.withAlpha(20)
              : colors.white,
          border: Border.all(color: border, width: 1.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CommonText(
              text: day.key,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              textColor: isSelected
                  ? colors.secondaryColor
                  : colors.secondaryText,
              isDescription: true,
              preventScaling: true,
            ),
            4.height,
            CommonText(
              text: day.label,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              textColor: isSelected
                  ? colors.secondaryColor
                  : colors.textPrimary,
              isDescription: true,
              preventScaling: true,
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════
//  Dropdown selector (Rating / Language)
// ══════════════════════════════════════════════════════
class _DropdownSelector<T> extends StatelessWidget {
  final String hint;
  final T? value;
  final List<T> items;
  final ValueChanged<T?> onChanged;

  const _DropdownSelector({
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          hint: CommonText(
            text: hint,
            fontSize: 13,
            fontWeight: FontWeight.w400,
            textColor: colors.secondaryText,
            isDescription: true,
            preventScaling: true,
          ),
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: colors.secondaryText,
            size: 20,
          ),
          isExpanded: true,
          dropdownColor: colors.white,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: colors.primaryTextColor,
            fontFamily: AppConstant.instance.font,
          ),
          items: items
              .map(
                (item) => DropdownMenuItem<T>(
                  value: item,
                  child: Text(item.toString()),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
