import 'package:flutter/material.dart';

import '../services/auth_api.dart';
import '../widgets/fitback_background.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  final String userName;

  const HomeScreen({super.key, required this.userName});

  Future<void> _logout(BuildContext context) async {
    await AuthApi.logout();

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

      body: FitBackBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 700),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [
                          Color(0xFFF5D061),
                          Color(0xFFD4AF37),
                          Color(0xFFB8860B),
                        ],
                      ).createShader(bounds),
                      child: Text(
                        'Hola, $userName 👋',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Bienvenido a FitBack',
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),

                    const SizedBox(height: 32),

                    Card(
                      child: ListTile(
                        leading: const Icon(
                          Icons.fitness_center,
                          size: 36,
                          color: Color(0xFFD4AF37),
                        ),
                        title: const Text(
                          'Entrenamientos',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: const Text(
                          'Registra y consulta tus rutinas',
                          style: TextStyle(color: Colors.white70),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: Color(0xFFD4AF37),
                          size: 18,
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
                          color: Color(0xFFD4AF37),
                        ),
                        title: const Text(
                          'Objetivos SMART',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: const Text(
                          'Define y administra tus objetivos',
                          style: TextStyle(color: Colors.white70),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: Color(0xFFD4AF37),
                          size: 18,
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
                          color: Color(0xFFD4AF37),
                        ),
                        title: const Text(
                          'Progreso',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: const Text(
                          'Consulta tu avance',
                          style: TextStyle(color: Colors.white70),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: Color(0xFFD4AF37),
                          size: 18,
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
                          color: Color(0xFFD4AF37),
                        ),
                        title: const Text(
                          'Mi perfil',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: const Text(
                          'Consulta los datos de tu cuenta',
                          style: TextStyle(color: Colors.white70),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: Color(0xFFD4AF37),
                          size: 18,
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
      ),
    );
  }
}
