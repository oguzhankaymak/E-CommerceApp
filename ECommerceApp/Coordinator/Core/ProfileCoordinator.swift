import UIKit

protocol ProfileCoordinatorProtocol {}

class ProfileCoordinator: Coordinator, ProfileCoordinatorProtocol {

    weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let cartViewController = ProfileViewController()
        cartViewController.coordinator = self

        navigationController?.pushViewController(cartViewController, animated: false)
    }
}
