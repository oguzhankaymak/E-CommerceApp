import UIKit

class MainTabbarViewController: UITabBarController {

    var coordinator: TabBarCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.Color.backgroundColor
        tabBar.tintColor = UIColor.label
    }
}
