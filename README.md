# Profit11 - Fantasy Trading Application

![Profit11](https://github.com/JayeshPatil18/profit11-codebase/blob/main/profit11.png)

**Profit11** is a fantasy stock market platform that allows users to create virtual portfolios, participate in contests, and compete based on stock price fluctuations in real time. The app offers an engaging experience similar to fantasy sports but applied to the stock market.

## Features
- **Fantasy Stock Trading**: Users can create virtual portfolios with real-time stock prices.
- **Contests & Leagues**: Compete with other users in different contests with varying entry fees and prize pools.
- **Real-Time Data**: Stock data is updated in real-time for accurate contest results.
- **Secure Transactions**: Secure payment gateway integration for deposits and withdrawals.
- **User Authentication**: OTP-based authentication for secure logins.
- **Leaderboard & Rankings**: Users are ranked based on the percentage increase in their portfolio value.
- **Wallet & Transactions**: Integrated digital wallet for managing entry fees and winnings.

## Clean Architecture (Profit11)
Profit11 follows the **Clean Architecture** principles, ensuring modularity and maintainability. It consists of four key layers:

### 1. **Presentation Layer (UI)**
- Built with **Flutter** for a responsive and seamless experience.
- Uses **Provider** for state management.
- Handles UI logic and user interactions.

### 2. **Application Layer (Business Logic)**
- Manages user actions such as contest participation and portfolio updates.
- Implements **StockProvider** to track selected stocks and contest-related operations.
- Communicates with the domain layer for processing business rules.

### 3. **Domain Layer (Use Cases & Entities)**
- Defines core business logic such as ranking calculations and wallet transactions.
- Contains use cases for stock selection, contest validation, and result processing.
- Entities include `User`, `Stock`, `Portfolio`, and `Contest`.

### 4. **Data Layer (Repositories & APIs)**
- **Firebase Firestore**: Stores users, contests, transactions, and rankings.
- **Upstox API**: Provides real-time stock market data.
- **Cashfree API**: Handles payment transactions.
- **Firebase Authentication**: Manages OTP-based login.
- **Firebase Storage**: Stores user profile images and other assets.

## Tech Stack
- **Frontend:** Flutter (Dart)
- **Backend:** Firebase (Firestore, Authentication, Cloud Storage)
- **Real-Time Data:** Upstox API
- **Payment Gateway:** Cashfree API
- **State Management:** Provider
- **Cloud Functions:** Node.js (for handling payments, contest validations, etc.)
- **Storage:** Firebase Storage
- **Authentication:** Firebase OTP Authentication

## How It Works
1. **User Registration & Authentication**
   - Users sign up using their mobile number and OTP authentication via Firebase.

2. **Joining Contests**
   - Users browse available contests and join by paying an entry fee from their wallet.

3. **Portfolio Creation**
   - Before entering a contest, users create a portfolio by selecting stocks.
   - Stock prices are fetched in real time via the Upstox API.

4. **Live Contest Tracking**
   - Once the contest starts, the system tracks the percentage increase in portfolio value.
   - Leaderboards update dynamically based on real-time stock data.

5. **Results & Payouts**
   - At contest completion, users are ranked based on portfolio performance.
   - Winnings are credited to the user's wallet and can be withdrawn securely via Cashfree API.

## References & Integrations
- **Upstox API**: Provides real-time stock price data for contests.
- **Cashfree Payment Gateway**: Manages deposits, withdrawals, and transactions.
- **Firebase Authentication**: Handles user login and OTP-based authentication.
- **Firebase Firestore**: Stores contest details, user data, and rankings.
- **Firebase Storage**: Manages user profile images and app-related files.

## Future Enhancements
- **AI-based Stock Recommendations** for helping users create better portfolios.
- **Referral & Bonus System** to encourage user engagement.
- **Push Notifications** for contest updates and reminders.
- **Multi-language Support** to expand accessibility.

## Setup & Installation
To run this project locally:
1. Clone the repository:
   ```sh
   git clone https://github.com/JayeshPatil18/Profit11.git
   cd Profit11
   ```
2. Install dependencies:
   ```sh
   flutter pub get
   ```
3. Set up Firebase by adding `google-services.json` (Android) and `GoogleService-Info.plist` (iOS).
4. Run the project:
   ```sh
   flutter run
   ```

## Contributing
Contributions are welcome! Feel free to submit a pull request or open an issue for feature suggestions.

## License
This project is licensed under the MIT License. See `LICENSE` for details.
