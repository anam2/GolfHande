import UIKit
import SwiftUI

class LoginViewController: UIViewController, ObservableObject {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
    }

    private func setupNavigationBar() {
        self.navigationItem.title = "Login"
    }

    private func setupUI() {
        let loginView = LoginView()
        let loginViewHostingController = UIHostingController(rootView: loginView.environmentObject(self))
        addChild(loginViewHostingController)
        loginViewHostingController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginViewHostingController.view)
        loginViewHostingController.didMove(toParent: self)

        NSLayoutConstraint.activate([
            loginViewHostingController.view.widthAnchor.constraint(equalTo: view.widthAnchor),
            loginViewHostingController.view.heightAnchor.constraint(equalTo: view.heightAnchor),
            loginViewHostingController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginViewHostingController.view.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
}
