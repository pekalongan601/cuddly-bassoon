# SeaScape Banking

A fully local Flutter Android banking-interface demo inspired by the supplied visual reference. It uses local mock data only—there is no authentication, API, analytics, or remote font loading.

## Run

```bash
flutter pub get
flutter run
```

## Local testing controls

Open **Saya → Developer Settings** to edit Total Balance and Savings Balance independently, add or subtract funds, reset balances, update account identity, change balance visibility, and select an app theme. Settings are stored with `SharedPreferences`, so they survive app restarts. The app contains only local dummy data and makes no backend calls.
