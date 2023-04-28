import Foundation

struct Product: Codable {
    let id: Int
    let price: Double
    let title, description, brand, category, thumbnail: String
    let images: [String]
    let discountPercentage: Double
    let rating: Double
    let stock: Int
}
