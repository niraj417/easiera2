import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class BHTextInput extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final bool obscureText;
  final Widget? suffix;
  final Widget? prefix;
  final int? maxLines;
  final VoidCallback? onTap;
  final bool readOnly;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChanged;

  const BHTextInput({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.obscureText = false,
    this.suffix,
    this.prefix,
    this.maxLines = 1,
    this.onTap,
    this.readOnly = false,
    this.inputFormatters,
    this.onChanged,
  });

  @override
  State<BHTextInput> createState() => _BHTextInputState();
}

class _BHTextInputState extends State<BHTextInput> {
  bool _focused = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() => _focused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppTypography.labelMedium.copyWith(
            color: _focused ? AppColors.primaryBlue : AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          obscureText: widget.obscureText,
          maxLines: widget.maxLines,
          onTap: widget.onTap,
          readOnly: widget.readOnly,
          inputFormatters: widget.inputFormatters,
          onChanged: widget.onChanged,
          style: AppTypography.bodyLarge.copyWith(
            color: AppColors.textPrimary,
            fontFamily: 'RobotoMono',
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            suffixIcon: widget.suffix,
            prefixIcon: widget.prefix,
          ),
        ),
      ],
    );
  }
}

class BHPhoneInput extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const BHPhoneInput({super.key, this.controller, this.validator});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Mobile Number', style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Row(
                children: [
                  Text('🇮🇳 +91', style: AppTypography.bodyLarge),
                  const SizedBox(width: 4),
                  const Icon(Icons.keyboard_arrow_down, size: 16),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                controller: controller,
                keyboardType: TextInputType.phone,
                validator: validator,
                maxLength: 10,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: AppTypography.dataMono,
                decoration: InputDecoration(
                  hintText: '98765 43210',
                  counterText: '',
                  hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textTertiary),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class BHOTPInput extends StatelessWidget {
  final List<TextEditingController> controllers;
  final void Function(String)? onCompleted;

  const BHOTPInput({super.key, required this.controllers, this.onCompleted});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (index) {
        return SizedBox(
          width: 44,
          height: 52,
          child: TextFormField(
            controller: controllers[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: AppTypography.headlineLarge.copyWith(
              color: AppColors.primaryBlue,
            ),
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: index < controllers.length && controllers[index].text.isNotEmpty
                  ? AppColors.lightBlue
                  : Colors.white,
              contentPadding: EdgeInsets.zero,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.borderLight),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
              ),
            ),
            onChanged: (value) {
              if (value.isNotEmpty && index < 5) {
                FocusScope.of(context).nextFocus();
              }
            },
          ),
        );
      }),
    );
  }
}

class BHSearchField extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  final void Function(String)? onChanged;

  const BHSearchField({super.key, this.hint = 'Search...', this.controller, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: AppTypography.bodyLarge,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.search, color: AppColors.neutralGrey),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
