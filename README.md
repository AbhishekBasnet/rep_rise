# RepRise 

**AI-Powered Personalized Fitness & Workout Tracking**

RepRise is a comprehensive fitness application built with Flutter that combines AI-powered workout recommendations with detailed health tracking. Designed with clean architecture principles, it provides users with personalized workout plans, comprehensive step tracking, and intelligent fitness insights.

---

##  Features

### Core Functionality
- ** AI-Powered Workouts** - Personalized workout recommendations based on your profile and fitness goals
- ** Step Tracking** - Comprehensive daily, weekly, and monthly step tracking with health app integration
- ** Progress Analytics** - Detailed visualizations of your fitness journey with interactive charts
- ** Goal Management** - Set and track custom fitness goals tailored to your needs
- ** Profile-Based Customization** - Complete onboarding wizard for personalized experience
- ** Workout Library** - Extensive exercise database with video demonstrations

### User Experience
- **Intuitive Profile Setup** - Multi-step wizard with wheel pickers and tap-to-select interfaces
- **Real-Time Synchronization** - Health data sync with device health apps
- **Progress Visualization** - Beautiful charts and graphs powered by FL Chart
- **Smart Navigation** - Tab-based navigation with nested routing support
- **Custom Theming** - Consistent purple-based design system with NataSans typography

---

##  Architecture

RepRise follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── core/                    # Core functionality & shared utilities
│   ├── di/                  # Dependency injection
│   ├── network/             # API client & network layer
│   ├── services/            # Cross-cutting services
│   ├── theme/               # App-wide theming
│   └── util/                # Extensions & utilities
│
├── data/                    # Data layer
│   ├── data_sources/        # Remote & local data sources
│   │   ├── remote/          # API implementations
│   │   └── local/           # Local storage (Drift)
│   ├── model/               # Data models
│   └── repositories/        # Repository implementations
│
├── domain/                  # Business logic layer
│   ├── entity/              # Domain entities
│   ├── repositories/        # Repository contracts
│   └── usecase/             # Business use cases
│
└── presentation/            # Presentation layer
    ├── provider/            # State management (Provider)
    └── screens/             # UI screens & widgets
```

### Key Architectural Patterns

**Dependency Injection**
- GetIt for service locator pattern
- Centralized dependency container
- Easy testing and modularity

**State Management**
- Provider pattern for reactive UI
- Separated business logic from UI
- Scoped providers for feature isolation

**Repository Pattern**
- Abstract data source access
- Single source of truth
- Easy data source switching

**Use Case Pattern**
- Single responsibility business operations
- Reusable business logic
- Testable domain layer

---

##  Tech Stack

### Frameworks & Libraries
- **Flutter** - Cross-platform mobile framework
- **Provider** - State management solution
- **GetIt** - Dependency injection
- **Drift** - Local database with type-safe queries
- **Dio** - HTTP client for API calls

### UI & Visualization
- **FL Chart** - Beautiful charts and graphs
- **Percent Indicator** - Progress indicators
- **Syncfusion Gauges** - Custom gauge widgets
- **Google Fonts** - Typography system

### Health & Permissions
- **Health** - iOS & Android health data integration
- **Permission Handler** - Runtime permissions management

### Additional Features
- **JWT Decoder** - Token authentication
- **Flutter Secure Storage** - Secure token storage
- **YouTube Player** - Exercise video playback
- **Intl** - Internationalization support

---

##  Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK** (3.10.4 or higher)
- **Dart SDK** (included with Flutter)
- **Android Studio** or **Xcode** (for respective platforms)
- **Git**

---

##  Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/rep_rise.git
cd rep_rise
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Generate Required Files

This project uses code generation for Drift (local database). Run:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 4. Configure Environment

Create necessary configuration files for API endpoints and secrets:

```dart
// lib/core/network/api_client.dart
// Update base URL to your backend API
static const String baseUrl = 'YOUR_API_URL';
```

### 5. Run the Application

```bash
# For development
flutter run

# For specific platform
flutter run -d <device_id>

# Release build
flutter build apk # Android
flutter build ios # iOS
```

---

##  Platform-Specific Setup

### iOS Setup

1. Update `ios/Podfile` minimum deployment target:
```ruby
platform :ios, '12.0'
```

2. Enable HealthKit capability in Xcode:
   - Open `ios/Runner.xcworkspace`
   - Select Runner target → Signing & Capabilities
   - Add "HealthKit" capability

3. Update `Info.plist` with health permissions:
```xml
<key>NSHealthShareUsageDescription</key>
<string>We need access to your health data to track your fitness progress</string>
<key>NSHealthUpdateUsageDescription</key>
<string>We need to update your health data</string>
```

### Android Setup

1. Update `android/app/build.gradle`:
```gradle
minSdkVersion 24
compileSdkVersion 34
targetSdkVersion 34
```

2. Add health permissions to `AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.ACTIVITY_RECOGNITION"/>
<uses-permission android:name="android.permission.health.READ_STEPS"/>
<uses-permission android:name="android.permission.health.WRITE_STEPS"/>
```

---

##  Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/unit/usecase_test.dart
```

---

##  Project Structure

### Feature Modules

**Authentication**
- User registration and login
- JWT token management
- Secure session handling
- Expired token navigation

**Profile Management**
- Multi-step profile creation wizard
- User profile CRUD operations
- Fitness goal configuration
- Workout level selection

**Step Tracking**
- Daily step counter with health sync
- Weekly step analytics
- Monthly step summaries
- Goal percentage calculations

**Workout Management**
- AI-generated workout plans
- Exercise library with videos
- Workout status tracking
- Progress monitoring

---

##  Design System

RepRise uses a custom design system with:

- **Color Palette**: Purple-based theme with semantic color naming
- **Typography**: Custom NataSans font family (9 weights)
- **Components**: Reusable profile cards, wheel pickers, and selection cards
- **Animations**: Smooth transitions and micro-interactions

---

##  Security

- **JWT Authentication** - Secure token-based authentication
- **Secure Storage** - Encrypted local storage for sensitive data
- **API Exception Handling** - Centralized error handling
- **Token Expiry Management** - Automatic token refresh and re-authentication

---

##  Contributing

Contributions are welcome! Please follow these guidelines:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Code Style

- Follow Flutter's official style guide
- Use meaningful variable and function names
- Add comments for complex logic
- Maintain clean architecture boundaries
- Write unit tests for new features

---

##  License

This project is licensed under the MIT License - see the LICENSE file for details.

---

##  Acknowledgments

- **Flutter Team** - For the amazing framework
- **Anthropic Claude** - For development assistance
- **Open Source Community** - For the excellent packages used

---

<div align="center">
  <p>Built with ❤️ using Flutter</p>
  <p>⭐ Star this repo if you find it helpful!</p>
</div>
