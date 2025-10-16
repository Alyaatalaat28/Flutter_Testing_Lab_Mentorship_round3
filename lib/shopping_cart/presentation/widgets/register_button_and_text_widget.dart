import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_testing_lab/shopping_cart/presentation/manager/cubit/registeration_cubit.dart';
import 'package:flutter_testing_lab/shopping_cart/presentation/widgets/final_text_widget.dart';

class RegisterButtonAndTextWidget extends StatelessWidget {
  const RegisterButtonAndTextWidget({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.formKey,
  });
  final TextEditingController nameController,
      emailController,
      passwordController,
      confirmPasswordController;

  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RegisterationCubit>();
    return BlocBuilder<RegisterationCubit, RegisterationState>(
      bloc: cubit,

      builder: (context, state) {
        return Column(
          children: [
            if (state is RegisterationLoading)
              const CircularProgressIndicator(),
            if (state is RegisterationSuccess ||
                state is RegisterationInitial ||
                state is RegisterationFailure)
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    await cubit.submitForm(
                      passwordController.text,
                      confirmPasswordController.text,
                      emailController.text,
                    );
                  }
                },
                child: const Text('Register'),
              ),
            const SizedBox(height: 16),
            if (state is RegisterationSuccess)
              FinalTextWidget(message: state.successMessage),
            if (state is RegisterationFailure)
              FinalTextWidget(
                message: state.errMessage,
                type: TextType.failure,
              ),
          ],
        );
      },
    );
  }
}
