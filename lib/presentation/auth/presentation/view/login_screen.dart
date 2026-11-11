import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hr_project/core/resources/colors/color_manger.dart';
import 'package:hr_project/core/resources/routes/route_manger.dart';
import 'package:hr_project/core/resources/style/style_manger.dart';
import 'package:hr_project/core/resources/widgets/custom_button.dart';
import 'package:hr_project/core/resources/widgets/custom_text_formed_field.dart';
import 'package:hr_project/presentation/auth/presentation/view/section/logo.dart';

import '../../../../core/ex/text_ex.dart';
import '../view_model/auth_view_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (!_formKey.currentState!.validate()) return;

    context.read<AuthCubit>().login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  void _showToast(String message, {bool isError = false}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: isError ? ColorManger.error : ColorManger.primary,
      textColor: ColorManger.white,
      fontSize: 14,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoginSuccess) {
          _showToast('تم تسجيل الدخول بنجاح');
          Navigator.pushReplacementNamed(context, RouteManger.mainLayoutScreen);
        } else if (state is AuthFailure) {
          _showToast(state.message, isError: true);
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Scaffold(
          backgroundColor: ColorManger.background,
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(32),
                    decoration: AppStyles.card,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Logo(),
                          const SizedBox(height: 24),
                          const Text(
                            'تسجيل الدخول',
                            style: AppStyles.pageTitle,
                          ),
                          const SizedBox(height: 20),
                          CustomTextFormedField(
                            label: 'البريد الإلكتروني',
                            hint: 'Example@gmail.com',
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) => (value ?? '').emailValidator,
                          ),
                          const SizedBox(height: 16),
                          CustomTextFormedField(
                            label: 'كلمة المرور',
                            controller: _passwordController,
                            isPassword: true,
                            validator: (value) =>
                                (value ?? '').passwordValidator,
                          ),
                          const SizedBox(height: 24),
                          CustomButton(
                            text: 'دخول',
                            expanded: true,
                            isLoading: isLoading,
                            onPressed: _login,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
