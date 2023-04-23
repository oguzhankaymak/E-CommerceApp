import Foundation

final class CartViewModel {

    var onComplete: (() -> Void)?
    private(set) var isLoading = Observable<Bool>()
    private(set) var cartData = Observable<[CartProduct]>()
    private(set) var totalPrice = Observable<String>()
    private(set) var warning = Observable<Warning>()

    init() {
        self.isLoading.value = false
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

    func checkout() {
        isLoading.value = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.isLoading.value = false
            CartHelper.clearCart()
            self.onComplete?()
        })
    }

    func clearCart() {
        if !checkIsLoading() {
            warning.value = Warning(
                title: "Are you sure?",
                message: "All products will be removed from your cart",
                warningType: "clearCart"
            )

            warning.value = nil
        }
    }

    func forceClearCart() {
        CartHelper.clearCart()
    }

    func addProductToCart(cartProduct: CartProduct) {
        if !checkIsLoading() {
            CartHelper.addProductToCart(cartProduct: cartProduct)
        }
    }

    func decreaseProductQuantityInCart(cartProduct: CartProduct) {
        if !checkIsLoading() {
            CartHelper.decreaseProductQuantityInCart(cartProduct: cartProduct)
        }
    }

    func removeProductFromCart(cartProduct: CartProduct) {
        if !checkIsLoading() {
            CartHelper.removeProductFromCart(cartProduct: cartProduct)
        }
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

    private func checkIsLoading() -> Bool {
        return isLoading.value ?? false
    }
}
