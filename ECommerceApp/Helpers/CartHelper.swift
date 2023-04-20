final class CartHelper {

    static func addProductToCart(cartProduct: CartProduct) {
        let index = getIndexProductFromCartByProductId(productId: cartProduct.productId)

        if let index = index {
            increaseProductQuantityInCart(cartProductIndex: index)
        } else {
            let cartProduct = CartProduct(
                productId: cartProduct.productId,
                unitPrice: cartProduct.unitPrice,
                totalPrice: cartProduct.totalPrice,
                title: cartProduct.title,
                description: cartProduct.description,
                brand: cartProduct.brand,
                category: cartProduct.category,
                thumbnail: cartProduct.thumbnail,
                quantity: 1
            )

            AppData.cart.append(cartProduct)
        }
    }

    private static func increaseProductQuantityInCart(cartProductIndex: Int) {
        AppData.cart[cartProductIndex].quantity += 1
        AppData.cart[cartProductIndex].totalPrice += AppData.cart[cartProductIndex].unitPrice
    }

    static func decreaseProductQuantityInCart(cartProduct: CartProduct) {
        let index = getIndexProductFromCartByProductId(productId: cartProduct.productId)

        if let index = index {
            if AppData.cart[index].quantity > 1 {
                AppData.cart[index].quantity -= 1
                AppData.cart[index].totalPrice -= cartProduct.unitPrice
            } else {
                removeProductFromCart(cartProduct: cartProduct)
            }
        }
    }

    static func removeProductFromCart(cartProduct: CartProduct) {
        let index = getIndexProductFromCartByProductId(productId: cartProduct.productId)

        if let index = index {
            AppData.cart.remove(at: index)
        }
    }

    static func clearCart() {
        AppData.cart = []
    }

    private static func getIndexProductFromCartByProductId(productId: Int) -> Int? {
        let index = AppData.cart.firstIndex {
            $0.productId == productId
        }

        return index
    }
}
