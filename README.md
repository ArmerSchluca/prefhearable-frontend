# Prefhearable (Client)
**Prefhearable** is a mobile data collection instrument for assessing personal **hearing preferences** based on psychoacoustic and contextual data with special focus on health-related wellbeeing. 

This app serves as a large-scale crowdsourcing tool to build a comprehensive, standardized dataset for audiology and hearing research. The long-term goal of this dataset is to enable advanced **Auditory Profiling** using Machine Learning.

## Features

- Guided multi-step survey
- Psychoacoustic listening test (CCSM)
- EQ-5D-5L questionnaire
- WHO-5 questionnaire
- Automatic collection of contextual information
  - GPS position
  - Weather
  - Environmental noise level
  - Device information
- Offline survey caching

## Tech Stack & Architecture

* **Frontend:** Flutter (Dart)
* **Target Platforms:** iOS & Android
* **Other theoretically supported Platforms:** Windows & macOS (not tested)

## Backend

This application requires the Prefhearable backend.

Start the backend before launching the client.

Repository:
https://github.com/ArmerSchluca/prefhearable-backend

## Setup

### Prerequisites
Before running the app, ensure you have the [Flutter SDK](https://docs.flutter.dev/install/quick) installed on your machine.

### Installation & Run

1. Create directory if not already done:
```bash
mkdir Prefhearable
cd Prefhearable
```

2. Clone repository:
```bash
https://github.com/ArmerSchluca/prefhearable-frontend.git
```

3. Install dependencies:
```bash
flutter pub get
```

4. Run the application through IDE:
```
flutter run
```

## Configuration

Before running the application, configure the backend URL in case the server does not run locally as http://localhost:3000
```
lib/utils/base_url.dart
```

## Supported Platforms

| Platform | Status |
|----------|--------|
| Android | ✅ Supported |
| iOS | ✅ Supported |
| macOS | ⚠ Experimental |
| Windows | ⚠ Experimental |
