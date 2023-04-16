import SwiftUI

struct SignUpView: View {
    // Parameters
    @Binding var showSignUpSheet: Bool
    @Binding var displayInfo: Bool
    @Binding var displayInfoType: InformationViewType?
    @Binding var displayInfoText: String

    // Variables
    @StateObject private var viewModel = SignUpViewModel()
    @State private var showOptionalViews: Bool = false

    var emailFieldView: some View {
        VStack(alignment: .leading) {
            Text("Email")
                .font(.system(size: 16.0))
            CoreSwiftUI.textField(text: "Email", bindingText: $viewModel.email)
        }
    }

    var passwordFieldView: some View {
        VStack(alignment: .leading) {
            Text("Password")
                .font(.system(size: 16.0))
            CoreSwiftUI.secureField(text: "Password", bindingText: $viewModel.password)
        }
    }

    var submitButton: some View {
        CoreSwiftUI.button(text: "Submit") {
            NSLog("Submit button clicked.")
            let userInformation = UserInformation(email: viewModel.email,
                                                  password: viewModel.password,
                                                  name: viewModel.name)
            viewModel.createAccount(userInformation: userInformation) { success, error in
                if !success, let errorMessage = error {
                    print("\(errorMessage)")
                    return
                }
                showSignUpSheet = false
                displayInfo = true
                displayInfoType = .success
                displayInfoText = "Your account was successfully created! Please login."
            }
        }
    }

    var optionalViews: some View {
        DisclosureGroup(isExpanded: $showOptionalViews) {
            VStack {
                CoreSwiftUI.textField(text: "Name", bindingText: $viewModel.name)
                    .padding([.bottom])
            }
            .padding([.top])
        } label: {
            Text("Optional Fields")
                .font(.system(size: 18.0))
        }
    }

    // MARK: MAIN BODY

    var body: some View {
        NavigationView {
            VStack {
                InformationView(viewType: .error, displayText: viewModel.errorDisplayText)
                    .frame(width: viewModel.displayError ? nil : .zero,
                           height: viewModel.displayError ? nil : .zero)
                    .opacity(viewModel.displayError ? 1 : 0)
                emailFieldView
                    .padding([.bottom])
                passwordFieldView
                Divider()
                    .padding()
                optionalViews
                Spacer()
                submitButton
                    .padding([.bottom], 30)
            }
            .padding([.top, .leading, .trailing], 20)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Sign Up")
            .navigationBarItems(leading: Button("Done",  action: {
                showSignUpSheet = false
            }))
            .overlay(CoreSwiftUI.loadingIndicatorView(isLoading: viewModel.isLoading))
        }
    }
}
