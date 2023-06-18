import Foundation
@testable import ECommerceApp

class MockAPICaller: APICallerProtocol {

    var productResult: Result<ProductResponse, Error>?

    func getProducts(category: String?, completion: @escaping (Result<ProductResponse, Error>) -> Void) {

        if let result = productResult {
            completion(result)
        }
    }

    func getCategories(completion: @escaping (Result<CategoryResponse, Error>) -> Void) {
        let category1 = "smartphones"
        let result = CategoryResponse(categories: [category1])
        completion(.success(result))
    }

    func searchProducts(text: String, completion: @escaping (Result<ProductResponse, Error>) -> Void) {
        let product1 = Product(
            id: 1,
            price: 543,
            title: "iPhone 9",
            description: "An apple mobile which is nothing like apple",
            brand: "Apple",
            category: "smartphones",
            thumbnail: "https://i.dummyjson.com/data/products/1/thumbnail.jpg",
            images: [ "https://i.dummyjson.com/data/products/1/1.jpg"],
            discountPercentage: 12.96,
            rating: 4.3,
            stock: 12
        )

        let result = ProductResponse(products: [product1], total: 1, skip: 0, limit: 10)
        completion(.success(result))
    }

    func createMockProductResponse() -> ProductResponse {
        let products = createMockProducts()
        return ProductResponse(
            products: products,
            total: products.count,
            skip: 0,
            limit: products.count
        )
    }

    private func createMockProducts() -> [Product] {
        let product = Product(
            id: 1,
            price: 543,
            title: "iPhone 9",
            description: "An apple mobile which is nothing like apple",
            brand: "Apple",
            category: "smartphones",
            thumbnail: "https://i.dummyjson.com/data/products/1/thumbnail.jpg",
            images: [ "https://i.dummyjson.com/data/products/1/1.jpg"],
            discountPercentage: 12.96,
            rating: 4.3,
            stock: 12
        )

        return Array(repeating: product, count: 30)
    }

}
