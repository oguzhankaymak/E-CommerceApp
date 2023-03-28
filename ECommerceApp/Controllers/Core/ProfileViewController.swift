import UIKit

class ProfileViewController: UIViewController {

    var coordinator: ProfileCoordinatorProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.Color.backgroundColor
    }
}
