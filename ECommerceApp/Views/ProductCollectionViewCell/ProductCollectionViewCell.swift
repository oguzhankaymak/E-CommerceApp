import UIKit

class ProductCollectionViewCell: UICollectionViewCell {

    static let identifier = "product-cell"
    private lazy var productCardView = ProductCardView()

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

        productCardView.configure(
            productImageURL: productImageUrl,
            productTitle: model.title,
            productDescription: model.description,
            productPrice: "$\(model.price)",
            productRating: ToString(model.rating)
        )
    }
}

// MARK: - Constraints
extension ProductCollectionViewCell {

    private func addUIElements() {
        contentView.addSubview(productCardView)
    }

    private func configureConstraints() {
        let productCardViewConstraints = [
            productCardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            productCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            productCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            productCardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]

        NSLayoutConstraint.activate(productCardViewConstraints)
    }
}
