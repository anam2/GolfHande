import UIKit

class TabBar: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .label
        setupVCs()
    }

    func setupVCs() {
        viewControllers = [
            createNavController(for: MyScoresViewController(), title: "My Scores", image: UIImage(systemName: "folder") ?? UIImage()),
//            createNavController(for: ScoreInputViewController(), title: "Score Input", image: UIImage(systemName: "pencil") ?? UIImage())
        ]
    }

    fileprivate func createNavController(for rootViewController: UIViewController,
                                         title: String,
                                         image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        rootViewController.navigationItem.title = title
        return navController
    }
}
