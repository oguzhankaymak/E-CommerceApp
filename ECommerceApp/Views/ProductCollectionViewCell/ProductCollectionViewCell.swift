import UIKit

class ProductCollectionViewCell: UICollectionViewCell {

    static let identifier = "product-cell"
    private lazy var productCard = ProductCard()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addUIElements()
        configureConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("ProductCollectionViewCell has not been implemented")
    }
}

// MARK: - Configure Model
extension ProductCollectionViewCell {
    func configureModel(with model: ProductCollectionViewCellViewModel) {
        guard let productImageUrl = URL(string: model.thumbnail) else { return }

        productCard.configure(
            productImageURL: productImageUrl,
            productTitle: model.title,
            productDescription: model.description,
            productPrice: "$\(model.price)",
            productRating: "\(model.rating)"
        )
    }
}

// MARK: - Constraints
extension ProductCollectionViewCell {

    private func addUIElements() {
        contentView.addSubview(productCard)
    }

    private func configureConstraints() {
        let productCardViewConstraints = [
            productCard.topAnchor.constraint(equalTo: contentView.topAnchor),
            productCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            productCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            productCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]

        NSLayoutConstraint.activate(productCardViewConstraints)
    }
}
