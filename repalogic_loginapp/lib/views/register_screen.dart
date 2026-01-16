import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../model/auth_viewmodel.dart';

const Color primaryRed = Color(0xFFBF2424);
const Color lightRed = Color(0xFFFDEAEA);

class RegisterView extends StatelessWidget {
  RegisterView({super.key});

  final _formKey = GlobalKey<FormState>();

  final nameInputController = TextEditingController();
  final emailInputController = TextEditingController();
  final passwordInputController = TextEditingController();
  final confirmPasswordInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AuthViewModel>();
    final translation = AppLocalizations.of(context);

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
                      translation.translate("create_account_text"),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: primaryRed,
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// Name
                    TextFormField(
                      controller: nameInputController,
                      decoration: _inputDecoration(
                        label: translation.translate("name_text"),
                        icon: Icons.person_outline,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return translation.translate("name_required_text");
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

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
                      controller: passwordInputController,
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

                    const SizedBox(height: 16),

                    /// Confirm Password
                    TextFormField(
                      controller: confirmPasswordInputController,
                      obscureText: true,
                      decoration: _inputDecoration(
                        label: translation.translate("confirmpassword_text"),
                        icon: Icons.lock_reset,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return translation.translate("confirm_password_required_text");
                        }
                        if (value != passwordInputController.text) {
                          return translation.translate("password_mismatch_text");
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    /// Register Button / Loader
                    vm.isLoading
                        ? const Center(
                      child: CircularProgressIndicator(
                        color: primaryRed,
                      ),
                    )
                        : ElevatedButton(
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }

                        await vm.register(
                          nameInputController.text.trim(),
                          emailInputController.text.trim(),
                          passwordInputController.text.trim(),
                        );

                        if (vm.message == 'Registration successful') {
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryRed,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        translation.translate("register_text"),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// Message
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

                    /// Back to Login
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        translation.translate("already_account_text"),
                        style: const TextStyle(
                          color: primaryRed,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

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

