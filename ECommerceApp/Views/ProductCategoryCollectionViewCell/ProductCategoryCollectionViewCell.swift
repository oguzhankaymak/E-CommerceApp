import UIKit

protocol ProductCategoryCollectionViewCellDelegate: AnyObject {
    func productCategoryButtonDidTap(category: String)
}

class ProductCategoryCollectionViewCell: UICollectionViewCell {

    static let identifier = "product-category-cell"

    weak var delegate: ProductCategoryCollectionViewCellDelegate?

    private lazy var containerButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.Color.white
        button.layer.cornerRadius = Theme.CornerRadius.small
        button.layer.borderColor = Theme.Color.black.cgColor
        button.layer.borderWidth = 1
        button.addTarget(
            self,
            action: #selector(productCategoryButtonDidTap),
            for: .touchUpInside
        )
        return button
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Theme.AppFont.emptyText
        label.textColor = Theme.Color.black
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addUIElements()
        configureConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("ProductCategoryCollectionViewCell has not been implemented")
    }
}

// MARK: - Configure Model
extension ProductCategoryCollectionViewCell {
    func configureModel(with productCategory: ProductCategoryCellViewModel) {
        containerButton.accessibilityIdentifier = productCategory.title
        titleLabel.text = productCategory.title
        if productCategory.isCurrentCategory {
            containerButton.backgroundColor = Theme.Color.black
            titleLabel.textColor = Theme.Color.white
        } else {
            containerButton.backgroundColor = Theme.Color.white
            titleLabel.textColor = Theme.Color.black
        }
    }
}

// MARK: - Target Methods
extension ProductCategoryCollectionViewCell {

    @objc private func productCategoryButtonDidTap(sender: UIButton) {
        delegate?.productCategoryButtonDidTap(category: sender.accessibilityIdentifier ??  "")
    }
}

// MARK: - Constraints
extension ProductCategoryCollectionViewCell {
    private func addUIElements() {
        contentView.addSubview(containerButton)
        containerButton.addSubview(titleLabel)
    }

    private func configureConstraints() {
        let containerButtonConstraints = [
            containerButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            containerButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            containerButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]

        let titleLabelConstraints = [
            titleLabel.leadingAnchor.constraint(equalTo: containerButton.leadingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: containerButton.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: containerButton.trailingAnchor, constant: -20)
        ]

        NSLayoutConstraint.activate(containerButtonConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
    }
}
