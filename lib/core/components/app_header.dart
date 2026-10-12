import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/tokens.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String statusText;
  final VoidCallback? onProfilePress;

  const AppHeader({
    super.key,
    this.statusText = 'Offline-Ready • Tersimpan Lokal',
    this.onProfilePress,
  });

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pagePaddingX,
        0,
        AppSpacing.pagePaddingX,
        0,
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 72,
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary100,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: AppShadows.raisedSm,
                ),
                child: const Icon(
                  Icons.eco_rounded,
                  color: AppColors.primary800,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppSpacing.s3),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TiramSehat',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary800,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: AppColors.primary600,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          statusText,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onProfilePress,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary600,
                    shape: BoxShape.circle,
                    boxShadow: AppShadows.raisedSm,
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: AppColors.textOnPrimary,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
