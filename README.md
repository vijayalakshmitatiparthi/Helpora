

https://github.com/user-attachments/assets/9ab5ab7a-2f33-4815-a53e-d9c32592f80e

# Helpora Demo

An original on-demand helper marketplace demo inspired by the broad idea of booking everyday assistance.

## Browser prototype

Open `index.html` in Chrome, Safari, or another modern browser. No server required.

Features:
- Six service categories
- Service request form and simulated price
- Demo booking confirmation
- Simulated helper tracking progression
- Booking history, saved to browser localStorage
- Wallet and profile mock screens
- Responsive desktop presentation and mobile-sized interactive UI

This is a front-end prototype. No production authentication, external APIs, real helpers, live maps, or actual payments are included.

## iOS SwiftUI version

The `ios/HelporaApp.swift` file is a working single-file SwiftUI starter with service selection, a booking sheet, simulated bookings, and tabs. Requires Xcode 15+ and an iOS 17+ target.

1. On a Mac, open Xcode > Create New Project > iOS > App.
2. Set Product Name to Helpora, Interface to SwiftUI, and Language to Swift.
3. Remove the default `ContentView.swift` and `YourProjectNameApp.swift` (or their declarations) from the target.
4. Add `ios/HelporaApp.swift` to the project target.
5. Select an iPhone simulator and press Run.

All bookings are demo-only. This starter does not use real payments, matching, or location tracking.
