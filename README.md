# EasyGrocer 🛒

A modern, feature-rich grocery shopping mobile application built with Flutter. EasyGrocer provides a seamless shopping experience with beautiful UI, category filtering, cart management, and order tracking.

![Flutter](https://img.shields.io/badge/Flutter-3.24.5-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.5.4-0175C2?logo=dart)
![License](https://img.shields.io/badge/License-MIT-green)

## ✨ Features

- **🔐 User Authentication** - Simple email-based login system
- **🏪 Product Browsing** - Browse 47+ grocery products across 7 categories
- **🔍 Category Filtering** - Filter products by Breakfast, Snacks, Drinks, Fruits, Vegetables, Dairy, and Meat
- **🔎 Search Functionality** - Search products by name
- **🛒 Shopping Cart** - Add, remove, and adjust quantities
- **💳 Checkout Process** - Step-by-step checkout with order summary
- **📦 Order History** - View past orders and reorder with one tap
- **🎨 Premium UI/UX** - Modern Material 3 design with smooth animations
- **📱 Responsive Design** - Works on Android, iOS, Windows, and Web

## 📸 Screenshots

<p align="center">
  <img src="screenshots/login.png" width="200" alt="Login Screen"/>
  <img src="screenshots/home.png" width="200" alt="Home Screen"/>
  <img src="screenshots/cart.png" width="200" alt="Cart Screen"/>
  <img src="screenshots/orders.png" width="200" alt="Orders Screen"/>
</p>

## 🚀 Getting Started

### Prerequisites

Before you begin, ensure you have the following installed:

1. **Flutter SDK** (3.24.5 or higher)
   - Download from: https://flutter.dev/docs/get-started/install
   
2. **Android Studio** (Latest version)
   - Download from: https://developer.android.com/studio
   
3. **Git**
   - Download from: https://git-scm.com/downloads

4. **Java JDK** (17 or higher)
   - Included with Android Studio or download from: https://www.oracle.com/java/technologies/downloads/

### Installation Steps

#### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/easygrocer.git
cd easygrocer
```

#### 2. Open in Android Studio

1. Launch **Android Studio**
2. Click **File** → **Open**
3. Navigate to the cloned `easygrocer` folder and click **OK**
4. Wait for Android Studio to index the project

#### 3. Install Flutter Plugin (if not already installed)

1. Go to **File** → **Settings** (Windows/Linux) or **Android Studio** → **Preferences** (Mac)
2. Navigate to **Plugins**
3. Search for "Flutter" in the marketplace
4. Click **Install** and restart Android Studio

#### 4. Configure Flutter SDK Path

1. Go to **File** → **Settings** → **Languages & Frameworks** → **Flutter**
2. Set the **Flutter SDK path** to your Flutter installation directory
3. Click **Apply** and **OK**

#### 5. Install Dependencies

Open the terminal in Android Studio (View → Tool Windows → Terminal) and run:

```bash
flutter pub get
```

This will download all required packages listed in `pubspec.yaml`.

#### 6. Set Up Android Emulator

1. Open **AVD Manager**: **Tools** → **Device Manager**
2. Click **Create Device**
3. Select a phone (e.g., Pixel 7)
4. Choose a system image (API 33 or higher recommended)
5. Click **Finish**
6. Start the emulator by clicking the ▶️ play button

#### 7. Run the App

**Option A: Using Android Studio UI**
1. Select your device/emulator from the device dropdown (top toolbar)
2. Click the **Run** button (▶️) or press `Shift + F10`

**Option B: Using Terminal**
```bash
# Check available devices
flutter devices

# Run on connected device/emulator
flutter run

# Run on specific device
flutter run -d <device-id>
```

## 📱 Building for Production

### Android APK

```bash
# Build release APK
flutter build apk --release

# Build split APKs per ABI (smaller file size)
flutter build apk --split-per-abi
```

The APK will be located at: `build/app/outputs/flutter-apk/app-release.apk`

### Android App Bundle (for Google Play)

```bash
flutter build appbundle --release
```

The bundle will be located at: `build/app/outputs/bundle/release/app-release.aab`

### iOS Build

```bash
flutter build ios --release
```

_Note: Requires macOS with Xcode installed_

## 🏗️ Project Structure

```
easygrocer/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── models/                   # Data models
│   │   ├── product.dart         # Product model
│   │   └── order.dart           # Order models
│   ├── providers/               # State management
│   │   ├── auth_provider.dart   # Authentication logic
│   │   ├── cart_provider.dart   # Cart management
│   │   └── orders_provider.dart # Order history
│   ├── screens/                 # App screens
│   │   ├── auth_screen.dart     # Login screen
│   │   ├── home_screen.dart     # Main screen with tabs
│   │   ├── cart_screen.dart     # Shopping cart
│   │   ├── orders_screen.dart   # Order history
│   │   ├── product_details_screen.dart
│   │   └── checkout_screen.dart
│   ├── services/                # API services
│   │   └── api_service.dart     # Product data service
│   ├── theme/                   # Design system
│   │   ├── app_colors.dart      # Color palette
│   │   ├── app_typography.dart  # Text styles
│   │   ├── app_spacing.dart     # Spacing tokens
│   │   └── theme.dart           # Material theme
│   └── widgets/                 # Reusable components
│       ├── product_card.dart
│       ├── cart_item_card.dart
│       ├── category_chip.dart
│       └── empty_state.dart
├── assets/                      # Images and resources
├── android/                     # Android native code
├── ios/                         # iOS native code
├── test/                        # Unit tests
└── pubspec.yaml                 # Dependencies
```

## 🛠️ Technologies Used

- **Flutter** - UI framework
- **Dart** - Programming language
- **Provider** - State management
- **SharedPreferences** - Local data persistence
- **Material 3** - Design system
- **HTTP** - API calls (optional)
- **Cached Network Image** - Image caching

## 📦 Key Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.2              # State management
  shared_preferences: ^2.3.3    # Local storage
  intl: ^0.19.0                # Date formatting
  cached_network_image: ^3.4.1 # Image caching
```

## 🎯 Features in Detail

### Authentication
- Simple email validation
- Persistent login state
- Automatic session management

### Product Management
- 47 curated grocery products
- 7 categories with keyword-based filtering
- Real product images from Pexels/Unsplash
- Search functionality

### Shopping Cart
- Add/remove items
- Quantity adjustment with stepper
- Real-time total calculation
- Swipe-to-delete items

### Order System
- Order placement with address
- Order history (last 30 orders)
- Reorder functionality
- Order status tracking
- Detailed order view

## 🐛 Troubleshooting

### "Flutter SDK not found"
- Ensure Flutter is installed and added to PATH
- Set Flutter SDK path in Android Studio settings

### "Gradle build failed"
- Run `flutter clean` and then `flutter pub get`
- Check Java version: `java -version` (should be 17+)
- Update Gradle: Edit `android/gradle/wrapper/gradle-wrapper.properties`

### "Device not recognized"
- Enable USB debugging on Android device
- Check `flutter doctor` for any issues
- Restart ADB: `adb kill-server` and `adb start-server`

### Hot reload not working
- Stop the app and run again
- Try `flutter clean` if issues persist

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Contributors

- **Your Name** - Initial work - [YourGitHub](https://github.com/yourusername)

## 🙏 Acknowledgments

- Product images from [Pexels](https://pexels.com) and [Unsplash](https://unsplash.com)
- Icons from [Material Design](https://material.io/icons)
- Flutter team for the amazing framework

## 📧 Contact

For any queries or suggestions, please reach out:
- Email: your.email@example.com
- GitHub: [@yourusername](https://github.com/yourusername)

---
