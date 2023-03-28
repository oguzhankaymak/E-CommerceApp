import UIKit

class CartViewController: UIViewController {

    var coordinator: CartCoordinatorProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.Color.backgroundColor
    }
}
