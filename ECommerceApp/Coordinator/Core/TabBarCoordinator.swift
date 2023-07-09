import UIKit

class TabBarCoordinator: Coordinator {
    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let tabBarController = MainTabbarViewController()
        tabBarController.coordinator = self

        let homeNavigationController = UINavigationController()
        homeNavigationController.tabBarItem.image = UIImage(systemName: "house")
        homeNavigationController.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        homeNavigationController.tabBarItem.accessibilityIdentifier = "home_tabBarItem"
        let homeCoordinator = HomeCoordinator(navigationController: homeNavigationController)

        let searchNavigationController = UINavigationController()
        searchNavigationController.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        searchNavigationController.tabBarItem.accessibilityIdentifier = "search_tabBarItem"
        let searchCoordinator = SearchCoordinator(navigationController: searchNavigationController)

        let cartNavigationController = UINavigationController()
        cartNavigationController.tabBarItem.image = UIImage(systemName: "cart")
        cartNavigationController.tabBarItem.selectedImage = UIImage(systemName: "cart.fill")
        cartNavigationController.tabBarItem.badgeValue = AppData.cart.isEmpty ? nil : ToString(AppData.cart.count)
        cartNavigationController.tabBarItem.accessibilityIdentifier = "cart_tabBarItem"
        let cartCoordinator = CartCoordinator(navigationController: cartNavigationController)

        let profileNavigationController = UINavigationController()
        profileNavigationController.tabBarItem.image = UIImage(systemName: "person.crop.circle")
        profileNavigationController.tabBarItem.selectedImage = UIImage(systemName: "person.crop.circle.fill")
        profileNavigationController.tabBarItem.accessibilityIdentifier = "profile_tabBarItem"
        let profileCoordinator = ProfileCoordinator(navigationController: profileNavigationController)

        tabBarController.viewControllers = [
            homeNavigationController,
            searchNavigationController,
            cartNavigationController,
            profileNavigationController
        ]

        tabBarController.modalPresentationStyle = .fullScreen

        DispatchQueue.main.async {
            self.navigationController.present(tabBarController, animated: false, completion: nil)
        }

        coordinate(to: homeCoordinator)
        coordinate(to: searchCoordinator)
        coordinate(to: cartCoordinator)
        coordinate(to: profileCoordinator)
    }
}
