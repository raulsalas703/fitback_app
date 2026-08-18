import 'package:flutter/material.dart';

import '../services/auth_api.dart';
import '../services/workout_api.dart';
import '../widgets/fitback_background.dart';
import '../widgets/fitback_cover.dart';
import 'goals_screen.dart';
import 'history_screen.dart';
import 'login_screen.dart';
import 'profile_screen.dart';
import 'routines_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userName;

  const HomeScreen({super.key, required this.userName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? _weeklyTotal;

  @override
  void initState() {
    super.initState();
    _loadWeeklySummary();
  }

  Future<void> _loadWeeklySummary() async {
    try {
      final weekly = await WorkoutApi.getWeeklyWorkouts();

      if (!mounted) return;

      setState(() {
        _weeklyTotal = (weekly['total'] as num?)?.toInt() ?? 0;
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _weeklyTotal = null;
        });
      }
    }
  }

  Future<void> _logout() async {
    await AuthApi.logout();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  void _openScreen(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    ).then((_) => _loadWeeklySummary());
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
            onPressed: _logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),

      body: FitBackBackground(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const FitBackCover(
                    imagePath: 'assets/images/cover_gym_2.jpg',
                    height: 170,
                  ),

                  const SizedBox(height: 20),

                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [
                        Color(0xFFF5D061),
                        Color(0xFFD4AF37),
                        Color(0xFFB8860B),
                      ],
                    ).createShader(bounds),
                    child: Text(
                      'Hola, ${widget.userName} 👋',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    _todayLabel(),
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFFD4AF37),
                      letterSpacing: 0.5,
                    ),
                  ),

                  const SizedBox(height: 2),

                  const Text(
                    'Bienvenido a FitBack',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),

                  const SizedBox(height: 24),

                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: const Color(0xFF2A2008),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: const Color(0x66D4AF37),
                              ),
                            ),
                            child: const Icon(
                              Icons.trending_up,
                              color: Color(0xFFD4AF37),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Tu progreso semanal',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _weeklyTotal == null
                                      ? '--'
                                      : '$_weeklyTotal entrenamiento${_weeklyTotal == 1 ? '' : 's'} completados',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFE6C65C),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  _menuCard(
                    icon: Icons.fitness_center,
                    title: 'Entrenamientos',
                    subtitle: 'Explora y completa tus rutinas',
                    onTap: () => _openScreen(const RoutinesScreen()),
                  ),

                  const SizedBox(height: 12),

                  _menuCard(
                    icon: Icons.event_available,
                    title: 'Historial semanal',
                    subtitle: 'Revisa tu progreso y entrenamientos',
                    onTap: () => _openScreen(const HistoryScreen()),
                  ),

                  const SizedBox(height: 12),

                  _menuCard(
                    icon: Icons.flag,
                    title: 'Metas SMART',
                    subtitle: 'Define y administra tus objetivos',
                    onTap: () => _openScreen(const GoalsScreen()),
                  ),

                  const SizedBox(height: 12),

                  _menuCard(
                    icon: Icons.person,
                    title: 'Mi perfil',
                    subtitle: 'Consulta los datos de tu cuenta',
                    onTap: () => _openScreen(const ProfileScreen()),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _menuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      child: ListTile(
        leading: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: const Color(0xFF2A2008),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0x66D4AF37)),
          ),
          child: Icon(icon, color: const Color(0xFFD4AF37)),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(subtitle, style: const TextStyle(color: Colors.white70)),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Color(0xFFD4AF37),
          size: 18,
        ),
        onTap: onTap,
      ),
    );
  }

  String _todayLabel() {
    const weekdays = [
      'Lunes',
      'Martes',
      'Miércoles',
      'Jueves',
      'Viernes',
      'Sábado',
      'Domingo',
    ];
    const months = [
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre',
    ];

    final now = DateTime.now();

    return '${weekdays[now.weekday - 1]}, ${now.day} de ${months[now.month - 1]} de ${now.year}';
  }
}
