import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:core_kit/core_kit.dart';

class PhoneTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String countryCode;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCountryChanged;
  final FormFieldValidator<String>? validator;
  final bool enabled;

  const PhoneTextField({
    super.key,
    this.controller,
    this.countryCode = '+1',
    this.hintText = '(555) 012-3456',
    this.onChanged,
    this.onCountryChanged,
    this.validator,
    this.enabled = true,
  });

  @override
  State<PhoneTextField> createState() => _PhoneTextFieldState();
}

class _PhoneTextFieldState extends State<PhoneTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;
  late String _selectedCountryCode;
  String _selectedFlag = '🇺🇸';

  @override
  void initState() {
    super.initState();
    _selectedCountryCode = widget.countryCode;
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
    return FormField<String>(
      validator: widget.validator,
      initialValue: widget.controller?.text,
      builder: (FormFieldState<String> state) {
        final bool hasError = state.hasError;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 45.h,
              decoration: BoxDecoration(
                color: AppColors.instance.primary.withAlpha(80),
                borderRadius: BorderRadius.circular(8.r),
              ),
              foregroundDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: hasError 
                      ? Colors.red 
                      : (_isFocused ? Colors.black.withAlpha(100) : AppColors.instance.screenBg),
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      showCountryPicker(
                        context: context,
                        showPhoneCode: true,
                        countryListTheme: CountryListThemeData(
                          borderRadius: BorderRadius.circular(16.r),
                          inputDecoration: InputDecoration(
                            hintText: 'Search country',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                        ),
                        onSelect: (Country country) {
                          setState(() {
                            _selectedCountryCode = '+${country.phoneCode}';
                            _selectedFlag = country.flagEmoji;
                          });
                          if (widget.onCountryChanged != null) {
                            widget.onCountryChanged!(_selectedCountryCode);
                          }
                        },
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            color: AppColors.instance.textPrimary.withAlpha(40),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _selectedFlag,
                            style: TextStyle(fontSize: 16.sp),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            _selectedCountryCode,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.instance.textPrimary,
                            ),
                          ),
                          Icon(Icons.arrow_drop_down, size: 20.w, color: AppColors.instance.textPrimary),
                          SizedBox(width: 4.w),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: widget.controller,
                      focusNode: _focusNode,
                      enabled: widget.enabled,
                      onChanged: (val) {
                        state.didChange(val);
                        if (widget.onChanged != null) widget.onChanged!(val);
                      },
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
            ),
            if (hasError)
              Padding(
                padding: EdgeInsets.only(top: 8.h, left: 4.w),
                child: Text(
                  state.errorText!,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12.sp,
                  ),
                ),
              ),
          ],
        );
      },
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