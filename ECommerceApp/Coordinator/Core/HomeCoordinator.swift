import UIKit

protocol HomeCoordinatorProtocol {
    func goToProductDetail(product: Product)
}

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

    func goToProductDetail(product: Product) {
        let productDetailCoordinator = ProductDetailCoordinator(
            navigationController: navigationController ?? UINavigationController(),
            product: product
        )

        coordinate(to: productDetailCoordinator)
    }
}
