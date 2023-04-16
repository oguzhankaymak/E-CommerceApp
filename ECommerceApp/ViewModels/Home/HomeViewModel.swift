import Foundation

final class HomeViewModel {
    private(set) var isLoading = Observable<Bool>()
    private(set) var hotSalesProducts = Observable<[Product]>()
    private(set) var recommendProducts = Observable<[Product]>()

    func getProducts(limit: Int?) {
        self.isLoading.value = true
        APICaller.shared.getProducts(limit: limit) { [weak self] result in
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
                    self?.isLoading.value = false
                }
            }
        }
    }

    func addProductToCart(product: ProductCollectionViewCellViewModel?) {

        guard let product = product else { return }

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
