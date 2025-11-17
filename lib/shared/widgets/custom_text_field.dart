import 'package:android_chat_app/core/constants/app_colors.dart';
import 'package:android_chat_app/core/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heroicons/heroicons.dart';

class CustomTextField extends StatefulWidget {
  final double? width;
  final double height;
  final double radius;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String? hintText;
  final double fontSize;
  final int maxLines;
  final Function(String value)? onChange;
  final CustomTextFieldType type;
  final CustomTextFieldTheme theme;

  const CustomTextField({
    super.key,
    this.width,
    required this.height,
    required this.radius,
    required this.controller,
    this.focusNode,
    this.hintText,
    required this.fontSize,
    required this.maxLines,
    this.onChange,
    required this.type,
    required this.theme,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isObscure = true;

  Center textField() {
    return Center(
      child: TextField(
        controller: widget.controller,
        keyboardType: widget.type == CustomTextFieldType.phone
            ? TextInputType.phone
            : widget.type == CustomTextFieldType.email
            ? TextInputType.emailAddress
            : widget.type == CustomTextFieldType.otp
            ? TextInputType.number
            : TextInputType.text,
        focusNode: widget.type == CustomTextFieldType.otp
            ? widget.focusNode
            : null,
        textAlign: widget.type != CustomTextFieldType.otp
            ? TextAlign.start
            : TextAlign.center,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: widget.theme == CustomTextFieldTheme.light
                ? AppColors.textSecondary
                : AppColors.darkTextSecondary,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
        style: TextStyle(
          color: widget.theme == CustomTextFieldTheme.light
              ? AppColors.textPrimary
              : AppColors.darkTextPrimary,
          fontSize: widget.fontSize,
        ),
        maxLines: widget.maxLines,
        onChanged: widget.onChange,
        obscureText: widget.type != CustomTextFieldType.password
            ? false
            : _isObscure,
        inputFormatters: [
          if (widget.type == CustomTextFieldType.otp) ...[
            LengthLimitingTextInputFormatter(1),
            FilteringTextInputFormatter.digitsOnly,
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? AppSizes.screenWidth(context),
      height: widget.height,
      padding: widget.type != CustomTextFieldType.password
          ? const EdgeInsets.symmetric(horizontal: AppSizes.paddingM)
          : const EdgeInsets.only(
              left: AppSizes.paddingM,
              right: AppSizes.paddingS,
            ),
      decoration: BoxDecoration(
        color: widget.theme == CustomTextFieldTheme.light
            ? Colors.grey[200]
            : Colors.grey[800],
        borderRadius: BorderRadius.circular(widget.radius),
      ),
      child: widget.type == CustomTextFieldType.password
          ? Row(
              children: [
                Expanded(child: textField()),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                  icon: HeroIcon(
                    _isObscure ? HeroIcons.eyeSlash : HeroIcons.eye,
                    style: HeroIconStyle.outline,
                  ),
                ),
              ],
            )
          : widget.type == CustomTextFieldType.phone
          ? Row(
              children: [
                Text(
                  '+62',
                  style: TextStyle(
                    color: widget.theme == CustomTextFieldTheme.light
                        ? AppColors.textPrimary
                        : AppColors.darkTextPrimary,
                    fontSize: widget.fontSize,
                  ),
                ),
                SizedBox(width: AppSizes.paddingM),
                Expanded(child: textField()),
              ],
            )
          : textField(),
    );
  }
}

enum CustomTextFieldType { text, password, phone, email, otp }

enum CustomTextFieldTheme { light, dark }
