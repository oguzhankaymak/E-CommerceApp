import UIKit

protocol CartCoordinatorProtocol {
    func goToSuccess()
}

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

    func goToSuccess() {
        let successCoordinator = SuccessCoordinator(
            navigationController: navigationController ?? UINavigationController(),
            buttonName: "Home",
            buttonDidTap: goToTabbar
        )

        coordinate(to: successCoordinator)
    }

    private func goToTabbar() {
        let startCoordinator = TabBarCoordinator(
            navigationController: self.navigationController ?? UINavigationController()
        )

        self.coordinate(to: startCoordinator)
    }
}
