import Foundation

struct CartProduct: Codable, Equatable {
    let productId: Int
    var unitPrice: Double
    var totalPrice: Double
    let title, description, brand, category: String
    let thumbnail: String
    var quantity: Int

    static func == (lhs: CartProduct, rhs: CartProduct) -> Bool {
        return lhs.productId == rhs.productId
            && lhs.unitPrice == rhs.unitPrice
            && lhs.totalPrice == rhs.totalPrice
            && lhs.title == rhs.title
            && lhs.description == rhs.description
            && lhs.category == rhs.category
            && lhs.quantity == rhs.quantity
    }
}
