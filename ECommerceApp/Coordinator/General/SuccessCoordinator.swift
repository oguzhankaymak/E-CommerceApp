import UIKit

protocol SuccessCoordinatorProtocol {}

class SuccessCoordinator: Coordinator, SuccessCoordinatorProtocol {

    let navigationController: UINavigationController?

    let buttonName: String
    let buttonDidTap: (() -> Void)

    init(navigationController: UINavigationController, buttonName: String, buttonDidTap: @escaping (() -> Void)) {
        self.navigationController = navigationController
        self.buttonName = buttonName
        self.buttonDidTap = buttonDidTap
    }

    func start() {
        let successViewController = SuccessViewController()
        successViewController.coordinator = self
        successViewController.buttonName = buttonName
        successViewController.buttonDidTap = buttonDidTap
        successViewController.hidesBottomBarWhenPushed = true
        navigationController?.setViewControllers([successViewController], animated: true)
    }
}
