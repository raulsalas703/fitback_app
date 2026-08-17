import 'package:flutter/material.dart';

import '../services/auth_api.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  final String userName;

  const HomeScreen({
    super.key,
    required this.userName,
  });

  Future<void> _logout(BuildContext context) async {
    await AuthApi.logout();

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        title: const Text('FitBack'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            tooltip: 'Cerrar sesión',
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 700,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Hola, $userName 👋',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Bienvenido a FitBack',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 32),

                  Card(
                    child: ListTile(
                      leading: const Icon(
                        Icons.fitness_center,
                        size: 36,
                      ),
                      title: const Text(
                        'Entrenamientos',
                      ),
                      subtitle: const Text(
                        'Registra y consulta tus rutinas',
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                      ),
                      onTap: () {},
                    ),
                  ),

                  const SizedBox(height: 12),

                  Card(
                    child: ListTile(
                      leading: const Icon(
                        Icons.flag,
                        size: 36,
                      ),
                      title: const Text(
                        'Objetivos SMART',
                      ),
                      subtitle: const Text(
                        'Define y administra tus objetivos',
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                      ),
                      onTap: () {},
                    ),
                  ),

                  const SizedBox(height: 12),

                  Card(
                    child: ListTile(
                      leading: const Icon(
                        Icons.show_chart,
                        size: 36,
                      ),
                      title: const Text(
                        'Progreso',
                      ),
                      subtitle: const Text(
                        'Consulta tu avance',
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                      ),
                      onTap: () {},
                    ),
                  ),

                  const SizedBox(height: 12),

                  Card(
                    child: ListTile(
                      leading: const Icon(
                        Icons.person,
                        size: 36,
                      ),
                      title: const Text(
                        'Mi perfil',
                      ),
                      subtitle: const Text(
                        'Consulta los datos de tu cuenta',
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                      ),
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}