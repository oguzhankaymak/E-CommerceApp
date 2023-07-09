import Foundation

final class HomeViewModel {
    private let apiCaller: APICallerProtocol

    private(set) var isLoading = Observable<Bool>()
    private(set) var hotSalesProducts = Observable<[Product]>()
    private(set) var recommendProducts = Observable<[Product]>()

    init(apiCaller: APICallerProtocol = APICaller()) {
        self.apiCaller = apiCaller
    }

    func getProducts() {
        self.isLoading.value = true
        apiCaller.getProducts { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let productResponse):

                    let products = productResponse.products

                    let hotSalesProducts = Array(products[...10])
                    let recommendProducts = Array(products[11..<products.endIndex])

                    self?.hotSalesProducts.value = hotSalesProducts
                    self?.recommendProducts.value = recommendProducts
                    self?.isLoading.value = false

                case .failure(let error):
                    print(error.localizedDescription)
                    self?.hotSalesProducts.value = []
                    self?.recommendProducts.value = []
                    self?.isLoading.value = false
                }
            }
        }
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

    func didSelectItemAt(
        coordinator: HomeCoordinatorProtocol?,
        indexPath: IndexPath
    ) {
        guard let isLoading = isLoading.value else {
            return
        }

        if !isLoading {
            var currentProduct: Product?

            switch indexPath.section {
            case 0:
                currentProduct = hotSalesProducts.value?[indexPath.row]
            case 1:
                currentProduct = recommendProducts.value?[indexPath.row]
            default:
                currentProduct = nil
            }

            guard let product = currentProduct else { return }

            coordinator?.goToProductDetail(product: product)
        }
    }
}
