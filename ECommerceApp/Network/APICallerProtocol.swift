import Foundation

protocol APICallerProtocol {
    func getProducts(category: String?, completion: @escaping (Result<ProductResponse, Error>) -> Void)
    func getCategories(completion: @escaping (Result<CategoryResponse, Error>) -> Void)
    func searchProducts(text: String, completion: @escaping (Result<ProductResponse, Error>) -> Void)
}
