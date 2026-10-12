import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/tokens.dart';
import 'neu_surface.dart';

class CurrencyField extends StatefulWidget {
  final int value;
  final ValueChanged<int> onChange;
  final String prefix;

  const CurrencyField({
    super.key,
    required this.value,
    required this.onChange,
    this.prefix = 'Rp',
  });

  @override
  State<CurrencyField> createState() => _CurrencyFieldState();
}

class _CurrencyFieldState extends State<CurrencyField> {
  late TextEditingController _controller;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _format(widget.value));
  }

  @override
  void didUpdateWidget(CurrencyField old) {
    super.didUpdateWidget(old);
    if (!_isFocused && old.value != widget.value) {
      _controller.text = _format(widget.value);
    }
  }

  String _format(int v) {
    if (v == 0) return '';
    final str = v.toString();
    final buffer = StringBuffer();
    final len = str.length;
    for (int i = 0; i < len; i++) {
      if (i > 0 && (len - i) % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
    }
    return buffer.toString();
  }

  int _parse(String s) {
    final clean = s.replaceAll('.', '').replaceAll(',', '');
    return int.tryParse(clean) ?? 0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NeuSurface(
      variant: NeuVariant.inset,
      radius: AppRadius.tile,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s4,
        vertical: AppSpacing.s3,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '${widget.prefix} ',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
          Expanded(
            child: Focus(
              onFocusChange: (focused) {
                setState(() => _isFocused = focused);
                if (!focused) {
                  final parsed = _parse(_controller.text);
                  widget.onChange(parsed);
                  _controller.text = _format(parsed);
                }
              },
              child: TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
                decoration: const InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: (val) {
                  final parsed = _parse(val);
                  widget.onChange(parsed);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
