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
### Use biometric authentication
Note: To use FaceID: add the key "Privacy - Face ID Usage Description" to your app's info.plist
```swift
import AuthxKit

AuthxKit.shared.authenticateUsingBiometrics(authenticationMessage: "Perform biometric authentication to proceed", completion: {
      isAuthenticated, _ in
      if isAuthenticated {
//          Perform action awaiting authentication
      } else {
//          Perform action in case of failed authentication
      }
})
```
### Use Apple Watch authentication (only available for macOS)
```swift
import AuthxKit

AuthxKit.shared.authenticateUsingWatch(authenticationMessage: "Perform authentication using Apple Watch") {
      isAuthenticated, error in
      if isAuthenticated {
//          Perform action awaiting authentication
      } else {
//          Perform action in case of failed authentication
      }
}
```
### Use password / passcode authentication
```swift
import AuthxKit

AuthxKit.shared.authenticateUsingUserSetSecretKey(authenticationMessage: "Perform authentication using password / passcode") {
      isAuthenticated, error in
      if isAuthenticated {
//          Perform action awaiting authentication
      } else {
//          Perform action in case of failed authentication
      }
}
```
