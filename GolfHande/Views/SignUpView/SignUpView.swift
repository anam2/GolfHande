import SwiftUI

struct SignUpView: View {
    // Parameters
    @Binding var showSignUpSheet: Bool

    // Variables
    @StateObject private var viewModel = SignUpViewModel()
    @State private var showOptionalViews: Bool = false

    var errorDisplayView: some View {
        CoreSwiftUI.createErrorDisplayView(text: viewModel.errorDisplayText)
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
        .onTapGesture {
            showOptionalViews.toggle()
        }
    }



    var body: some View {
        NavigationView {
            VStack {
                errorDisplayView
                    .frame(width: viewModel.displayError ? nil : .zero,
                           height: viewModel.displayError ? nil : .zero)
                    .opacity(viewModel.displayError ? 1 : 0)
                VStack(alignment: .leading) {
                    Text("Email")
                        .font(.system(size: 16.0))
                    CoreSwiftUI.textField(text: "Email", bindingText: $viewModel.email)
                        .padding([.bottom])
                }
                VStack(alignment: .leading) {
                    Text("Password")
                        .font(.system(size: 16.0))
                    CoreSwiftUI.secureField(text: "Password", bindingText: $viewModel.password)
                }
                Divider()
                    .padding()
                optionalViews
                submitButton
                    .padding()
                Spacer()
            }
            .padding([.top, .leading, .trailing], 20)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Sign Up")
            .navigationBarItems(trailing: Button("Done",  action: {
                showSignUpSheet = false
            }))
        }
    }

    // MARK: PRIVATE FUNCS
}

struct SignUpView_Previews: PreviewProvider {
    @State private static var showSignUpSheet: Bool = false

    static var previews: some View {
        SignUpView(showSignUpSheet: $showSignUpSheet)
    }
}
