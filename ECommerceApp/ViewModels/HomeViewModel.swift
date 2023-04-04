import Foundation

final class HomeViewModel {
    private(set) var products = Observable<[Product]>()

    func getProducts(limit: Int?) {
        APICaller.shared.getProducts(limit: limit) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let productResponse):
                    self?.products.value = productResponse.products

                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}
