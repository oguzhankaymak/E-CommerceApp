import UIKit

protocol HomeCoordinatorProtocol {}

class HomeCoordinator: Coordinator, HomeCoordinatorProtocol {

    weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let homeViewController = HomeViewController()
        homeViewController.coordinator = self

        navigationController?.pushViewController(homeViewController, animated: false)
    }
}
