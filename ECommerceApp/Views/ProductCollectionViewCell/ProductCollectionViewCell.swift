import UIKit

protocol ProductCollectionViewCellDelegate: AnyObject {
    func productBuyButtonDidTap(product: ProductCardViewModel?)
}

class ProductCollectionViewCell: UICollectionViewCell {

    weak var delegate: ProductCollectionViewCellDelegate?

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

extension ProductCollectionViewCell: ProductCardViewDelegate {
    func productBuyButtonDidTap(product: ProductCardViewModel?) {
        delegate?.productBuyButtonDidTap(product: product)
    }
}

// MARK: - Configure Model
extension ProductCollectionViewCell {
    func configureModel(with model: ProductCollectionViewCellViewModel) {
        guard let productImageUrl = URL(string: model.thumbnail) else { return }

        let productCardModel = ProductCardViewModel(
            id: model.id,
            title: model.title,
            brand: model.description,
            category: model.category,
            description: model.brand,
            thumbnail: productImageUrl,
            price: model.price,
            rating: model.rating
        )

        productCardView.configure(model: productCardModel)
        productCardView.delegate = self
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
