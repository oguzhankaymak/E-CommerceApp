import Foundation

final class ProductDetailViewModel {
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
            id: product.id,
            price: product.price,
            title: product.title,
            description: product.description,
            brand: product.brand,
            category: product.category,
            thumbnail: product.thumbnail,
            quantity: 1
        )

        CartHelper.addProductToCart(product: cartProduct)
    }
}
