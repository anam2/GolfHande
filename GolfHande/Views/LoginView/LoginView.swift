import SwiftUI

struct LoginView: View {

    //    @EnvironmentObject var viewController: LoginViewController
    
    @State var email = ""
    @State var password = ""

    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding([.top, .leading, .trailing])
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding([.leading, .trailing, .bottom])
                }
                VStack {
                    Button(action: {
                        NSLog("Login Button Clicked")
                        LoginHandler.shared.signIn(email: email, password: password) { success in
                            if !success {
                                NSLog("Need to dispatch error pass/username error and prevent sign in")
                            } else {
                                NSLog("Login Success")
                                if let window = UIApplication.shared.windows.first {
                                    let navigationController = UINavigationController(rootViewController: MyScoresViewController())
                                    window.rootViewController = navigationController
                                    window.makeKeyAndVisible()
                                }
                                // viewController.navigationController?.pushViewController(MyScoresViewController(), animated: true)
                            }
                        }
                    }, label: {
                        Text("Login")
                    })
                    .padding(.bottom)
                    Button(action: {
                        NSLog("Signup Button Clicked")
                        let email = email
                        let password = password
                        LoginHandler.shared.createNewAccount(email: email, password: password) {
                            LoginHandler.shared.sendAuthLink(email: email)
                        }
                    }, label: {
                        Text("Sign Up")
                    })
                    .padding(.bottom)
                }
                Spacer()
            }
        }
    }
}

struct LoginTestView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
