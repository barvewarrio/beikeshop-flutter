# BeikeShop Flutter App

A modern, cross-platform e-commerce mobile application built with Flutter.

## Features

*   **Authentication**:
    *   User Login & Registration with form validation.
    *   Secure token management and session persistence.
    *   Profile management.
*   **Product Browsing**:
    *   Dynamic Home Screen with promotional banners and featured products.
    *   Category navigation.
    *   Detailed Product Screen with image gallery and descriptions.
*   **Shopping Cart**:
    *   Add/Remove items.
    *   Adjust quantities.
    *   Real-time total calculation.
    *   Persistent cart state across app restarts.
*   **Address Management**:
    *   Create, Read, Update, Delete (CRUD) shipping addresses.
    *   Set default address.
    *   Address selection during checkout.
*   **Order System**:
    *   Streamlined Checkout process.
    *   Order placement and history tracking.
    *   Order detail view with status updates.
*   **State Management**:
    *   Powered by `provider` for efficient and reactive state updates.
    *   Local persistence using `shared_preferences`.

## Project Structure

```
lib/
├── api/          # API services and endpoints
├── models/       # Data models (Product, Cart, Order, User, Address)
├── providers/    # State management (Auth, Cart, Order, Address)
├── screens/      # UI Screens (Auth, Home, Product, Cart, Checkout, Order, Profile)
├── theme/        # App theming and styles
├── widgets/      # Reusable UI components
└── main.dart     # App entry point
```

## Getting Started

1.  Clone the repository:
    ```bash
    git clone https://github.com/yourusername/beikeshop-flutter.git
    ```
2.  Install dependencies:
    ```bash
    flutter pub get
    ```
3.  Run the app:
    ```bash
    flutter run
    ```

## Technologies Used

*   **Flutter**: UI Toolkit
*   **Provider**: State Management
*   **Shared Preferences**: Local Storage
*   **Cached Network Image**: Efficient image loading
*   **Intl**: Date formatting
*   **Font Awesome**: Icons
