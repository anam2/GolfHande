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
        let myScoresVC = MyScoresViewController()
        let courseView = CourseViewController()

        viewControllers = [
            createNavController(for: myScoresVC, title: "My Scores", image: UIImage(systemName: "pencil") ?? UIImage()),
            createNavController(for: courseView, title: "Course View", image: UIImage(systemName: "eye") ?? UIImage()),
            createNavController(for: TestMapViewController(), title: "Test", image: UIImage(systemName: "pencil") ?? UIImage())
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

    fileprivate func createHostingController<V: View>(for view: V,
                                                      title: String,
                                                      image: UIImage) -> UIViewController {
        let hostingController = UIHostingController(rootView: view)
        hostingController.tabBarItem.title = title
        hostingController.tabBarItem.image = image
        return hostingController
    }
}
