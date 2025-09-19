# Health Maintenance Supporter

Fitzy - Health Maintenance Supporter is an iOS application built with SwiftUI, designed to help users to track, manage, and optimize their daily health routines. The app combines AI-powered food recognition, HealthKit integration, and cloud-based authentication to deliver a seamless, secure, and insightful health management experience.

---

## Table of Contents

- [Features](#features)
- [Architecture](#architecture)
- [Screenshots](#screenshots)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Firebase Setup](#firebase-setup)
  - [Installation](#installation)
- [Project Structure](#project-structure)
- [Core Technologies](#core-technologies)
- [Usage Guide](#usage-guide)
- [Testing](#testing)
- [Contributing](#contributing)
- [License](#license)

---

## Features

- **Comprehensive Dashboard**: View daily progress for meals, water, activities, and goals.
- **AI Food Identification**: Log food by searching or using the built-in AI image classifier (CoreML & Vision).
- **Meal & Water Tracking**: Intuitive controls for updating and monitoring intake.
- **Activity Tracking**: Steps, distance, calories, and flights climbed via HealthKit.
- **Personalized Goals**: Set and monitor daily targets (calories, macros, water, steps, etc.).
- **Progress Insights**: Visualize trends with interactive charts and analytics.
- **Biometric Authentication**: Secure access with FaceID/TouchID.
- **Onboarding Carousel**: Guided onboarding for new users.
- **Push Notifications**: Daily reminders and reports.
- **Cloud Sync**: User data and reports are securely synced with Firebase.

## Architecture

The app follows a modular MVVM architecture:

- **Views/**: SwiftUI screens for each feature (Dashboard, Meals, Health, Profile, etc.)
- **ViewModels/**: State management, business logic, and data binding
- **Models/**: Data structures for meals, users, goals, etc.
- **Services/**: Integrations (Firebase, HealthKit, biometrics, notifications)
- **Components/**: Reusable UI elements (charts, cards, buttons)
- **Data/**: Static/sample data (macros, goals)

### Main Flows

- **Onboarding**: Collects user details and goals, then presents a carousel of app features
- **Authentication**: Email/password via Firebase, with biometric unlock
- **Food Logging**: Manual search or AI-powered image classification
- **Activity Sync**: HealthKit integration for real-time activity data
- **Notifications**: Scheduled reminders for hydration, activity, and daily reports

## Screenshots

_Add screenshots of the Dashboard, AI Food Classifier, Progress Insights, etc._

---

## Getting Started

### Prerequisites

- Xcode 15 or later
- iOS 17 or later
- Swift 5.9+
- CocoaPods or Swift Package Manager (for Firebase)
- Apple Developer account (for HealthKit, notifications, biometrics)

### Firebase Setup

1. **Create a Firebase Project**
   - Go to [Firebase Console](https://console.firebase.google.com/) and create a new project.
2. **Add an iOS App**
   - Register your app's bundle identifier (e.g., `com.yourcompany.health-maintenance-supporter`).
3. **Download `GoogleService-Info.plist`**
   - Place it in the root of your Xcode project.
4. **Enable Authentication**
   - In Firebase Console, enable Email/Password authentication.
5. **Enable Firestore**
   - Set up Firestore Database for user and report storage.
6. **Add Firebase SDK**
   - Use Swift Package Manager or CocoaPods:
     ```sh
     # Swift Package Manager (recommended)
     https://github.com/firebase/firebase-ios-sdk
     # Or CocoaPods
     pod 'Firebase/Auth'
     pod 'Firebase/Firestore'
     ```
7. **Initialize Firebase in Code**
   - In `health_maintenance_supporterApp.swift`:
     ```swift
     import Firebase
     ...
     init() {
         FirebaseApp.configure()
         ...
     }
     ```

### Installation

1. **Clone the repository:**
   ```sh
   git clone https://github.com/Sridesh/health-maintenance-supporter.git
   ```
2. **Open the project in Xcode:**
   - Open `health-maintenance-supporter.xcodeproj`.
3. **Install dependencies:**
   - If using CocoaPods: `pod install` in the project directory.
   - If using SPM: Xcode will resolve packages automatically.
4. **Configure Capabilities:**
   - Enable HealthKit, Background Modes, Push Notifications, and FaceID/TouchID in your Xcode project settings.
5. **Build and run on a real device** (HealthKit and biometrics require a physical device).

---

## Project Structure

- `ContentView.swift` – App entry point
- `Tabs.swift` – Main tab navigation
- `Views/` – SwiftUI screens (Dashboard, Meals, Health, Profile, etc.)
- `Components/` – Reusable UI components (charts, cards, buttons)
- `Models/` – Data models (meals, user, goals, etc.)
- `ViewModels/` – State management and business logic
- `Services/` – Integrations (Firebase, HealthKit, biometrics, notifications)
- `Data/` – Static/sample data (macros, goals)
- `Assets.xcassets/` – App icons, images, and color sets

## Core Technologies

- **SwiftUI** – Declarative UI
- **CoreML & Vision** – Food image classification
- **HealthKit** – Health data integration
- **Firebase** – Authentication, Firestore, cloud sync
- **UserNotifications** – Reminders and daily reports

---

## Usage Guide

### Onboarding & Authentication

1. **Launch the app** – New users are guided through onboarding to enter personal details and set goals.
2. **Sign Up / Sign In** – Register or log in using email/password (Firebase Auth). Biometric unlock is available after first login.

#### Example: Firebase Authentication (Register)

```swift
import FirebaseAuth

Auth.auth().createUser(withEmail: email, password: password) { result, error in
    if let error = error {
        print(error.localizedDescription)
    } else {
        print("User registered: \(result?.user.email ?? "")")
    }
}
```

### Logging Meals with AI

Users can log food by searching or using the AI classifier:

```swift
// CameraClassificationView: Take a photo and classify food
Button("Take Photo") {
    isCameraPresented = true
}
// ...
if let image = selectedImage {
    // Use CoreML & Vision to classify
    let model = try VNCoreMLModel(for: FoodClassifier().model)
    // ...
}
```

### Activity & Progress Tracking

The app syncs with HealthKit for real-time activity data:

```swift
import HealthKit
let healthStore = HKHealthStore()
// Request authorization and fetch steps, distance, calories, etc.
```

### Notifications

Reminders are scheduled using UserNotifications:

```swift
let content = UNMutableNotificationContent()
content.title = "Time to drink water"
let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60*30, repeats: true)
let request = UNNotificationRequest(identifier: "waterReminder", content: content, trigger: trigger)
UNUserNotificationCenter.current().add(request)
```

---

## Testing

- Unit and UI tests are located in `health-maintenance-supporterTests/` and `health-maintenance-supporterUITests/`.
- Run tests via Xcode's Test navigator or with `Cmd+U`.

---

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for improvements or bug fixes.

## License

_Specify your license here (e.g., MIT, Apache 2.0, etc.)_

---

For questions or support, please open an issue on GitHub.

- Developed by Sridesh 001
- Food image classification powered by CoreML
- Health data via Apple HealthKit
- Authentication and cloud via Firebase

## License

_Specify your license here (e.g., MIT, Apache 2.0, etc.)_

---

_For questions or contributions, please open an issue or submit a pull request._
