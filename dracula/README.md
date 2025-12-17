# dracula

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## iOS TestFlight Release

To set up TestFlight for iOS:

### Prerequisites
- Apple Developer Program membership ($99/year)
- Xcode installed
- Unique Bundle ID (update in `ios/Runner.xcodeproj/project.pbxproj`)

### Steps
1. **App Store Connect Setup**
   - Create app at [appstoreconnect.apple.com](https://appstoreconnect.apple.com)
   - Add TestFlight testers

2. **Code Signing**
   ```bash
   open ios/Runner.xcworkspace
   ```
   - Select Runner > Signing & Capabilities
   - Choose Apple Developer team
   - Xcode will create certificates and profiles

3. **Build IPA**
   ```bash
   flutter build ipa --release
   ```

4. **Upload to TestFlight**
   - Open Xcode > Window > Organizer
   - Select archive > Distribute App
   - Choose TestFlight & App Store
   - Follow upload prompts

5. **Distribute**
   - In App Store Connect, select build
   - Add testers and distribute

### Fastlane (Alternative)
Install Fastlane and create `fastlane/Fastfile`:
```ruby
lane :beta do
  build_app(workspace: "ios/Runner.xcworkspace", scheme: "Runner")
  upload_to_testflight
end
```

Run: `fastlane beta`
