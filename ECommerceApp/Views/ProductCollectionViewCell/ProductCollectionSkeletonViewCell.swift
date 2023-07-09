import UIKit

class ProductCollectionSkeletonViewCell: UICollectionViewCell {

    static let identifier = "product_skeleton_cell"
    static let accessibilityIdentifier = "product_skeleton_cell"

    private lazy var productCardSkeletonView = ProductCardSkeletonView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addUIElements()
        configureConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("ProductCollectionSkeletonViewCell has not been implemented")
    }
}

// MARK: - Constraints
extension ProductCollectionSkeletonViewCell {

    private func addUIElements() {
        contentView.addSubview(productCardSkeletonView)
    }

    private func configureConstraints() {
        let productCardSkeletonViewConstraints = [
            productCardSkeletonView.topAnchor.constraint(equalTo: contentView.topAnchor),
            productCardSkeletonView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            productCardSkeletonView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            productCardSkeletonView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]

        NSLayoutConstraint.activate(productCardSkeletonViewConstraints)
    }
}
