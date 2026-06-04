import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tracker_flutter/features/auth/providers/auth_provider.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final isLoading = useState(false);
    final errorMessage = useState<String?>(null);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Se connecter'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 48),
              Icon(
                Icons.directions_car,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 48),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'exemple@email.com',
                  prefixIcon: Icon(Icons.email),
                ),
                enabled: !isLoading.value,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Mot de passe',
                  hintText: '••••••••',
                  prefixIcon: Icon(Icons.lock),
                ),
                enabled: !isLoading.value,
              ),
              const SizedBox(height: 24),
              if (errorMessage.value != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      border: Border.all(color: Colors.red.shade400),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      errorMessage.value!,
                      style: TextStyle(color: Colors.red.shade700),
                    ),
                  ),
                ),
              ElevatedButton(
                onPressed: isLoading.value
                    ? null
                    : () async {
                        if (emailController.text.isEmpty ||
                            passwordController.text.isEmpty) {
                          errorMessage.value =
                              'Veuillez remplir tous les champs';
                          return;
                        }

                        isLoading.value = true;
                        errorMessage.value = null;

                        try {
                          await ref.read(signInProvider({
                            'email': emailController.text,
                            'password': passwordController.text,
                          }).future);

                          if (context.mounted) {
                            context.go('/dashboard');
                          }
                        } catch (e) {
                          errorMessage.value = e.toString();
                        } finally {
                          isLoading.value = false;
                        }
                      },
                child: isLoading.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Se connecter'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: isLoading.value ? null : () => context.go('/signup'),
                child: const Text("Pas encore de compte ? S'inscrire"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
