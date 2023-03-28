import UIKit

protocol SearchCoordinatorProtocol {}

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
}
