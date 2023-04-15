import UIKit

protocol ProductDetailCoordinatorProtocol {
    func goBack()
}

class ProductDetailCoordinator: Coordinator, ProductDetailCoordinatorProtocol {

    let navigationController: UINavigationController?
    let product: Product?

    init(navigationController: UINavigationController, product: Product) {
        self.navigationController = navigationController
        self.product = product
    }

    func start() {
        let productDetailViewController = ProductDetailViewController()
        productDetailViewController.product = product
        productDetailViewController.coordinator = self
        productDetailViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(productDetailViewController, animated: true)
    }

    // MARK: - FLOWS
    func goBack() {
        navigationController?.popViewController(animated: true)
    }
}
