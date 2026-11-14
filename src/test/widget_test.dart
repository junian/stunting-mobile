import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:growthtracker/theme/app_theme.dart';
import 'package:growthtracker/widgets/app_widgets.dart';

void main() {
  testWidgets('design system renders core components', (tester) async {
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Child profile'),
                    const SizedBox(height: 8),
                    const StatusPill(
                      label: 'Normal',
                      tone: AppTone.mint,
                      icon: Icons.check_rounded,
                    ),
                    const SizedBox(height: 8),
                    const Sparkline(values: [10, 12, 11, 14]),
                    const SizedBox(height: 8),
                    AppButton(
                      label: 'Continue',
                      onPressed: () => tapped = true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Child profile'), findsOneWidget);
    expect(find.text('Normal'), findsOneWidget);

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(tapped, isTrue);
  });
}
