import UIKit

protocol CartCoordinatorProtocol {}

class CartCoordinator: Coordinator, CartCoordinatorProtocol {

    weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let cartViewController = CartViewController()
        cartViewController.coordinator = self

        navigationController?.pushViewController(cartViewController, animated: false)
    }
}
