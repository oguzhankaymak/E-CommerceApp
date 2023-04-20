import Foundation

final class CartViewModel {

    private(set) var cartData = Observable<[CartProduct]>()
    private(set) var totalPrice = Observable<String>()
    private(set) var warning = Observable<Warning>()

    init() {
        self.cartData.value = AppData.cart
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

    func clearCart() {
        warning.value = Warning(
            title: "Are you sure?",
            message: "All products will be removed from your cart",
            warningType: "clearCart"
        )

        warning.value = nil
    }

    func forceClearCart() {
        CartHelper.clearCart()
    }

    func addProductToCart(cartProduct: CartProduct) {
        CartHelper.addProductToCart(cartProduct: cartProduct)
    }

    func decreaseProductQuantityInCart(cartProduct: CartProduct) {
        CartHelper.decreaseProductQuantityInCart(cartProduct: cartProduct)
    }

    func removeProductFromCart(cartProduct: CartProduct) {
        CartHelper.removeProductFromCart(cartProduct: cartProduct)
    }

    @objc private func userDefaultsDidChange(_ notification: Notification) {
        if let updatedValue = notification.object as? UserDefaults, updatedValue == UserDefaults.standard {
            DispatchQueue.main.async {
                self.cartData.value = AppData.cart
                self.calculateTotalPrice()
            }
        }
    }

    private func calculateTotalPrice() {
        let totalPriceValue = cartData.value?.reduce(0, { $0 + ($1.totalPrice) })
        totalPrice.value = String(format: "$%.02f", totalPriceValue ?? 0)
    }
}
