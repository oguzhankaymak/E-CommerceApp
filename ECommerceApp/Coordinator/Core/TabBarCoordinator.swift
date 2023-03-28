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
        let homeCoordinator = HomeCoordinator(navigationController: homeNavigationController)

        let searchNavigationController = UINavigationController()
        searchNavigationController.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        let searchCoordinator = SearchCoordinator(navigationController: searchNavigationController)

        let chartNavigationController = UINavigationController()
        chartNavigationController.tabBarItem.image = UIImage(systemName: "cart")
        chartNavigationController.tabBarItem.selectedImage = UIImage(systemName: "cart.fill")
        let chartCoordinator = CartCoordinator(navigationController: chartNavigationController)

        let profileNavigationController = UINavigationController()
        profileNavigationController.tabBarItem.image = UIImage(systemName: "person.crop.circle")
        profileNavigationController.tabBarItem.selectedImage = UIImage(systemName: "person.crop.circle.fill")
        let profileCoordinator = ProfileCoordinator(navigationController: profileNavigationController)

        tabBarController.viewControllers = [
            homeNavigationController,
            searchNavigationController,
            chartNavigationController,
            profileNavigationController
        ]

        tabBarController.modalPresentationStyle = .fullScreen

        DispatchQueue.main.async {
            self.navigationController.present(tabBarController, animated: false, completion: nil)
        }

        coordinate(to: homeCoordinator)
        coordinate(to: searchCoordinator)
        coordinate(to: chartCoordinator)
        coordinate(to: profileCoordinator)
    }
}
