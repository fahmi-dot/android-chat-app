import 'package:android_chat_app/core/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heroicons/heroicons.dart';

class CustomTextField extends StatefulWidget {
  final double? width;
  final double? height;
  final double? radius;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String? hintText;
  final bool? showHint;
  final int maxLines;
  final Function(String value)? onChange;
  final CustomTextFieldType type;

  const CustomTextField({
    super.key,
    this.width,
    this.height,
    this.radius,
    required this.controller,
    this.focusNode,
    this.hintText,
    this.showHint = true,
    required this.maxLines,
    this.onChange,
    required this.type,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isObscure = true;
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }

    super.dispose();
  }

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
        focusNode: _focusNode,
        textAlign: widget.type == CustomTextFieldType.otp
            ? TextAlign.center
            : TextAlign.start,
        decoration: InputDecoration(
          label: widget.showHint! ? Text(widget.hintText!) : null,
          labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
        style: widget.type == CustomTextFieldType.otp
            ? Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              )
            : Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
        maxLines: widget.maxLines,
        onChanged: widget.onChange,
        obscureText: widget.type == CustomTextFieldType.password
            ? _isObscure
            : false,
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
      height: widget.height ?? AppSizes.screenHeight(context) * 0.06,
      padding: widget.type != CustomTextFieldType.password
          ? const EdgeInsets.symmetric(horizontal: AppSizes.paddingM)
          : const EdgeInsets.only(
              left: AppSizes.paddingM,
              right: AppSizes.paddingS,
            ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(widget.radius ?? AppSizes.radiusM),
        border: Border.all(
          color: _focusNode.hasFocus
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surface,
          width: _focusNode.hasFocus ? 2 : 0,
        ),
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
                    color: Theme.of(context).colorScheme.onSurface,
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
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
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
