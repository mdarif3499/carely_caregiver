import 'package:core_kit/initializer.dart';
import 'package:core_kit/text/common_text.dart';
import 'package:core_kit/text_field/input_formatters/input_helper.dart';
import 'package:core_kit/utils/core_screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:core_kit/text_field/validation_type.dart';

class AppMultilineTextField extends StatefulWidget {
  const AppMultilineTextField({
    required this.validationType,
    super.key,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.controller,
    this.textInputAction = TextInputAction.next,
    this.prefixText,
    this.paddingHorizontal = 16,
    this.paddingVertical = 14,
    this.borderRadius = 12,
    this.onSaved,
    this.onChanged,
    this.borderColor,
    this.onTap,
    this.suffixIcon,
    this.isReadOnly = false,
    this.initialText,
    this.showActionButton = false,
    this.actionButtonIcon,
    this.originalPassword,
    this.validation,
    this.backgroundColor,
    this.borderWidth = 1.2,
    this.showValidationMessage = true,
    this.textAlign = TextAlign.left,
    this.height = 100,
    this.maxLength,
    this.maxWords,
    this.minLength = 0,
    this.counterTextStyle,
    this.minWords = 0,
    this.hintStyle,
  });

  final double borderWidth;
  final Function(String value, TextEditingController controller)? onSaved;
  final Function(String value)? onChanged;
  final String? initialText;
  final bool isReadOnly;
  final String? hintText;
  final String? labelText;
  final String? prefixText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? borderColor;
  final double paddingHorizontal;
  final double paddingVertical;
  final double borderRadius;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final TextInputAction textInputAction;
  final bool showActionButton;
  final Widget? actionButtonIcon;
  final ValidationType validationType;
  final String Function()? originalPassword;
  final Color? backgroundColor;
  final bool showValidationMessage;
  final TextAlign textAlign;
  final int? maxLength;
  final double height;
  final int? maxWords;
  final int minLength;
  final int minWords;
  final TextStyle? counterTextStyle;
  final TextStyle? hintStyle;

  final String? Function(String? value)? validation;

  @override
  State<AppMultilineTextField> createState() => _AppMultilineTextFieldState();
}

class _AppMultilineTextFieldState extends State<AppMultilineTextField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  late bool _obscureText;
  int wordCount = 0;
  int lengthCount = 0;
  bool _isLocalController = false;

  @override
  void initState() {
    super.initState();

    _obscureText =
        widget.validationType == ValidationType.validatePassword ||
        widget.validationType == ValidationType.validateConfirmPassword;
    
    if (widget.controller != null) {
      _controller = widget.controller!;
      _isLocalController = false;
    } else {
      _controller = TextEditingController();
      _isLocalController = true;
    }
    
    _focusNode = FocusNode();

    if (widget.initialText != null) {
      _controller.text = widget.initialText ?? '';
    }

    _focusNode.addListener(() {
      setState(() {});
    });
  }

  String _cleanText(String text) {
    if (text.trim().isEmpty) return text;
    String cleaned = text.replaceAll(RegExp(r'<[^>]*>'), '');
    cleaned = cleaned.replaceAll(RegExp(r'\s+'), ' ').trim();
    return cleaned;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    if (_isLocalController) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Color _iconColor() {
    return _focusNode.hasFocus ? CoreKit.instance.primaryColor : CoreKit.instance.outlineColor;
  }

  void _onSave(String? value) {
    if (widget.validationType == ValidationType.validateConfirmPassword)
      assert(
        widget.originalPassword != null,
        'Original Password can not be null for Confirm password field',
      );
    if (widget.onSaved == null) return;
    widget.onSaved!(value?.trim() ?? '', _controller);
  }

  Widget _buildPasswordSuffixIcon() {
    return GestureDetector(
      onTap: _togglePasswordVisibility,
      child: Padding(
        padding: EdgeInsetsDirectional.only(end: 10.w),
        child: Icon(
          _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          size: 20.sp,
        ),
      ),
    );
  }

  TextStyle _getStyle({
    FontWeight? fontWeight,
    double? fontSize,
    Color? textColor,
    double? height,
    FontStyle? fontStyle,
  }) {
    return TextStyle(
      fontFamily: CoreKit.instance.fontFamily,
      fontWeight: fontWeight,
      fontSize: fontSize,
      color: textColor,
      height: height,
      fontStyle: fontStyle,
    );
  }

  Color hintColor() {
    return CoreKit.instance.theme.inputDecorationTheme.hintStyle?.color ??
        CoreKit.instance.outlineColor;
  }

  OutlineInputBorder _buildBorder({required Color color, double? width}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius.r),
      borderSide: BorderSide(color: color, width: width ?? widget.borderWidth.w),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: widget.height),
      child: Column(
        children: [
          Expanded(
            child: TextFormField(
              textAlignVertical: TextAlignVertical.top,
              readOnly: widget.isReadOnly,
              maxLines: null,
              scrollPhysics: const BouncingScrollPhysics(),
              inputFormatters: [
                ...InputHelper.getInputFormatters(widget.validationType),
                if (widget.maxWords != null || widget.maxLength != null)
                  TextInputFormatter.withFunction((oldValue, newValue) {
                    final cleanedText = _cleanText(newValue.text);
                    if (widget.maxLength != null) {
                      final int length = cleanedText.length;
                      if (length <= widget.maxLength!) {
                        setState(() {
                          lengthCount = length;
                        });
                        return TextEditingValue(
                          text: newValue.text,
                          selection: TextSelection.collapsed(offset: newValue.text.length),
                        );
                      }
                      return oldValue;
                    }

                    final words = cleanedText.split(' ').where((word) => word.isNotEmpty).length;
                    if (words <= widget.maxWords! || newValue.text.length < oldValue.text.length) {
                      setState(() {
                        wordCount = words;
                      });
                      return TextEditingValue(
                        text: newValue.text,
                        selection: TextSelection.collapsed(offset: newValue.text.length),
                      );
                    }
                    return oldValue;
                  }),
              ],
              keyboardType: InputHelper.getKeyboardType(widget.validationType),
              textAlign: widget.textAlign,
              controller: _controller,
              focusNode: _focusNode,
              enableInteractiveSelection: !widget.isReadOnly,
              obscureText: _obscureText,
              onChanged: widget.onChanged,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              textInputAction: widget.textInputAction,
              onSaved: (v) {
                _onSave(v?.trim() ?? '');
              },
              maxLength: widget.maxLength,
              onFieldSubmitted: (v) {
                _onSave(v.trim());
              },
              onTap: widget.onTap,
              validator:
                  widget.validation ??
                  (value) {
                    final newValue = _cleanText(value?.trim() ?? '');
                    String? error = InputHelper.validate(
                      widget.validationType,
                      newValue,
                      originalPassword: widget.originalPassword?.call(),
                    );

                    if (newValue.isNotEmpty) {
                      if (widget.minLength > 0 && newValue.length < widget.minLength) {
                        error = 'Minimum ${widget.minLength} characters required';
                      }
                      final words = newValue.split(' ').where((w) => w.isNotEmpty).length;
                      if (widget.minWords > 0 && words < widget.minWords) {
                        error = 'Minimum ${widget.minWords} words required';
                      }
                      if (widget.maxWords != null && words > widget.maxWords!) {
                        error = 'Maximum ${widget.maxWords} words allowed';
                      }
                    }
                    return widget.showValidationMessage ? error : (error != null ? '' : null);
                  },
              style: _getStyle(fontWeight: FontWeight.w500, fontSize: 16.sp),
              expands: true,
              decoration: InputDecoration(
                filled: true,
                counterText: '',
                errorStyle: _getStyle(fontSize: 0, fontWeight: FontWeight.w400),
                fillColor: widget.backgroundColor,
                hintStyle: widget.hintStyle ??
                    _getStyle(
                      fontSize: CoreKit.instance.theme.inputDecorationTheme.hintStyle?.fontSize ?? 16.sp,
                      fontStyle: CoreKit.instance.theme.inputDecorationTheme.hintStyle?.fontStyle ?? FontStyle.italic,
                      textColor: hintColor(),
                    ),
                prefixIcon: Column(
                  children: [
                    widget.prefixText?.isNotEmpty == true
                        ? Padding(
                            padding: const EdgeInsets.only(left: 10, right: 5),
                            child: CommonText(text: widget.prefixText!, textColor: _iconColor()),
                          )
                        : Padding(
                            padding: EdgeInsets.only(left: 10.w, right: widget.paddingHorizontal),
                            child: widget.prefixIcon,
                          ),
                  ],
                ),
                suffixIconConstraints: BoxConstraints(
                  maxWidth: widget.suffixIcon == null && widget.validationType != ValidationType.validatePassword
                      ? widget.paddingHorizontal
                      : double.infinity,
                ),
                prefixIconConstraints: BoxConstraints(
                  maxWidth: widget.prefixIcon == null ? widget.paddingHorizontal : double.infinity,
                ),
                suffixIcon: widget.showActionButton
                    ? GestureDetector(
                        onTap: () {
                          _onSave(_controller.text.trim());
                        },
                        child: widget.actionButtonIcon ?? const Icon(Icons.search),
                      )
                    : widget.validationType == ValidationType.validatePassword
                    ? _buildPasswordSuffixIcon()
                    : Padding(
                        padding: EdgeInsets.only(right: 10, left: widget.paddingHorizontal),
                        child: widget.suffixIcon,
                      ),
                prefixIconColor: _iconColor(),
                suffixIconColor: _iconColor(),
                focusedBorder: _buildBorder(
                  color: widget.isReadOnly
                      ? (widget.borderColor ?? CoreKit.instance.outlineColor)
                      : CoreKit.instance.primaryColor,
                  width: widget.borderWidth.w,
                ),
                enabledBorder: _buildBorder(
                  color: widget.borderColor ?? CoreKit.instance.outlineColor,
                  width: widget.borderWidth.w,
                ),
                errorBorder: _buildBorder(color: Colors.red, width: widget.borderWidth.w),
                contentPadding: EdgeInsets.only(
                  left: widget.paddingHorizontal.w,
                  right: widget.paddingHorizontal.w,
                  top: widget.paddingVertical.h,
                  bottom: widget.paddingVertical.h,
                ),
                hintText: widget.hintText,
                labelText: widget.labelText,
              ),
            ),
          ),
          if ((widget.maxLength ?? 0) > 0 || (widget.maxWords ?? 0) > 0)
            Row(
              children: [
                const Spacer(),
                Text(
                  (widget.maxLength ?? 0) > 0
                      ? '$lengthCount/${widget.maxLength}'
                      : '$wordCount/${widget.maxWords}',
                  style: widget.counterTextStyle ?? _getStyle(fontSize: 12.sp, textColor: CoreKit.instance.outlineColor),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
