import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/main.dart';

void main() {
  testWidgets('Muestra pantalla de inicio de sesion', (WidgetTester tester) async {
    await tester.pumpWidget(const FitBackApp());

    expect(find.text('FitBack'), findsOneWidget);
    expect(find.text('Iniciar sesión'), findsOneWidget);
  });
}