import Foundation

struct CartProduct: Codable {
    let productId: Int
    var unitPrice: Double
    var totalPrice: Double
    let title, description, brand, category: String
    let thumbnail: String
    var quantity: Int
}
