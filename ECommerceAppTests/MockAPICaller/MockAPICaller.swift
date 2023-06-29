import Foundation
@testable import ECommerceApp

class MockAPICaller: APICallerProtocol {

    var productResult: Result<ProductResponse, Error>?
    var categoryResult: Result<CategoryResponse, Error>?
    var searchResult: Result<ProductResponse, Error>?

    func getProducts(completion: @escaping (Result<ProductResponse, Error>) -> Void) {
        if let result = productResult {
            completion(result)
        }
    }

    func getProductsByCategory(category: String, completion: @escaping (Result<ProductResponse, Error>) -> Void) {
        if let result = productResult {
            completion(result)
        }
    }

    func getCategories(completion: @escaping (Result<CategoryResponse, Error>) -> Void) {
        if let result = categoryResult {
            completion(result)
        }
    }

    func searchProducts(text: String, completion: @escaping (Result<ProductResponse, Error>) -> Void) {

        if let result = searchResult {
            completion(result)
        }
    }
}
