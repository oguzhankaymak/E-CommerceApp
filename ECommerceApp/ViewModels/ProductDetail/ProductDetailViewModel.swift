import Foundation

final class ProductDetailViewModel {

    private(set) var isVisibleSuccessView = Observable<Bool>()
    private(set) var activeCarouselImageIndex = Observable<Int>()

    init() {
        self.activeCarouselImageIndex.value = 0
    }

    // MARK: - Public Methods
    func changeActiveCarouselImageIndex(imageIndex: Int) {
        activeCarouselImageIndex.value = imageIndex
    }

    func addProductToCart(product: Product) {
        let cartProduct = CartProduct(
            productId: product.id,
            unitPrice: product.price,
            totalPrice: product.price,
            title: product.title,
            description: product.description,
            brand: product.brand,
            category: product.category,
            thumbnail: product.thumbnail,
            quantity: 1
        )

        CartHelper.addProductToCart(cartProduct: cartProduct)
        showAndHideSuccessView()
    }

    // MARK: - Private Methods
    private func showAndHideSuccessView() {
        isVisibleSuccessView.value = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            self.isVisibleSuccessView.value = false
        })
    }
}
