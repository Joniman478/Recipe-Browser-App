# Recipe Browser App

A robust Flutter application for browsing and searching recipes using TheMealDB API.

## Project Details
- **Name:** Yonathan Tatek
- **ID:** ATE/6955/15
- **Track:** Mobile Development (Flutter)

## Description
This application allows users to:
- Browse recipes by categories (Beef, Chicken, Vegetarian, etc.).
- Search for recipes by name using a dedicated search bar.
- View detailed recipe information including:
    - High-quality thumbnails.
    - Comprehensive ingredients list with measurements.
    - Step-by-step cooking instructions.
    - Integration with YouTube for video tutorials.
- Toggle between Light and Dark modes.
- View a personalized user profile.

## Setup Instructions
1.  **Clone the repository:**
    ```bash
    git clone https://github.com/Joniman478/Recipe-Browser-App.git
    ```
2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```
3.  **Run the application:**
    ```bash
    flutter run
    ```
    *Note: The app is compatible with Android, iOS, and Web.*

## Architecture & Features
- **Clean Architecture:** Separated into `models`, `services`, and `screens`.
- **API Integration:** Uses the `http` package with a dedicated service layer.
- **Error Handling:** Robust handling for network issues, timeouts, and malformed data.
- **State Management:** Uses `FutureBuilder` for asynchronous data and `ValueNotifier` for theme switching.
- **Aesthetics:** Premium UI design utilizing `Google Fonts` and `Material 3` components.

## Limitations
- Relies on the free tier of TheMealDB API, which may have rate limits or occasional downtime.
- YouTube video playback depends on the availability of an external browser or YouTube app.
- Search results are limited to what the public API provides.
