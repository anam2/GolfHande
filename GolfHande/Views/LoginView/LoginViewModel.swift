import Foundation

class LoginViewModel: ObservableObject {
    @Published var displayError = false
    @Published var dispatchMyScoresVC = false
    @Published var isLoading = false

    @Published var email = ""
    @Published var password = ""
    @Published var displayErrorType: InformationViewType?
    @Published var displayErrorText = ""

    func signInUser(email: String, password: String) {
        self.isLoading = true
        LoginHandler.shared.signIn(email: email, password: password) { success, error in
            self.isLoading = false
            guard success else {
                self.displayErrorType = .error
                self.displayErrorText = error?.localizedDescription ?? "Error."
                self.displayError = true
                return
            }
            self.displayError = false
            self.dispatchMyScoresVC = true
        }
    }
}
