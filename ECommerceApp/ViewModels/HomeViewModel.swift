import Foundation

final class HomeViewModel {
    private(set) var hotSalesProducts = Observable<[Product]>()
    private(set) var recommendProducts = Observable<[Product]>()

    func getProducts(limit: Int?) {
        APICaller.shared.getProducts(limit: limit) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let productResponse):
                    let products = productResponse.products

                    let hotSalesProducts = Array(products[...10])
                    let recommendProducts = Array(products[11..<products.endIndex])

                    self?.hotSalesProducts.value = hotSalesProducts
                    self?.recommendProducts.value = recommendProducts

                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}
