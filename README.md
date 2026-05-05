# Isango App

Isango is a Flutter application for campus event discovery and submission in the UR community. The current codebase establishes the first product shell: shared visual language, route wiring, bottom navigation, and placeholder screens for the initial feature areas.

## Current Scope

- Material 3 app shell with Isango branding
- Shared theme tokens for color, spacing, radii, and typography
- Named routes for the first navigation flow
- Login and signup screens with form validation
- Bottom navigation for `Home`, `Saved`, `Submit`, and `Settings`
- Placeholder screens that keep feature delivery moving while the real UI is implemented incrementally

## Project Structure

```text
lib/
  app.dart
  core/
    constants/
    theme/
  screens/
    auth/
      login_screen.dart
      signup_screen.dart
    home/
    saved/
    settings/
    shared/
    submit/
  widgets/
```

## Getting Started

1. Install Flutter and verify it with `flutter doctor`.
2. Fetch packages with `flutter pub get`.
3. Run the app with `flutter run`.

## Authentication

The app opens on the login screen. From there a user can go to sign up and back. Both screens are built with Flutter's standard `Form` and `TextFormField` widgets — no third-party auth package is added yet.

**Login screen** (`lib/screens/auth/login_screen.dart`)

- Email and password fields, each validated before submission.
- A password visibility toggle on the password field.
- A "Remember me" checkbox and a "Forgot password?" link side by side below the password field. The checkbox state is stored in `_rememberMe` and is ready to be passed to whatever auth service you wire up.
- A "Continue with Google" button (UI only, no logic yet).
- A link at the bottom to navigate to the sign-up screen.

**Signup screen** (`lib/screens/auth/signup_screen.dart`)

- Four fields: full name, email address, password, and confirm password.
- Each field has its own validator — email format, minimum 8-character password, and a check that both password fields match.
- Password visibility toggles on both password fields.
- A "Terms & Conditions" checkbox at the bottom. The text links for "Terms & Conditions" and "Privacy Policy" are styled as tappable blue links. If the user tries to submit without ticking the box, a snack bar reminds them to accept before continuing.
- A link at the bottom to navigate back to the login screen.

**Wiring auth logic**

Both screens have a stub method (`_handleSignIn` / `_handleSignUp`) that currently waits one second and then navigates to the home screen. Replace that `Future.delayed` call with your real auth service (Firebase Auth, Supabase, a custom REST API, etc.) and the rest of the screen — loading state, error handling, navigation — will work without any other changes.

## Next Steps

- Replace placeholder screens with production event discovery flows
- Wire `_handleSignIn` and `_handleSignUp` to a real auth backend
- Add a forgot-password screen and email verification flow
- Introduce real event data, persistence, and submission validation
