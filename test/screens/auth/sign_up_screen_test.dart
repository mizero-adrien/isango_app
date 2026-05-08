import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isango_app/core/constants/app_routes.dart';
import 'package:isango_app/core/theme/app_theme.dart';
import 'package:isango_app/screens/auth/sign_up_screen.dart';

// Prevent network calls for fonts in tests.
void _disableFontFetching() => GoogleFonts.config.allowRuntimeFetching = false;

Widget _buildHarness() {
  return MaterialApp(
    theme: AppTheme.light(),
    initialRoute: AppRoutes.signUp,
    routes: {
      AppRoutes.signUp: (_) => const SignUpScreen(),
      AppRoutes.login: (_) => const Scaffold(body: Text('LoginScreen')),
      AppRoutes.verifyEmail: (_) =>
          const Scaffold(body: Text('VerifyEmailScreen')),
    },
  );
}

// ── Helpers ──────────────────────────────────────────────────────────────────

/// Scrolls to the CTA, taps it, then advances fake-time past the 1-s mock
/// delay so no pending timer is left when the test ends.
Future<void> _tapCreateAccount(WidgetTester tester) async {
  await tester.ensureVisible(find.byKey(const Key('createAccountButton')));
  await tester.tap(find.byKey(const Key('createAccountButton')));
  await tester.pump(); // process tap: setState / validation runs
  // Advance past Future.delayed(1s) used in the mock auth call, if started.
  await tester.pump(const Duration(seconds: 1));
  await tester.pump(); // rebuild after isLoading → false
}

/// Fills all four fields with valid university data.
Future<void> _fillValidForm(WidgetTester tester) async {
  await tester.enterText(find.byKey(const Key('nameField')), 'Jane Student');
  await tester.enterText(
      find.byKey(const Key('emailField')), 'jane@stud.ur.ac.rw');
  await tester.enterText(find.byKey(const Key('passwordField')), 'Secret123');
  await tester.enterText(find.byKey(const Key('confirmField')), 'Secret123');
}

// ── Tests ────────────────────────────────────────────────────────────────────

void main() {
  setUpAll(_disableFontFetching);

  group('SignUpScreen — required-field validation', () {
    testWidgets('shows errors for every empty field on submit', (tester) async {
      await tester.pumpWidget(_buildHarness());

      await _tapCreateAccount(tester); // invalid form → no timer started

      expect(find.text('Full name is required'), findsOneWidget);
      expect(find.text('University email is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);
      expect(find.text('Please confirm your password'), findsOneWidget);
    });

    testWidgets('clears errors once all fields are valid', (tester) async {
      await tester.pumpWidget(_buildHarness());

      await _tapCreateAccount(tester);
      expect(find.text('Full name is required'), findsOneWidget);

      await _fillValidForm(tester);
      await _tapCreateAccount(tester); // valid → timer started and resolved

      expect(find.text('Full name is required'), findsNothing);
      expect(find.text('University email is required'), findsNothing);
    });
  });

  group('SignUpScreen — email validation', () {
    testWidgets('rejects non-university email (gmail)', (tester) async {
      await tester.pumpWidget(_buildHarness());

      await tester.enterText(
          find.byKey(const Key('emailField')), 'student@gmail.com');
      await _tapCreateAccount(tester);

      expect(
        find.text('Please use a valid university email address'),
        findsOneWidget,
      );
    });

    testWidgets('accepts .ac.rw academic domain', (tester) async {
      await tester.pumpWidget(_buildHarness());

      await _fillValidForm(tester);
      await _tapCreateAccount(tester);

      expect(
        find.text('Please use a valid university email address'),
        findsNothing,
      );
    });

    testWidgets('rejects malformed email string', (tester) async {
      await tester.pumpWidget(_buildHarness());

      await tester.enterText(
          find.byKey(const Key('emailField')), 'not-an-email');
      await _tapCreateAccount(tester);

      expect(find.text('Enter a valid email address'), findsOneWidget);
    });
  });

  group('SignUpScreen — password-confirmation validation', () {
    testWidgets('shows mismatch error when passwords differ', (tester) async {
      await tester.pumpWidget(_buildHarness());

      await tester.enterText(
          find.byKey(const Key('passwordField')), 'password123');
      await tester.enterText(
          find.byKey(const Key('confirmField')), 'different456');
      await _tapCreateAccount(tester);

      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets('no mismatch error when passwords match', (tester) async {
      await tester.pumpWidget(_buildHarness());

      await _fillValidForm(tester);
      await _tapCreateAccount(tester);

      expect(find.text('Passwords do not match'), findsNothing);
    });
  });

  group('SignUpScreen — navigation', () {
    testWidgets('sign-in link navigates to /login', (tester) async {
      await tester.pumpWidget(_buildHarness());

      await tester.ensureVisible(find.byKey(const Key('signInLink')));
      await tester.tap(find.byKey(const Key('signInLink')));
      await tester.pumpAndSettle();

      expect(find.text('LoginScreen'), findsOneWidget);
    });

    testWidgets('back arrow pops the route', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(body: Text('PreviousScreen')),
          routes: {AppRoutes.signUp: (_) => const SignUpScreen()},
        ),
      );

      final ctx = tester.element(find.text('PreviousScreen'));
      Navigator.of(ctx).pushNamed(AppRoutes.signUp);
      await tester.pumpAndSettle();

      expect(find.byType(SignUpScreen), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      expect(find.text('PreviousScreen'), findsOneWidget);
    });
  });

  group('SignUpScreen — loading state', () {
    testWidgets('CTA is disabled while request is in flight', (tester) async {
      await tester.pumpWidget(_buildHarness());
      await _fillValidForm(tester);

      await tester.ensureVisible(find.byKey(const Key('createAccountButton')));
      await tester.tap(find.byKey(const Key('createAccountButton')));
      await tester.pump(); // one frame: isLoading = true

      final button = tester.widget<ElevatedButton>(
        find.byKey(const Key('createAccountButton')),
      );
      expect(button.onPressed, isNull);

      // Resolve the pending timer to satisfy the test framework.
      await tester.pump(const Duration(seconds: 1));
      await tester.pump();
    });
  });
}
