# AuthxKit
Swift package for using biometric authentication services for iOS, iPadOS and macOS in a simple and elegant way

## Check if device has support for biometric authentication
```swift
import AuthxKit
if AuthxKit.shared.canUseBiometrics {
      // Do something
} else {
      // Fallback
}
```
