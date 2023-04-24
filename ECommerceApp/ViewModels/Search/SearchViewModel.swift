import Foundation

final class SearchViewModel {

    private(set) var isLoading = Observable<Bool>()
    private(set) var activeCategory = Observable<String>()
    private(set) var products = Observable<[Product]>()

    init() {
        self.activeCategory.value = "All"
    }

    // MARK: - Public Methods
    func getProducts(limit: Int?) {
        self.isLoading.value = true
        APICaller.shared.getProducts(limit: limit) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let productResponse):

                    self?.products.value = productResponse.products
                    self?.isLoading.value = false

                case .failure(let error):
                    print(error.localizedDescription)
                    self?.isLoading.value = false
                }
            }
        }
    }

    func changeActiveCategory(category: String) {
        activeCategory.value = category
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
    }
}
