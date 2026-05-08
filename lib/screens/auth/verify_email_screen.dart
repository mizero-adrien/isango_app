import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/constants/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  int _cooldownSeconds = 0;
  Timer? _cooldownTimer;

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    super.dispose();
  }

  void _handleResend() {
    if (_cooldownSeconds > 0) return;
    // TODO: replace with real resend-verification-email call
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Verification email sent!',
          style: AppTextStyles.bodyMuted.copyWith(color: AppColors.cardWhite),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primaryContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.input),
        ),
      ),
    );
    _startCooldown();
  }

  void _startCooldown() {
    setState(() => _cooldownSeconds = 120);
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_cooldownSeconds <= 1) {
        timer.cancel();
        setState(() => _cooldownSeconds = 0);
      } else {
        setState(() => _cooldownSeconds--);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.cardWhite,
        elevation: 0,
        scrolledUnderElevation: 4,
        shadowColor: Colors.black.withValues(alpha: 0.10),
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryContainer),
          tooltip: 'Go back',
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            }
          },
        ),
        title: Text('Verify Email', style: AppTextStyles.headline),
        centerTitle: true,
        actions: const [SizedBox(width: 48)],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
              child: ConstrainedBox(
                // Ensure the column fills at least the full visible height so
                // the support text can be pinned to the bottom via a Spacer.
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - AppSpacing.page,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: AppSpacing.lg),
                      const _StatusPanel(),
                      const SizedBox(height: AppSpacing.lg),
                      const _WhyVerifyPanel(),
                      const SizedBox(height: AppSpacing.xl),
                      _ResendButton(
                        cooldownSeconds: _cooldownSeconds,
                        onPressed: _handleResend,
                      ),
                      const Spacer(),
                      const _SupportText(),
                      const SizedBox(height: AppSpacing.md),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ── Private widgets ──────────────────────────────────────────────────────────

class _StatusPanel extends StatelessWidget {
  const _StatusPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: AppColors.softBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        children: [
          // Email icon in tinted circle
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: AppColors.paleSignalBlue, // secondary-fixed: #dce1ff
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.mark_email_unread_rounded,
              size: 32,
              color: AppColors.primaryContainer,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Verification Pending',
            style: AppTextStyles.headline,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            "We've sent a verification link to your student email. "
            'Please check your inbox to activate your account.',
            style: AppTextStyles.body.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _WhyVerifyPanel extends StatelessWidget {
  const _WhyVerifyPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow, // #f4f3fa
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(
              Icons.verified_rounded,
              color: AppColors.secondary, // #4059aa
              size: 22,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Why verify your email?',
                  style: AppTextStyles.title,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Verified students can RSVP to exclusive campus events, '
                  'create their own event listings, and receive priority notifications.',
                  style: AppTextStyles.bodyMuted,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ResendButton extends StatelessWidget {
  const _ResendButton({
    required this.cooldownSeconds,
    required this.onPressed,
  });

  final int cooldownSeconds;
  final VoidCallback onPressed;

  bool get _enabled => cooldownSeconds == 0;

  String get _label {
    if (_enabled) return 'Resend Verification Email';
    final m = cooldownSeconds ~/ 60;
    final s = (cooldownSeconds % 60).toString().padLeft(2, '0');
    return m > 0 ? 'Resend in ${m}m ${s}s' : 'Resend in ${s}s';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        key: const Key('resendButton'),
        onPressed: _enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryContainer,
          foregroundColor: AppColors.cardWhite,
          disabledBackgroundColor:
              AppColors.primaryContainer.withValues(alpha: 0.55),
          disabledForegroundColor: AppColors.cardWhite.withValues(alpha: 0.7),
          elevation: 0,
          shadowColor: Colors.black.withValues(alpha: 0.15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.button),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_enabled ? Icons.send_rounded : Icons.timer_outlined, size: 18),
            const SizedBox(width: AppSpacing.xs),
            Text(
              _label,
              style: AppTextStyles.label.copyWith(
                color: AppColors.cardWhite,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SupportText extends StatelessWidget {
  const _SupportText();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.lg),
      child: Text(
        "Can't find the email? Check your spam folder or try resending in 2 minutes.",
        style: AppTextStyles.bodyMuted.copyWith(color: AppColors.outline),
        textAlign: TextAlign.center,
      ),
    );
  }
}
