import UIKit

class MainTabbarViewController: UITabBarController {

    var coordinator: TabBarCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.Color.backgroundColor
        tabBar.tintColor = UIColor.label

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(userDefaultsDidChange),
            name: UserDefaults.didChangeNotification,
            object: nil
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func userDefaultsDidChange(_ notification: Notification) {
        if let updatedValue = notification.object as? UserDefaults, updatedValue == UserDefaults.standard {
            DispatchQueue.main.async {
                if AppData.cart.isEmpty {
                    self.tabBar.items?[2].badgeValue = nil
                } else {
                    self.tabBar.items?[2].badgeValue = ToString(AppData.cart.count)
                }
            }
        }
    }
}
