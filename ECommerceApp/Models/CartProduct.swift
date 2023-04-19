import Foundation

struct CartProduct: Codable {
    let id: Int
    var price: Double
    let title, description, brand, category: String
    let thumbnail: String
    var quantity: Int
}
