import FirebaseAuth

class LoginHandler {
    public static var shared = LoginHandler()

    // Provides FB how to construct email link.
    func setupActionCodeSettings() -> ActionCodeSettings {
        let actionCodeSettings = ActionCodeSettings()
        actionCodeSettings.url = URL(string: "https://www.example.com")
        // The sign-in operation has to always be completed in the app.
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
        return actionCodeSettings
    }

    func createNewAccount(email: String, password: String, completion: @escaping () -> Void) {
        Auth.auth().createUser(withEmail: email.trimmingCharacters(in: .whitespaces),
                               password: password) { authResult, error in
            if let error = error {
                NSLog(error.localizedDescription)
                return
            }
            NSLog("User with email: \(email) and password: \(password) was added successfully.")
            completion()
        }
    }

    func signIn(email: String,
                password: String,
                completion: @escaping (_ success: Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                NSLog("Sign In Failed \(error.localizedDescription)")
                completion(false)
            } else {
                NSLog("Sign In Success")
                completion(true)
            }
        }
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

    func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            NSLog(signOutError.localizedDescription)
        }
    }
}
