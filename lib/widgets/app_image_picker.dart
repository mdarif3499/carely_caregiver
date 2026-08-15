import 'dart:io';

import 'package:core_kit/core_kit.dart';
import 'package:core_kit/utils/core_screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AppImagePicker extends StatefulWidget {
  const AppImagePicker({
    super.key,
    this.width = 160,
    this.height = 160,
    this.borderRadius = 10,
    this.pickerIcon = Icons.image,
    this.onSaved,
    this.onChanged,
    this.validator,
  });

  final double width;
  final double height;
  final double borderRadius;
  final IconData pickerIcon;
  final void Function(XFile?)? onSaved;
  final void Function(XFile?)? onChanged;
  final FormFieldValidator<XFile>? validator;

  @override
  State<AppImagePicker> createState() => _AppImagePickerState();
}

class _AppImagePickerState extends State<AppImagePicker> {
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImages;
  bool _isPicking = false;

  Future<void> _pickImage(FormFieldState<XFile> fieldState) async {
    if (_isPicking) return;

    try {
      setState(() => _isPicking = true);

      // image_picker handles its own permission needs for gallery access
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (picked != null) {
        setState(() {
          _selectedImages = picked;
        });
        fieldState.didChange(_selectedImages);
        if (widget.onChanged != null) {
          widget.onChanged!(_selectedImages);
        }
      }
    } catch (e) {
      debugPrint("AppImagePicker Error: $e");
    } finally {
      if (mounted) {
        setState(() => _isPicking = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormField<XFile>(
      initialValue: _selectedImages,
      validator: widget.validator,
      onSaved: widget.onSaved,
      builder: (fieldState) {
        final hasError = fieldState.hasError;
        final borderColor = hasError ? Colors.red : Colors.transparent;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => _pickImage(fieldState),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(widget.borderRadius.r),
                child: Container(
                  width: widget.width.w,
                  height: widget.height.h,
                  decoration: BoxDecoration(
                    border: Border.all(color: borderColor, width: 1.5),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Center(
                    child: Icon(
                      widget.pickerIcon,
                      size: widget.width * 0.5,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            if (hasError)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  fieldState.errorText!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12.sp),
                ),
              ),
          ],
        );
      },
    );
  }
}
