# KostongApp - Frontend (Flutter Web)

This is a minimal Flutter web client. To prepare the full flutter project, run these commands inside the frontend folder:

1. If this is not yet a Flutter project, run:
   flutter create .

2. Then get dependencies:
   flutter pub get

3. Run web:
   flutter run -d chrome

Notes:
- API base URL is set to http://localhost:3000/api in lib/services/api_service.dart
- If running backend on another host/port, update baseUrl accordingly.
