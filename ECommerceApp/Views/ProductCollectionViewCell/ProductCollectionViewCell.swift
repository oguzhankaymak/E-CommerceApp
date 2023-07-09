import UIKit

protocol ProductCollectionViewCellDelegate: AnyObject {
    func productBuyButtonDidTap(product: Product)
}

class ProductCollectionViewCell: UICollectionViewCell {

    static let identifier = "product_cell"
    static let accessibilityIdentifier = "product_cell"

    weak var delegate: ProductCollectionViewCellDelegate?
    var model: ProductCollectionViewCellViewModel?

    private lazy var productCardView = ProductCardView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        model = ProductCollectionViewCellViewModel()
        addUIElements()
        configureConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("ProductCollectionViewCell has not been implemented")
    }
}

extension ProductCollectionViewCell: ProductCardViewDelegate {

    func productBuyButtonDidTap() {
        guard let product = model?.product else { return }
        delegate?.productBuyButtonDidTap(product: product)
    }
}

// MARK: - Configure Model
extension ProductCollectionViewCell {
    func configureModel(product: Product) {

        self.model?.product = product

        guard let productImageUrl = URL(string: product.thumbnail) else { return }

        let productCardModel = ProductCardViewModel(
            id: product.id,
            title: product.title,
            brand: product.description,
            category: product.category,
            description: product.description,
            thumbnail: productImageUrl,
            formattedPrice: String(format: "$%.02f", product.price),
            rating: product.rating
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
