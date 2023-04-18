import UIKit
import SwiftUI

class TabBar: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .label
        setupVCs()
    }

    func setupVCs() {
        // Converts SwiftUI View into UIViewController.
        // let loginTestVC = UIHostingController(rootView: LoginView())
        let myScoresVC = MyScoresViewController()
        viewControllers = [
            createNavController(for: myScoresVC, title: "My Scores", image: UIImage(systemName: "pencil") ?? UIImage())
        ]
    }

    fileprivate func createNavController(for rootViewController: UIViewController,
                                         title: String,
                                         image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        return navController
    }
}
