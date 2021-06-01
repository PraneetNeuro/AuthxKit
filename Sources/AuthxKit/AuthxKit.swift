import LocalAuthentication

public class AuthxKit {
    private init() {}
    public static var shared: AuthxKit = AuthxKit()
    
    private var authContext: LAContext = LAContext()
    private var defaultAuthenticationMessage: String = "Authenticate to proceed"
    private var error: NSError?
    
    /// Indicates if device has FaceID support
    public var isFaceIDAvailable: Bool {
        return self.authContext.biometryType == .faceID
    }
    
    /// Indicates if device has TouchID support
    public var isTouchIDAvailable: Bool {
        return self.authContext.biometryType == .touchID
    }
    
    /// Indicates if device supports biometric authentication
    public var canUseBiometrics: Bool {
        return self.authContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error)
    }
    
    #if os(macOS)
    /// Function used to authenticate macs with Apple Watch
    /// - Parameters:
    ///   - authenticationMessage: Message indicating the purpose of authentication
    ///   - completion: Callback code which is passed with a boolean indicating whether the authentication was successful or not and an NSError? if the authentication failed (Executed on the main thread
    public func authenticateUsingWatch(authenticationMessage: String?, completion: @escaping (Bool, NSError?) -> Void) {
        if self.canUseBiometrics {
            self.authContext.evaluatePolicy(.deviceOwnerAuthenticationWithWatch, localizedReason: authenticationMessage ?? "Authenticate using Apple Watch to proceed") { isAuthenticated, error in
                DispatchQueue.main.async {
                    completion(isAuthenticated, self.error)
                }
            }
        } else {
            self.authenticateUsingUserSetSecretKey(authenticationMessage: authenticationMessage ?? self.defaultAuthenticationMessage, completion: completion)
        }
    }
    #endif
    
    /// Function to authenticate using biometrics
    /// - Parameters:
    ///   - authenticationMessage: Message indicating the purpose of authentication
    ///   - completion: Callback code which is passed with a boolean indicating whether the authentication was successful or not and an NSError? if the authentication failed (Executed on the main thread
    public func authenticateUsingBiometrics(authenticationMessage: String?, completion: @escaping (Bool, NSError?) -> Void) {
        if self.canUseBiometrics {
            self.authContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: authenticationMessage ?? self.defaultAuthenticationMessage) { isAuthenticated, error in
                DispatchQueue.main.async {
                    completion(isAuthenticated, self.error)
                }
            }
        } else {
            self.authenticateUsingUserSetSecretKey(authenticationMessage: authenticationMessage ?? self.defaultAuthenticationMessage, completion: completion)
        }
    }
    
    /// Function to authenticate user with password / passcode
    /// - Parameters:
    ///   - authenticationMessage: Message indicating the purpose of authentication
    ///   - completion: Callback code which is passed with a boolean indicating whether the authentication was successful or not and an NSError? if the authentication failed (Executed on the main thread
    public func authenticateUsingUserSetSecretKey(authenticationMessage: String?, completion: @escaping (Bool, NSError?) -> Void) {
        self.authContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: authenticationMessage ?? self.defaultAuthenticationMessage) {
            isAuthenticated, error in
                DispatchQueue.main.async {
                    completion(isAuthenticated, self.error)
                }
        }
    }
}
