final class CartHelper {

    static func addProductToCart(product: CartProduct) {
        let index = AppData.cart.firstIndex {
            $0.id == product.id
        }

        if let index = index {
            AppData.cart[index].quantity += 1
        } else {
            AppData.cart.append(product)
        }
    }

    static func clearCart() {
        AppData.cart = []
    }
}
