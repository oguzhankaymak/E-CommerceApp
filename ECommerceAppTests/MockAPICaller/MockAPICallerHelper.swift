import Foundation
@testable import ECommerceApp

final class MockAPICallerHelper {

    static func createMockProductResponse(with products: [Product]? = nil) -> ProductResponse {
        let tempProducts = products ?? createMockProducts()
        return ProductResponse(
            products: tempProducts,
            total: tempProducts.count,
            skip: 0,
            limit: tempProducts.count
        )
    }

    static func createMockCategoryResponse (with categories: [String]? = nil) -> CategoryResponse {
        let tempCategories = categories ?? createMockCategories()
        return CategoryResponse(categories: tempCategories)
    }

    static func filterProducts(products: [Product], searchText: String) -> [Product] {
        let lowercaseSearchText = searchText.lowercased()

        let filteredProducts = products.filter { product in
            let lowercaseTitle = product.title.lowercased()
            let lowercaseDescription = product.description.lowercased()
            let lowercaseBrand = product.brand.lowercased()
            let lowercaseCategory = product.category.lowercased()

            return lowercaseTitle.contains(lowercaseSearchText) ||
                   lowercaseDescription.contains(lowercaseSearchText) ||
                   lowercaseBrand.contains(lowercaseSearchText) ||
                   lowercaseCategory.contains(lowercaseSearchText)
        }

        return filteredProducts
    }

    private static func createMockProducts() -> [Product] {
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

    private static func createMockCategories() -> [String] {
        return ["Smartphones", "Laptops", "Fragrances", "Skincare", "Groceries"]
    }
}
