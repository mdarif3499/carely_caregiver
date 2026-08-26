import 'dart:io';
import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';

class EditableProfilePhoto extends StatelessWidget {
  final String? imageUrl;
  final File? file;
  final VoidCallback onUploadTap;

  const EditableProfilePhoto({
    super.key,
    this.imageUrl,
    this.file,
    required this.onUploadTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.border.withAlpha(100), width: 4),
                ),
                child: ClipOval(
                  child: file != null
                      ? Image.file(file!, fit: BoxFit.cover)
                      : CommonImage(
                          src: imageUrl ??
                              'https://images.unsplash.com/photo-1594824476967-48c8b964273f?q=80&w=1000&auto=format&fit=crop',
                          fill: BoxFit.cover,
                        ),
                ),
              ),
              Positioned(
                bottom: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4DB6FF), // Matches the vibrant light blue in design
                    shape: BoxShape.circle,
                    border: Border.all(color: colors.white, width: 3),
                  ),
                  child: const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: onUploadTap,
            child:const CommonText(
              text: 'Upload Photo',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              textColor: Color(0xFF4DB6FF),
            ),
          ),
        ],
      ),
    );
  }
}

class MedicalConditionsField extends StatelessWidget {
  final TextEditingController controller;
  const MedicalConditionsField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CommonText(
          text: 'Medical Conditions & Allergies',
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller,
          maxLines: 5,
          style: TextStyle(fontSize: 15, color: colors.textPrimary),
          decoration: InputDecoration(
            hintText: 'Example: Type 2 Diabetes, Penicillin allergy, limited mobility in left leg ...',
            hintStyle: TextStyle(fontSize: 14, color: colors.secondaryText.withAlpha(150)),
            filled: true,
            fillColor: colors.textFiledBg,
            contentPadding: const EdgeInsets.all(24),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32),
              borderSide: BorderSide(color: colors.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
