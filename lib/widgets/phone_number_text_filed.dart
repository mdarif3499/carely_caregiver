import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:core_kit/core_kit.dart';

class PhoneTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String countryCode;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final bool enabled;

  const PhoneTextField({
    super.key,
    this.controller,
    this.countryCode = '+1',
    this.hintText = '(555) 012-3456',
    this.onChanged,
    this.validator,
    this.enabled = true,
  });

  @override
  State<PhoneTextField> createState() => _PhoneTextFieldState();
}

class _PhoneTextFieldState extends State<PhoneTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45.h,
      // ✅ SAME background & radius
      decoration: BoxDecoration(
        color: AppColors.instance.primary.withAlpha(80),
        borderRadius: BorderRadius.circular(8.r),
      ),

      // ✅ SAME border, just drawn on top
      foregroundDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: _isFocused
              ? Colors.black.withAlpha(100)
              : AppColors.instance.screenBg,
          width: 1.5,
        ),
      ),

      child: Row(
        children: [
          // Country Code Section (UNCHANGED)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.countryCode,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.instance.textPrimary,
                  ),
                ),
                SizedBox(width: 6.w),
              ],
            ),
          ),

          // Phone Number Input (UNCHANGED)
          Expanded(
            child: TextFormField(
              controller: widget.controller,
              focusNode: _focusNode,
              enabled: widget.enabled,
              onChanged: widget.onChanged,
              validator: widget.validator,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                _PhoneNumberFormatter(),
              ],
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF1A1A2E),
              ),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFFAEADC0),
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.only(
                  top: 12.h,
                  bottom: 12.h,
                  right: 8.w,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Formats input as (XXX) XXX-XXXX
class _PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();

    for (int i = 0; i < digits.length && i < 10; i++) {
      if (i == 0) buffer.write('(');
      if (i == 3) buffer.write(') ');
      if (i == 6) buffer.write('-');
      buffer.write(digits[i]);
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}