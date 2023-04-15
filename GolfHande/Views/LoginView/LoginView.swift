import SwiftUI

struct LoginView: View {

    @ObservedObject var viewModel = LoginViewModel()
    @State var showSignUpSheet: Bool = false

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
            self.showSignUpSheet = true
        }
    }


    // MARK: CONTAINER VIEWS

    var userInputContainer: some View {
        VStack {
            CoreSwiftUI.textField(text: "Email", bindingText: $viewModel.email)
                .padding([.top, .leading, .trailing])
                .padding(.bottom, 10)
            CoreSwiftUI.secureField(text: "Password", bindingText: $viewModel.password)
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
        CoreSwiftUI.createErrorDisplayView(text: viewModel.displayErrorText)
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
            .sheet(isPresented: $showSignUpSheet) {
                SignUpView(showSignUpSheet: self.$showSignUpSheet)
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
