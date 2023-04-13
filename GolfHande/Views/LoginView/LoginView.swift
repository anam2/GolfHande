import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel =  LoginViewModel()

    // MARK: UI COMPONENTS

    var loginButton: some View {
        CoreSwiftUI.button(text: "Login") {
            NSLog("Login Button Clicked")
            viewModel.signInUser(email: viewModel.email,
                                 password: viewModel.password)
        }
    }

    var signupButton: some View {
        CoreSwiftUI.button(text: "Sign Up") {
            NSLog("Signup Button Clicked")
            LoginHandler.shared.createNewAccount(email: viewModel.email, password: viewModel.password) {
                LoginHandler.shared.sendAuthLink(email: viewModel.email)
            }
        }
    }


    // MARK: CONTAINER VIEWS

    var userInputContainer: some View {
        VStack {
            TextField("Email", text: $viewModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding([.top, .leading, .trailing])
                .padding(.bottom, 10)
            SecureField("Password", text: $viewModel.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding([.leading, .trailing, .bottom])
        }
    }

    var buttonContainer: some View {
        VStack {
            loginButton
                .padding()
            signupButton
                .padding(.bottom)
        }
    }

    var errorMessageView: some View {
        HStack {
            Image(systemName: "exclamationmark.circle")
            Text(viewModel.displayErrorText)
                .font(.system(size: 14))
            Spacer()
        }
        .padding()
        .background(Color.red)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    // MARK: MAIN VIEW

    var body: some View {
        NavigationView {
            VStack {
                errorMessageView
                    .frame(width: viewModel.displayError ? nil : .zero,
                           height: viewModel.displayError ? nil : .zero)
                    .padding([.top, .leading, .trailing],
                             viewModel.displayError ? 20 : 0)
                    .opacity(viewModel.displayError ? 1 : 0)
                userInputContainer
                buttonContainer
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle("Login")
            .onChange(of: viewModel.dispatchMyScoresVC) { newValue in
                self.dispatchMyScoresViewController(newValue)
            }
        }
    }

    // MARK: PRIVATE FUNC

    private func dispatchMyScoresViewController(_ dispatch: Bool) {
        guard dispatch,
              let window = UIApplication.shared.windows.first else { return }
        let navigationController = UINavigationController(rootViewController: MyScoresViewController())
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}

struct LoginTestView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoginView()
        }
    }
}
