import UIKit

class SearchViewController: UIViewController {

    var coordinator: SearchCoordinatorProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.Color.backgroundColor
    }
}
