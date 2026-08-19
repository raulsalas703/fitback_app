import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/main.dart';
import 'package:mobile_app/screens/goals_screen.dart';
import 'package:mobile_app/screens/history_screen.dart';
import 'package:mobile_app/screens/home_screen.dart';
import 'package:mobile_app/screens/login_screen.dart';
import 'package:mobile_app/screens/profile_screen.dart';
import 'package:mobile_app/screens/register_screen.dart';
import 'package:mobile_app/screens/routine_detail_screen.dart';
import 'package:mobile_app/screens/routines_screen.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  Future<void> pumpApp(WidgetTester tester, Widget app) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(app);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
  }

  testWidgets('Login -> Registro -> Login', (tester) async {
    await pumpApp(tester, const FitBackApp());

    expect(find.byType(LoginScreen), findsOneWidget);

    await tester.tap(find.text('¿No tienes cuenta? Crear cuenta'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(RegisterScreen), findsOneWidget);

    await tester.tap(find.text('Ya tengo una cuenta'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('Home -> Entrenamientos -> Detalle de rutina', (tester) async {
    await pumpApp(tester, const MaterialApp(home: HomeScreen(userName: 'Test')));

    await tester.tap(find.text('Entrenamientos'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(RoutinesScreen), findsOneWidget);

    await tester.tap(find.text('Full Body Inicial'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(RoutineDetailScreen), findsOneWidget);

    await tester.pageBack();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(RoutinesScreen), findsOneWidget);
  });

  testWidgets('Home -> Historial semanal', (tester) async {
    await pumpApp(tester, const MaterialApp(home: HomeScreen(userName: 'Test')));

    await tester.tap(find.text('Historial semanal'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(HistoryScreen), findsOneWidget);
  });

  testWidgets('Home -> Metas SMART -> agregar meta', (tester) async {
    await pumpApp(tester, const MaterialApp(home: HomeScreen(userName: 'Test')));

    await tester.tap(find.text('Metas SMART'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(GoalsScreen), findsOneWidget);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Nueva meta'), findsOneWidget);

    await tester.tap(find.text('Cancelar'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(GoalsScreen), findsOneWidget);
  });

  testWidgets('Home -> Mi perfil', (tester) async {
    await pumpApp(tester, const MaterialApp(home: HomeScreen(userName: 'Test')));

    await tester.tap(find.text('Mi perfil'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(ProfileScreen), findsOneWidget);
  });
}