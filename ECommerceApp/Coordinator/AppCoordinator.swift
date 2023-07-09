import UIKit

class AppCoordinator: Coordinator {
    let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let navigationController = UINavigationController()

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        clearCartForUITest()

        let startCoordinator = TabBarCoordinator(navigationController: navigationController)
        coordinate(to: startCoordinator)
    }

    // MARK: - Private Methods
    private func clearCartForUITest () {
        let arguments = CommandLine.arguments
        if arguments.contains("resetCart") {
            CartHelper.clearCart()
        }
    }
}
