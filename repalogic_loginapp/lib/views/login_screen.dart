import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repalogic_loginapp/views/register_screen.dart';
import '../l10n/app_localizations.dart';
import '../model/auth_viewmodel.dart';
import 'home_screen.dart';

const Color primaryRed = Color(0xFFBF2424);
const Color lightRed = Color(0xFFFDEAEA);

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final _formKey = GlobalKey<FormState>();

  final emailInputController = TextEditingController();
  final passInputController = TextEditingController();

  Future<void> _handleLogin(
      BuildContext context,
      AuthViewModel vm,
      ) async {
    if (!_formKey.currentState!.validate()) return;

    final success = await vm.login(
      emailInputController.text.trim(),
      passInputController.text.trim(),
    );

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeView()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final translation = AppLocalizations.of(context);
    final vm = context.watch<AuthViewModel>();

    return Scaffold(
      backgroundColor: lightRed,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    /// Title
                    Text(
                      translation.translate("welcome_text"),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: primaryRed,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      translation.translate("login_continue_text"),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// Email
                    TextFormField(
                      controller: emailInputController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: _inputDecoration(
                        label: translation.translate("email_text"),
                        icon: Icons.email_outlined,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return translation.translate("email_required_text");
                        }
                        final emailRegex =
                        RegExp(r'^[^@]+@[^@]+\.[^@]+');
                        if (!emailRegex.hasMatch(value.trim())) {
                          return translation.translate("email_invalid_text");
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    /// Password
                    TextFormField(
                      controller: passInputController,
                      obscureText: true,
                      decoration: _inputDecoration(
                        label: translation.translate("password_text"),
                        icon: Icons.lock_outline,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return translation.translate("password_required_text");
                        }
                        if (value.length < 6) {
                          return translation.translate("password_length_text");
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    /// Login Button / Loader
                    vm.isLoading
                        ? const Center(
                      child: CircularProgressIndicator(
                        color: primaryRed,
                      ),
                    )
                        : ElevatedButton(
                      onPressed: () => _handleLogin(context, vm),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryRed,
                        padding:
                        const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// Error / Message
                    if (vm.message != null)
                      Text(
                        vm.message!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: primaryRed,
                          fontSize: 13,
                        ),
                      ),

                    const SizedBox(height: 20),

                    /// Register
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          translation.translate("donot_have_account"),
                          style: const TextStyle(fontSize: 13),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RegisterView(),
                              ),
                            );
                          },
                          child: const Text(
                            'Create Account',
                            style: TextStyle(
                              color: primaryRed,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Reusable InputDecoration
  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: primaryRed),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryRed, width: 2),
      ),
    );
  }
}


