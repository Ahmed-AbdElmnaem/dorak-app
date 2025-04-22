import 'package:dorak_app/core/theming/color_manager.dart';
import 'package:dorak_app/core/theming/styles.dart';
import 'package:flutter/material.dart';

class AppTextFormField extends StatelessWidget {
  final EdgeInsetsGeometry? contentPadding;
  final String hintText;
  final Widget? suffixIcon;
  final bool obsecureText;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final InputBorder? errordBorder;
  final InputBorder? focusedErrorBorder;
  final TextStyle? hintStyle;
  final TextInputType? keyboardType;
  final Color? backgroundColor;
  final Widget? prefixIcon;
  final TextEditingController? controller;
  final Function(String? value) validator;
  final Function()? onTap;
  final int? maxLines;
  final int? minLines;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;

  const AppTextFormField({
    super.key,
    required this.hintText,
    this.suffixIcon,
    this.obsecureText = false,
    this.enabledBorder,
    this.focusedBorder,
    this.hintStyle,
    this.contentPadding,
    this.keyboardType,
    this.backgroundColor,
    this.controller,
    required this.validator,
    this.errordBorder,
    this.focusedErrorBorder,
    this.prefixIcon,
    this.onTap,
    this.maxLines,
    this.minLines,
    this.focusNode,
    this.textInputAction,
  });

  static ValueNotifier<bool> isObsecure = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isObsecure,
      builder:
          (state, value, child) => TextFormField(
            textInputAction: textInputAction, // للتنقل بين الحقول
            onTap: onTap,
            maxLines: value ? 1 : maxLines ?? 1,
            focusNode: focusNode ?? FocusNode(),
            minLines: value ? 1 : minLines ?? 1,
            controller: controller,
            obscureText: !obsecureText ? false : isObsecure.value,
            keyboardType: keyboardType ?? TextInputType.text,
            style: Styles.font14W400,
            decoration: InputDecoration(
              prefixIcon: prefixIcon,
              fillColor:
                  backgroundColor ?? ColorManager.white.withValues(alpha: 0.2),
              filled: true,
              isDense: true,
              contentPadding:
                  contentPadding ??
                  EdgeInsets.symmetric(vertical: 14.0, horizontal: 10.0),
              enabledBorder:
                  enabledBorder ??
                  buildOutLineBorder(
                    color: ColorManager.mainColor.withValues(alpha: 0.5),
                  ),
              focusedBorder: buildOutLineBorder(),
              errorBorder:
                  errordBorder ??
                  buildOutLineBorder(color: ColorManager.errorColor),
              focusedErrorBorder:
                  focusedErrorBorder ?? buildOutLineBorder(color: Colors.red),
              hintStyle: Styles.font14W400.copyWith(
                color: ColorManager.greyText,
              ),
              hintText: hintText,
              suffixIcon:
                  obsecureText
                      ? IconButton(
                        onPressed: () {
                          isObsecure.value = !isObsecure.value;
                        },
                        icon:
                            !value
                                ? const Icon(Icons.visibility_off)
                                : const Icon(Icons.visibility),
                      )
                      : null,
            ),
            validator: (value) {
              return validator(value);
            },
          ),
    );
  }

  OutlineInputBorder buildOutLineBorder({Color? color}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(34.0),
      borderSide: BorderSide(color: color ?? ColorManager.borderColor),
    );
  }
}
