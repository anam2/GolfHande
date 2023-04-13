import Foundation

class LoginViewModel: ObservableObject {
    @Published var displayError = false
    @Published var dispatchMyScoresVC = false
    @Published var email = ""
    @Published var password = ""
    @Published var displayErrorText = ""

    func signInUser(email: String, password: String) {
        LoginHandler.shared.signIn(email: email, password: password) { success, error in
            guard success else {
                self.displayErrorText = error?.localizedDescription ?? "Error."
                self.displayError = true
                return
            }
            self.displayError = false
            self.dispatchMyScoresVC = true
        }
    }
}
