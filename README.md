# dos-flutter-ideas001
A Flutter ledger app using Firestore and Typesense search with Material 3 and dark mode.

# Created on Jun 07, 2025 13:12

# dos-flutter-ideas001

A Flutter ledger app using Firestore for storage and Typesense for fast search, built with Material 3 and dark mode support.

## Features

- **Material 3** UI with dark mode
- Add, edit, delete ledger entries (amount, description)
- Pagination of ledger history
- Live total balance
- Fast search of description using Typesense
- Firestore as source of truth

## Setup

### 1. Firebase

- [Set up Firebase](https://firebase.google.com/docs/flutter/setup)
- Enable Firestore
- Download and add `google-services.json` (Android) or `GoogleService-Info.plist` (iOS)

### 2. Typesense

- [Install Typesense](https://typesense.org/docs/latest/guide/install-typesense.html) or use Typesense Cloud
- Create a collection:

    ```bash
    curl "http://localhost:8108/collections" \
      -H "X-TYPESENSE-API-KEY: xyz" \
      -X POST \
      -d @- <<EOF
    {
      "name": "ledger_entries",
      "fields": [
        { "name": "id", "type": "string" },
        { "name": "amount", "type": "float" },
        { "name": "description", "type": "string" },
        { "name": "timestamp", "type": "int64", "facet": true }
      ],
      "default_sorting_field": "timestamp"
    }
    EOF
    ```

- Sync Firestore with Typesense using Cloud Functions or a backend script.

### 3. Flutter

- Update `pubspec.yaml` dependencies (see file)
- Replace `YOUR_TYPESENSE_API_KEY` in `ledger_search.dart` with your Typesense API key
- Run the app:  
  ```
  flutter run
  ```

## Search

- The app bar's search icon lets you search descriptions using Typesense for typo-tolerant, instant results.

## Note

- Firestore changes (add/edit/delete) should be mirrored to Typesense for consistent search results.
- Backend sync example (Firebase Cloud Function) is recommended for production.

# Last Updated on Jun 07, 2025 13:13
