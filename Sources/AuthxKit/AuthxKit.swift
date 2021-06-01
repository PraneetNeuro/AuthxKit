import LocalAuthentication

public class AuthxKit {
    private init() {}
    public static var shared: AuthxKit = AuthxKit()
    
    private var authContext: LAContext = LAContext()
    private var defaultAuthenticationMessage: String = "Authenticate with Apple Watch to proceed"
    public var error: NSError?
    
    public var canUseBiometrics: Bool {
        return self.authContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error)
    }
    
    public func authenticateUsingWatch(authenticationMessage: String?, completion: @escaping (Bool, NSError?) -> Void) {
        if self.canUseBiometrics {
            self.authContext.evaluatePolicy(.deviceOwnerAuthenticationWithWatch, localizedReason: authenticationMessage ?? self.defaultAuthenticationMessage) { isAuthenticated, error in
                DispatchQueue.main.async {
                    completion(isAuthenticated, self.error)
                }
            }
        } else {
            self.authenticateUsingUserSetSecretKey(authenticationMessage: authenticationMessage ?? self.defaultAuthenticationMessage, completion: completion)
        }
    }
    
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
    
    public func authenticateUsingUserSetSecretKey(authenticationMessage: String?, completion: @escaping (Bool, NSError?) -> Void) {
        self.authContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: authenticationMessage ?? self.defaultAuthenticationMessage) {
            isAuthenticated, error in
                DispatchQueue.main.async {
                    completion(isAuthenticated, self.error)
                }
        }
    }
}
