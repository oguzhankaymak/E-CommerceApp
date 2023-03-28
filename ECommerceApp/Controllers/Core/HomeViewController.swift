import UIKit

class HomeViewController: UIViewController {

    var coordinator: HomeCoordinatorProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.Color.backgroundColor
    }
}
