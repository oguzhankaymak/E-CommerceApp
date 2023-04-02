import Foundation

struct Product: Decodable {
    let id: Int
    let title: String
    let price: Double
    let description, category: String
    let image: String
    let rating: Rating
}

// MARK: - Rating
struct Rating: Decodable {
    let rate: Double
    let count: Int
}
