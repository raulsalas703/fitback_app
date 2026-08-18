import 'package:flutter/material.dart';

import '../services/auth_api.dart';
import '../utils/formatters.dart';
import '../widgets/fitback_background.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<Map<String, dynamic>> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = AuthApi.getProfile();
  }

  Future<void> _reload() async {
    setState(() {
      _profileFuture = AuthApi.getProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi perfil'),
        actions: [
          IconButton(
            tooltip: 'Actualizar',
            onPressed: _reload,
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
                        onPressed: _reload,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Reintentar'),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (!snapshot.hasData) {
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

            return ListView(
              padding: const EdgeInsets.all(24),
              children: [
                const SizedBox(height: 12),

                Center(
                  child: Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE6C65C), Color(0xFFB8860B)],
                      ),
                      border: Border.all(
                        color: const Color(0xFFD4AF37),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 56,
                      color: Colors.black,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE6C65C),
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  email,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70),
                ),

                const SizedBox(height: 32),

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
                          style: TextStyle(color: Colors.white70, fontSize: 13),
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
                          Icons.fitness_center,
                          color: Color(0xFFD4AF37),
                        ),
                        title: const Text(
                          'Objetivo',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
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
              ],
            );
          },
        ),
      ),
    );
  }
}
