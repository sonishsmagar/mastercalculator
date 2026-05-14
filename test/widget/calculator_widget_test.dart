import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('calculator widget placeholder', (tester) async {
    expect(find.byType(Null), findsNothing);
  });
}
