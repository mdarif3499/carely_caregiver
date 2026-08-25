import 'dart:convert';
import 'dart:developer';

import 'package:carely_caregiver/repositories/client_repository.dart';
import 'package:carely_caregiver/routes/app_routes.dart';
import 'package:carely_caregiver/screens/client_screen/care_giver_details_screen/model/care_giver_profile_model.dart';
import 'package:carely_caregiver/screens/client_screen/find_caregiver_screen/controller/find_caregiver_controller.dart';
import 'package:carely_caregiver/utils/log/app_log.dart';
import 'package:carely_caregiver/widgets/app_calendar_controller.dart';
import 'package:carely_caregiver/widgets/show_custom_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../care_recipients_screen/controller/care_recipients_controller.dart';
import '../../select_service_type_screen/controller/selected_service_type_controller.dart';

// ── Time Slot Model ──────────────────────────────────────
class TimeSlot {
  final String startTime;
  final String endTime;
  final String status;
  final String shiftType;

  const TimeSlot({
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.shiftType,
  });

  factory TimeSlot.fromJson(Map<String, dynamic> json, String shiftType, String defaultEndTime) {
    return TimeSlot(
      startTime: json['startTime'] ?? "",
      endTime: json['endTime'] ?? defaultEndTime,
      status: json['status'] ?? "",
      shiftType: shiftType,
    );
  }

  String get label => _formatToUiTime(startTime);

  String _formatToUiTime(String apiTime) {
    try {
      final parts = apiTime.split(':');
      final hour = int.parse(parts[0]);
      final min = int.parse(parts[1]);
      final dt = DateTime(0, 1, 1, hour, min);
      return DateFormat('hh:mm a').format(dt);
    } catch (e) {
      return apiTime;
    }
  }
}

// ── Shift Model ──────────────────────────────────────────
class CaregiverShift {
  final String shiftType;
  final List<TimeSlot> slots;

  const CaregiverShift({required this.shiftType, required this.slots});
}

// ── Controller ───────────────────────────────────────────
class BookCaregiverController extends GetxController
    with AppCalendarController {
  
  final Rxn<CaregiverModel> caregiver = Rxn<CaregiverModel>();
  final RxBool isLoading = false.obs;
  final RxBool isBooking = false.obs;
  
  RxBool rebuild = false.obs;
  // ── Calendar ──
  @override
  final Rx<DateTime> focusedMonth = DateTime.now().obs;
  @override
  final Rx<DateTime> selectedDay = DateTime.now().obs;

  // ── API Data ──
  final RxList<CaregiverShift> availableShifts = <CaregiverShift>[].obs;

  // ── Selection State ──
  final Rxn<RecipientModel> selectedRecipient = Rxn<RecipientModel>();

  // ── Booking Inputs ──
  late final TextEditingController instructionsController;

  @override
  void onInit() {
    super.onInit();
    instructionsController = TextEditingController();
    final args = Get.arguments;
    
    if (args is Map) {
      final profile = args['profile'];
      final DateTime? date = args['selectedDate'];

      if (profile is CareGiverProfileModel) {
        caregiver.value = CaregiverModel(
          id: profile.id,
          name: profile.name,
          role: 'Caregiver',
          specialty: profile.specialties.isNotEmpty ? profile.specialties.first : 'General Care',
          description: profile.bio,
          rating: profile.averageRating,
          hourlyRate: profile.hourlyRate,
          avatarUrl: profile.profileImage,
        );
      }

      if (date != null) {
        selectedDay.value = date;
        focusedMonth.value = DateTime(date.year, date.month, 1);
      }
    } else if (args is CaregiverModel) {
      caregiver.value = args;
    }
    
    // Auto-select first recipient if available
    _initRecipient();

    // Initial fetch
    fetchCaregiverAvailability();
  }

  void _initRecipient() {
    try {
      final recipientController = Get.find<CareRecipientsController>();
      if (recipientController.recipients.isNotEmpty) {
        selectedRecipient.value = recipientController.recipients.first;
      }
      
      // Watch for changes in recipients list (e.g. if loaded after onInit)
      ever(recipientController.recipients, (list) {
        if (selectedRecipient.value == null && list.isNotEmpty) {
          selectedRecipient.value = list.first;
        }
      });
    } catch (_) {}
  }

  @override
  void onClose() {
    instructionsController.dispose();
    super.onClose();
  }

  Future<void> fetchCaregiverAvailability() async {
    final id = caregiver.value?.id;
    if (id == null || id.isEmpty) {
      appLog("Cannot fetch availability: Caregiver ID is null or empty", source: "AVAILABILITY_API");
      return;
    }

    try {
      isLoading.value = true;
      update();

      final selectedDate = selectedDay.value;
      final dateStr = DateFormat('yyyy-MM-dd').format(selectedDate);

      appLog("STARTING API CALL - ID: $id, Date: $dateStr", source: "AVAILABILITY_API");
      
      final response = await ClientRepository.instance.getCaregiverAvailability(
        caregiverId: id,
        startDate: dateStr,
        endDate: dateStr,
      );

      if (response.isSuccess) {
        final List dataList = response.data['data'] ?? [];
        availableShifts.clear();

        if (dataList.isNotEmpty) {
          final dayData = dataList[0];
          final List shiftList = dayData['shifts'] ?? [];
          
          for (var s in shiftList) {
            final String type = s['shiftType'] ?? "MORNING";
            final String shiftEnd = s['endTime'] ?? "00:00";
            final List slotList = s['slots'] ?? [];
            
            final List<TimeSlot> availableSlots = [];
            
            for (int i = 0; i < slotList.length; i++) {
              final slotJson = slotList[i];
              if ((slotJson['status'] ?? "").toString().toUpperCase() == 'AVAILABLE') {
                // Determine end time: next slot's start time or shift end time
                String nextStartTime = shiftEnd;
                if (i + 1 < slotList.length) {
                  nextStartTime = slotList[i + 1]['startTime'] ?? shiftEnd;
                }
                
                availableSlots.add(TimeSlot.fromJson(slotJson, type, nextStartTime));
              }
            }

            if (availableSlots.isNotEmpty) {
              availableSlots.sort((a, b) => a.startTime.compareTo(b.startTime));
              
              String displayType = type;
              if (type.toUpperCase() == 'AFTERNOON') {
                final firstSlotHour = int.tryParse(availableSlots.first.startTime.split(':')[0]) ?? 0;
                if (firstSlotHour >= 17) {
                  displayType = 'EVENING';
                }
              }
              
              availableShifts.add(CaregiverShift(
                shiftType: displayType,
                slots: availableSlots,
              ));
            }
          }
        }
      } else {
        showCustomSnackbar(message: response.message, isError: true);
      }
    } catch (e) {
      appLog("Error fetching caregiver availability: $e", source: "AVAILABILITY_API");
    } finally {
      isLoading.value = false;
      update();
    }
  }

  @override
  void previousMonth() {
    focusedMonth.value = DateTime(
      focusedMonth.value.year,
      focusedMonth.value.month - 1,
    );
  }

  @override
  void nextMonth() {
    focusedMonth.value = DateTime(
      focusedMonth.value.year,
      focusedMonth.value.month + 1,
    );
  }

  @override
  void selectDay(DateTime day) {
    if (day.month != focusedMonth.value.month) return;
    selectedDay.value = day;
    rebuild.value = !rebuild.value;
    
    selectedSlot.value = null;
    availableShifts.clear();
    
    fetchCaregiverAvailability();
  }

  @override
  bool isSelected(DateTime day) {
    final s = selectedDay.value;
    return s.year == day.year && s.month == day.month && s.day == day.day;
  }

  @override
  bool isToday(DateTime day) {
    final now = DateTime.now();
    return day.year == now.year && day.month == now.month && day.day == now.day;
  }

  @override
  List<DateTime> get calendarDays {
    final first = DateTime(
      focusedMonth.value.year,
      focusedMonth.value.month,
      1,
    );
    final startOffset = first.weekday % 7;
    final start = first.subtract(Duration(days: startOffset));
    return List.generate(42, (i) => start.add(Duration(days: i)));
  }

  final Rx<TimeSlot?> selectedSlot = Rx<TimeSlot?>(null);

  void selectSlot(TimeSlot slot) {
    selectedSlot.value = slot;
  }

  bool isSlotSelected(TimeSlot slot) => selectedSlot.value?.startTime == slot.startTime;

  // ── Summary ──
  String get selectedScheduleText {
    final day = selectedDay.value;
    final slot = selectedSlot.value;
    if (slot == null) return 'No schedule selected';
    final formatted = DateFormat('MMM d').format(day);
    return '$formatted, ${slot.label}';
  }

  Future<void> confirmSchedule() async {
    final slot = selectedSlot.value;
    if (slot == null) {
      showCustomSnackbar(message: 'Please select a date and time.', isError: true);
      return;
    }
    if (selectedRecipient.value == null) {
      showCustomSnackbar(message: 'Please select a care recipient.', isError: true);
      return;
    }

    try {
      isBooking.value = true;
      update();

      // Gather external IDs
      String? caregiverId = caregiver.value?.id;
      String? careRecipientId = selectedRecipient.value?.id;
      
      // Get Service Category ID from SelectedServiceTypeController
      String serviceCategoryId = "";
      try {
        final serviceController = Get.find<SelectedServiceTypeController>();
        if (serviceController.serviceTypes.isNotEmpty && 
            serviceController.selectedIndex.value < serviceController.serviceTypes.length) {
          serviceCategoryId = serviceController.serviceTypes[serviceController.selectedIndex.value].id;
        }
      } catch (_) {}

      final bookingData = {
        "caregiver": caregiverId,
        "careRecipient": careRecipientId,
        "serviceCategory": serviceCategoryId,
        "date": DateFormat('yyyy-MM-dd').format(selectedDay.value),
        "shift": slot.shiftType,
        "slotStartTime": slot.startTime,
        "slotEndTime": slot.endTime,
        "instructions": instructionsController.text,
      };

      appLog("BOOKING REQUEST BODY: ${const JsonEncoder.withIndent('  ').convert(bookingData)}", source: "BOOKING_API");

      final response = await ClientRepository.instance.createBooking(data: bookingData);

      if (response.isSuccess) {
        log("BOOKING SUCCESS DATA: ${response.data}");

        final String? checkoutUrl = response.data['data']?['checkoutUrl'];
        
        if (checkoutUrl != null && checkoutUrl.isNotEmpty) {
          Get.toNamed(AppRoutes.instance.stripePaymentWebView, arguments: checkoutUrl);
        } else {
          showCustomSnackbar(message: "Booking confirmed, but payment link not found.", isError: true);
          Get.offAllNamed(AppRoutes.instance.appNavigationScreen);
        }
      } else {
        showCustomSnackbar(message: response.message, isError: true);
      }
    } catch (e) {
      appLog("Error creating booking: $e", source: "BOOKING_API");
      showCustomSnackbar(message: "Failed to confirm booking", isError: true);
    } finally {
      isBooking.value = false;
      update();
    }
  }
}
