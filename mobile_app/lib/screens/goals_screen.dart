import 'package:flutter/material.dart';

import '../services/goals_storage.dart';
import '../widgets/fitback_background.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  List<Goal> _goals = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGoals();
  }

  Future<void> _loadGoals() async {
    final goals = await GoalsStorage.getGoals();

    if (!mounted) return;

    setState(() {
      _goals = goals;
      _isLoading = false;
    });
  }

  Future<void> _addGoal() async {
    final titleController = TextEditingController();
    final dateController = TextEditingController();

    final bool? saved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF151515),
        title: const Text(
          'Nueva meta',
          style: TextStyle(
            color: Color(0xFFE6C65C),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: '¿Qué quieres lograr?',
                prefixIcon: Icon(Icons.flag),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: dateController,
              readOnly: true,
              onTap: () async {
                final now = DateTime.now();
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: now,
                  firstDate: now,
                  lastDate: DateTime(now.year + 2),
                  builder: (context, child) => Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.fromSeed(
                        seedColor: const Color(0xFFD4AF37),
                        brightness: Brightness.dark,
                      ),
                    ),
                    child: child!,
                  ),
                );

                if (picked != null) {
                  dateController.text =
                      '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
                }
              },
              decoration: const InputDecoration(
                labelText: 'Fecha límite',
                prefixIcon: Icon(Icons.event),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final title = titleController.text.trim();

              if (title.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Describe tu meta')),
                );
                return;
              }

              final date = dateController.text.isEmpty
                  ? 'Sin fecha límite'
                  : dateController.text;

              Navigator.pop(context, true);

              GoalsStorage.addGoal(
                title: title,
                targetDate: date,
              ).then((_) => _loadGoals());
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );

    if (saved == null || !saved) return;
  }

  Future<void> _toggleGoal(Goal goal) async {
    await GoalsStorage.toggleGoal(goal.id);
    await _loadGoals();
  }

  Future<void> _deleteGoal(Goal goal) async {
    await GoalsStorage.deleteGoal(goal.id);
    await _loadGoals();
  }

  int get _completedCount => _goals.where((goal) => goal.completed).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis metas')),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFD4AF37),
        foregroundColor: Colors.black,
        onPressed: _addGoal,
        child: const Icon(Icons.add),
      ),
      body: FitBackBackground(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFFD4AF37)),
              )
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (_goals.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 48),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.flag,
                            size: 56,
                            color: Color(0x66D4AF37),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Aún no tienes metas',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Toca el botón + para crear una',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    )
                  else ...[
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.emoji_events,
                              color: Color(0xFFD4AF37),
                              size: 32,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$_completedCount de ${_goals.length} metas',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFE6C65C),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  const Text(
                                    'Cumplidas',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            _goals.isEmpty
                                ? const SizedBox.shrink()
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: LinearProgressIndicator(
                                      value: _completedCount / _goals.length,
                                      minHeight: 8,
                                      color: const Color(0xFFD4AF37),
                                      backgroundColor: const Color(0xFF2A2008),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ..._goals.map(
                      (goal) => Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          leading: Icon(
                            goal.completed
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: goal.completed
                                ? const Color(0xFF4CAF50)
                                : const Color(0xFFD4AF37),
                          ),
                          title: Text(
                            goal.title,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              decoration: goal.completed
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: goal.completed
                                  ? Colors.white54
                                  : Colors.white,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              'Límite: ${goal.targetDate}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          trailing: IconButton(
                            tooltip: 'Eliminar',
                            onPressed: () => _deleteGoal(goal),
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Color(0xFFE57373),
                            ),
                          ),
                          onTap: () => _toggleGoal(goal),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
      ),
    );
  }
}
