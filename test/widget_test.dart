import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mf_customer/main.dart';
import 'package:mf_customer/data/demo_repository.dart';
import 'package:mf_customer/services/chat_service.dart';

/// Scrolls the main page list down until [finder] is built and on screen.
Future<void> reveal(WidgetTester tester, Finder finder) async {
  await tester.scrollUntilVisible(
    finder,
    300,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.pumpAndSettle();
}

void main() {
  test('demo service explicitly labels its fixed response', () async {
    final reply = await DemoChatService().reply([]);
    expect(reply.body.en, contains('DEMO'));
    expect(reply.body.hi, contains('डेमो'));
    expect(
      DemoRepository().slots(DateTime(2026, 10, 16)),
      isNot(DemoRepository().slots(DateTime(2026, 10, 17))),
    );
  });
  testWidgets('bilingual navigation, taxonomy, demo chat and deletion', (
    tester,
  ) async {
    // Real phone-sized screen (1080x2400 px at 2.625x ≈ Pixel 7).
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const MyApp());
    expect(find.text('बिना शर्माए बात करें'), findsOneWidget);
    expect(find.text('आपकी देखभाल, आपके लिए।'), findsOneWidget);
    await reveal(tester, find.text('अपनी बात बताएँ'));
    await tester.tap(find.text('अपनी बात बताएँ'));
    await tester.pumpAndSettle();
    expect(find.textContaining('14416'), findsOneWidget);
    const question = 'मेरा सवाल इरेक्शन बनने या बनाए रखने में परेशानी के बारे में है।';
    for (final choice in [
      '1. यौन स्वास्थ्य',
      '1. पुरुषों से संबंधित समस्याएँ',
      '1. यौन समस्याएँ',
      '2. इरेक्शन बनने या बनाए रखने में परेशानी',
    ]) {
      await reveal(tester, find.text(choice));
      await tester.tap(find.text(choice));
      await tester.pumpAndSettle();
    }
    expect(find.text('पुरुषों से संबंधित समस्याएँ → यौन समस्याएँ'), findsOneWidget);
    expect(find.text(question), findsOneWidget); // prefilled in the composer
    // Back to the subsection list, then to fertility problems.
    await reveal(tester, find.text('← उपविभाग पर वापस'));
    await tester.tap(find.text('← उपविभाग पर वापस'));
    await tester.pumpAndSettle();
    expect(find.text('2. प्रजनन संबंधी समस्याएँ'), findsOneWidget);
    await reveal(tester, find.text('भेजें →'));
    await tester.tap(find.text('भेजें →'));
    await tester.pumpAndSettle();
    expect(find.text(question), findsOneWidget); // now a chat bubble
    expect(find.textContaining('डेमो: आपकी बात'), findsOneWidget);
    await reveal(tester, find.text('बातचीत मिटाएँ'));
    await tester.tap(find.text('बातचीत मिटाएँ'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('रद्द करें'));
    await tester.pumpAndSettle();
    expect(find.text(question), findsOneWidget);
    await tester.tap(find.text('बातचीत मिटाएँ'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('मिटाएँ'));
    await tester.pumpAndSettle();
    expect(find.text(question), findsNothing);
    await tester.tap(find.byType(DropdownButton<bool>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('English').last);
    await tester.pumpAndSettle();
    await reveal(tester, find.text('Ask your question or write your message...'));
    expect(find.text('Ask your question or write your message...'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('1. Sexual health'),
      -300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('1. Sexual health'), findsOneWidget);
    await tester.tap(find.text('Store'));
    await tester.pumpAndSettle();
    await reveal(tester, find.text('Add to My Kit').first);
    await tester.tap(find.text('Add to My Kit').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add to My Kit').first);
    await tester.pumpAndSettle();
    expect(find.text('In kit: 2'), findsOneWidget);
    await reveal(tester, find.text('View My Kit'));
    await tester.tap(find.text('View My Kit'));
    await tester.pumpAndSettle();
    expect(find.text('Wellness journal'), findsOneWidget);
    await tester.tap(find.text('View order preview'));
    await tester.pumpAndSettle();
    expect(find.textContaining('No order placed'), findsOneWidget);
    expect(find.textContaining('Total: ₹598'), findsOneWidget);
    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('Demo profile without login'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
