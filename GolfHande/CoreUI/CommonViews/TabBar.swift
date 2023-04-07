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
        let loginTestVC = UIHostingController(rootView: LoginView())

//        viewControllers = [
//            createNavController(for: MyScoresViewController(), title: "My Scores", image: UIImage(systemName: "folder") ?? UIImage()),
//            createNavController(for: loginTestVC, title: "Test View Controller", image: UIImage(systemName: "pencil") ?? UIImage())
//        ]
    }

//    fileprivate func createNavController(for rootViewController: UIViewController,
//                                         title: String,
//                                         image: UIImage) -> UIViewController {
//        let navController = UINavigationController(rootViewController: rootViewController)
//        navController.tabBarItem.title = title
//        navController.tabBarItem.image = image
//        rootViewController.navigationItem.title = title
//        return navController
//    }
}
