import Foundation

class LoginViewModel: ObservableObject {
    @Published var displayError = false
    @Published var email = ""
    @Published var password = ""
}
