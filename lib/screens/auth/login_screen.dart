import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_theme.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';

  Future<void> _onLogin(BuildContext context, WidgetRef ref) async {
    final auth = ref.read(authProvider);
    if (_formKey.currentState?.validate() ?? false) {
      await auth.login(email, password);
      if (auth.user != null) {
        if (context.mounted) {
          context.go('/dashboard');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [kWhite, kWhiteGrey],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        decoration: BoxDecoration(
                          color: kWhite.withAlpha(180),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: kBlack.withAlpha((0.06 * 255).toInt()),
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: kBlack.withAlpha((0.08 * 255).toInt()),
                              blurRadius: 34,
                              offset: const Offset(0, 18),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
                                    colors: [kWhiteGrey, kWhite],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  border: Border.all(
                                    color: kBlack.withAlpha(
                                      (0.05 * 255).toInt(),
                                    ),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: kBlack.withAlpha(
                                        (0.10 * 255).toInt(),
                                      ),
                                      blurRadius: 34,
                                      offset: const Offset(0, 14),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(22.0),
                                  child: Image.asset(
                                    'assets/logo/attendx24_logo.png',
                                    width: 96,
                                    height: 96,
                                    filterQuality: FilterQuality.high,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 18),
                              Text(
                                'Admin Login',
                                style: kHeaderTextStyle(context).copyWith(
                                  color: kBlack,
                                  fontSize: Responsive.fontSize(context, 28),
                                  letterSpacing: 1.0,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Sign in to access the system',
                                textAlign: TextAlign.center,
                                style: kCaptionTextStyle(context).copyWith(
                                  color: kBrown.withAlpha((0.80 * 255).toInt()),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 22),
                              Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    TextFormField(
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(
                                          Iconsax.direct_right,
                                          color: kBrown,
                                        ),
                                        labelText: 'Email',
                                        filled: true,
                                        fillColor: kWhiteGrey.withAlpha(160),
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                      onChanged: (val) => email = val.trim(),
                                      validator: (val) =>
                                          val == null || val.trim().isEmpty
                                          ? 'Enter your email'
                                          : null,
                                    ),
                                    const SizedBox(height: 14),
                                    TextFormField(
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(
                                          Iconsax.lock,
                                          color: kBrown,
                                        ),
                                        labelText: 'Password',
                                        filled: true,
                                        fillColor: kWhiteGrey.withAlpha(160),
                                      ),
                                      obscureText: true,
                                      onChanged: (val) => password = val,
                                      validator: (val) =>
                                          val == null || val.isEmpty
                                          ? 'Enter your password'
                                          : null,
                                    ),
                                    const SizedBox(height: 10),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        onPressed: () {},
                                        child: Text(
                                          'Forgot Password?',
                                          style: kCaptionTextStyle(
                                            context,
                                          ).copyWith(color: kerror),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        style: kPremiumButtonStyle(context)
                                            .copyWith(
                                              padding: WidgetStateProperty.all(
                                                const EdgeInsets.symmetric(
                                                  vertical: 16,
                                                ),
                                              ),
                                              textStyle:
                                                  WidgetStateProperty.all(
                                                    kHeaderTextStyle(
                                                      context,
                                                    ).copyWith(
                                                      fontSize:
                                                          Responsive.fontSize(
                                                            context,
                                                            16,
                                                          ),
                                                      color: kWhite,
                                                    ),
                                                  ),
                                            ),
                                        onPressed: auth.isLoading
                                            ? null
                                            : () => _onLogin(context, ref),
                                        child: auth.isLoading
                                            ? const SizedBox(
                                                width: 22,
                                                height: 22,
                                                child:
                                                    CircularProgressIndicator(
                                                      color: kWhite,
                                                      strokeWidth: 2.6,
                                                    ),
                                              )
                                            : const Text('Login'),
                                      ),
                                    ),
                                    if (auth.error != null)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 12),
                                        child: Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            color: kerror.withAlpha(
                                              (0.08 * 255).toInt(),
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            border: Border.all(
                                              color: kerror.withAlpha(
                                                (0.18 * 255).toInt(),
                                              ),
                                            ),
                                          ),
                                          child: Text(
                                            auth.error!,
                                            style: kCaptionTextStyle(context)
                                                .copyWith(
                                                  color: kerror,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
