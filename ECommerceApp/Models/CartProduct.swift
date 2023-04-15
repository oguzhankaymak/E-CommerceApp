import Foundation

struct CartProduct: Codable {
    let id: Int
    let price: Double
    let title, description, brand, category: String
    let thumbnail: URL
    var quantity: Int
}
