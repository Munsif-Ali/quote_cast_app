# QuoteCast App

## Setup Instructions

1. Clone the repository:

   ```bash
   git clone https://github.com/Munsif-Ali/quote_cast_app.git
   ```

2. Navigate to the project directory:
   ```bash
    cd quote_cast_app
   ```
3. Change the API Base URL in the `lib/core/constants/string_const.dart` file to point to your backend server:

   ```dart
   class StringConst {
    ..................
     static const String baseUrl = 'http://YOUR_BACKEND_SERVER_IP:3000/api';
    }
   ```

4. Install the required dependencies:
   ```bash
    flutter pub get
   ```
5. Run the application:
   ```bash
    flutter run
   ```
