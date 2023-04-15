import FirebaseAuth

class LoginHandler {
    public static var shared = LoginHandler()

    /**
     Creates new account for GolfHandE.
     - Parameters:
        - email: [String] Email user has entered.
        - password: [String] Password user has entered
        - completion: [() -> Void] Closure that gets executed after account has been created.
     */
    func createNewAccount(email: String,
                          password: String,
                          completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        Auth.auth().createUser(withEmail: email.trimmingCharacters(in: .whitespaces),
                               password: password) { authResult, error in
            if let error = error {
                NSLog(error.localizedDescription)
                completion(false, error)
                return
            }
            NSLog("User with email: \(email) and password: \(password) was added successfully.")
            completion(true, nil)
        }
    }

    /**
     Signs user in to GolfHandE.
     - Parameters:
        - email: [String] Email user has entered.
        - password: [String] Password user has entered
        - completion: [() -> Void] Closure that gets executed after call to sign user in is made.
     */
    func signIn(email: String,
                password: String,
                completion: @escaping (_ success: Bool, _ errorMessage: Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                NSLog("Sign In Failed \(error)")
                completion(false, error)
            } else {
                NSLog("Sign In Success")
                completion(true, nil)
            }
        }
    }

    /**
     Signs user out of GolfHandE.
     */
    func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            NSLog(signOutError.localizedDescription)
        }
    }

    /*
     Emailing for verification when creating account
     */

    // Provides FB how to construct email link.
    private func setupActionCodeSettings() -> ActionCodeSettings {
        let actionCodeSettings = ActionCodeSettings()
        actionCodeSettings.url = URL(string: "https://www.example.com")
        // The sign-in operation has to always be completed in the app.
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
        return actionCodeSettings
    }

    /**
     Sends the authentication link to user's email, and save the user's email in case user completes email sign-in on same device.
     */
    func sendAuthLink(email: String) {
        let actionCodeSettings = setupActionCodeSettings()
        Auth.auth().sendSignInLink(toEmail: email,
                                   actionCodeSettings: actionCodeSettings) { error in
            if let error = error {
                // Display error page
                NSLog(error.localizedDescription)
                return
            }
            // Link successfuly sent. Inform user
            // Save email locally so you don't need to ask user for it again if they open link on same device.
            UserDefaults.standard.set(email, forKey: "Email")

            // Show message promopt to check email for link.
        }
    }

    func verifyLinkAndSignIn(email: String, emailLink: String) {
        if Auth.auth().isSignIn(withEmailLink: emailLink) {
            Auth.auth().signIn(withEmail: email, link: emailLink) { user, error in
                print(user)
                print(error)
            }
        }
    }
}
