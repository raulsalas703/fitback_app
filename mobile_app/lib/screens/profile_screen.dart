import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/auth_api.dart';
import '../services/goals_storage.dart';
import '../services/profile_storage.dart';
import '../services/workout_api.dart';
import '../utils/formatters.dart';
import '../widgets/fitback_background.dart';
import '../widgets/fitback_cover.dart';
import '../widgets/profile_avatar.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<Map<String, dynamic>> _profileFuture;

  String? _photoBase64;
  int _weeklyTotal = 0;
  int _totalWorkouts = 0;
  int _completedGoals = 0;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    _profileFuture = AuthApi.getProfile();
    _photoBase64 = await ProfileStorage.getPhoto();

    try {
      final weekly = await WorkoutApi.getWeeklyWorkouts();
      final history = await WorkoutApi.getWorkouts();
      final goals = await GoalsStorage.getGoals();

      if (!mounted) return;

      setState(() {
        _weeklyTotal = (weekly['total'] as num?)?.toInt() ?? 0;
        _totalWorkouts = history.length;
        _completedGoals = goals.where((goal) => goal.completed).length;
      });
    } catch (_) {
      // Las estadísticas no bloquean la pantalla
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();

    final XFile? file = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
      maxHeight: 600,
      imageQuality: 80,
    );

    if (file == null || !mounted) return;

    final bytes = await file.readAsBytes();
    final base64 = base64Encode(bytes);

    await ProfileStorage.savePhoto(base64);

    if (!mounted) return;

    setState(() {
      _photoBase64 = base64;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Foto de perfil actualizada')));
  }

  Future<void> _removePhoto() async {
    await ProfileStorage.removePhoto();

    if (!mounted) return;

    setState(() {
      _photoBase64 = null;
    });
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

  Future<void> _showPhotoOptions() async {
    final option = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Foto de perfil',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE6C65C),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.photo_library,
                color: Color(0xFFD4AF37),
              ),
              title: const Text('Elegir de la galería'),
              onTap: () => Navigator.pop(context, 'gallery'),
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera, color: Color(0xFFD4AF37)),
              title: const Text('Tomar una foto'),
              onTap: () => Navigator.pop(context, 'camera'),
            ),
            if (_photoBase64 != null)
              ListTile(
                leading: const Icon(
                  Icons.delete_outline,
                  color: Color(0xFFE57373),
                ),
                title: const Text('Quitar foto'),
                onTap: () => Navigator.pop(context, 'remove'),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );

    if (!mounted || option == null) return;

    switch (option) {
      case 'gallery':
        await _pickPhoto();
        break;
      case 'camera':
        await _pickPhotoFromCamera();
        break;
      case 'remove':
        await _removePhoto();
        break;
    }
  }

  Future<void> _pickPhotoFromCamera() async {
    final picker = ImagePicker();

    final XFile? file = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
      maxHeight: 600,
      imageQuality: 80,
    );

    if (file == null || !mounted) return;

    final bytes = await file.readAsBytes();
    final base64 = base64Encode(bytes);

    await ProfileStorage.savePhoto(base64);

    if (!mounted) return;

    setState(() {
      _photoBase64 = base64;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Foto de perfil actualizada')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi perfil'),
        actions: [
          IconButton(
            tooltip: 'Actualizar',
            onPressed: _loadData,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FitBackBackground(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _profileFuture,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.cloud_off,
                        size: 56,
                        color: Color(0x66D4AF37),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        snapshot.error.toString().replaceFirst(
                          'Exception: ',
                          '',
                        ),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _loadData,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Reintentar'),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (!snapshot.hasData || _isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFFD4AF37)),
              );
            }

            final user = snapshot.data!['user'] as Map<String, dynamic>?;

            final name = user?['name']?.toString() ?? 'Usuario';
            final email = user?['email']?.toString() ?? '';

            final DateTime createdAt =
                DateTime.tryParse(user?['createdAt']?.toString() ?? '') ??
                DateTime.now();

            return RefreshIndicator(
              color: const Color(0xFFD4AF37),
              backgroundColor: const Color(0xFF1E1E1E),
              onRefresh: _loadData,
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  const FitBackCover(
                    imagePath: 'assets/images/cover_gym_2.jpg',
                    height: 130,
                  ),

                  const SizedBox(height: 24),

                  Center(
                    child: ProfileAvatar(
                      photoBase64: _photoBase64,
                      onEdit: _showPhotoOptions,
                    ),
                  ),

                  const SizedBox(height: 16),

                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [
                        Color(0xFFF5D061),
                        Color(0xFFD4AF37),
                        Color(0xFFB8860B),
                      ],
                    ).createShader(bounds),
                    child: Text(
                      name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    email,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    'Toca la cámara para cambiar tu foto',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),

                  const SizedBox(height: 28),

                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Expanded(
                            child: _statItem(
                              icon: Icons.event_available,
                              value: '$_weeklyTotal',
                              label: 'Esta semana',
                            ),
                          ),
                          _statDivider(),
                          Expanded(
                            child: _statItem(
                              icon: Icons.fitness_center,
                              value: '$_totalWorkouts',
                              label: 'Entrenamientos',
                            ),
                          ),
                          _statDivider(),
                          Expanded(
                            child: _statItem(
                              icon: Icons.emoji_events,
                              value: '$_completedGoals',
                              label: 'Metas',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(
                            Icons.badge,
                            color: Color(0xFFD4AF37),
                          ),
                          title: const Text(
                            'Miembro desde',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                          trailing: Text(
                            formatDate(createdAt),
                            style: const TextStyle(
                              color: Color(0xFFE6C65C),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Divider(color: Color(0x33D4AF37), height: 1),
                        ListTile(
                          leading: const Icon(
                            Icons.trending_up,
                            color: Color(0xFFD4AF37),
                          ),
                          title: const Text(
                            'Objetivo',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                          trailing: const Text(
                            'Mantenerse constante 💪',
                            style: TextStyle(
                              color: Color(0xFFE6C65C),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: _logout,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFE57373),
                        side: const BorderSide(color: Color(0x66E57373)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(Icons.logout),
                      label: const Text(
                        'Cerrar sesión',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _statItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFFD4AF37)),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFFE6C65C),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  Widget _statDivider() {
    return Container(width: 1, height: 48, color: const Color(0x55D4AF37));
  }
}
