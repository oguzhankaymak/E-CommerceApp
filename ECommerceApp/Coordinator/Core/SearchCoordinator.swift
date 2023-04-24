import UIKit

protocol SearchCoordinatorProtocol {
    func goToProductDetail(product: Product)
}

class SearchCoordinator: Coordinator, SearchCoordinatorProtocol {

    weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let searchViewController = SearchViewController()
        searchViewController.coordinator = self

        navigationController?.pushViewController(searchViewController, animated: false)
    }

    func goToProductDetail(product: Product) {
        let productDetailCoordinator = ProductDetailCoordinator(
            navigationController: navigationController ?? UINavigationController(),
            product: product
        )

        coordinate(to: productDetailCoordinator)
    }
}
