import Foundation

final class CartViewModel {

    private(set) var productsInCartData = Observable<[CartProduct]>()
    private(set) var totalPrice = Observable<String>()

    init() {
        self.productsInCartData.value = AppData.cart
        calculateTotalPrice()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(userDefaultsDidChange),
            name: UserDefaults.didChangeNotification,
            object: nil
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func userDefaultsDidChange(_ notification: Notification) {
        if let updatedValue = notification.object as? UserDefaults, updatedValue == UserDefaults.standard {
            DispatchQueue.main.async {
                self.productsInCartData.value = AppData.cart
                self.calculateTotalPrice()
            }
        }
    }

    private func calculateTotalPrice() {
        let totalPriceValue = productsInCartData.value?.reduce(0, { $0 + ($1.price) })
        totalPrice.value = String(format: "$%.02f", totalPriceValue ?? 0)
    }
}
