import Foundation

struct ProductCardViewModel {
    let id: Int
    let title, brand, category, description: String
    let thumbnail: URL
    let formattedPrice: String
    let rating: Double
}
