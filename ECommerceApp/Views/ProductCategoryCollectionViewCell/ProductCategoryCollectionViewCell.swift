import UIKit

class ProductCategoryCollectionViewCell: UICollectionViewCell {
    static let identifier = "product-category-cell"

    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.Color.white
        view.layer.cornerRadius = Theme.CornerRadius.small
        view.layer.borderColor = Theme.Color.black.cgColor
        view.layer.borderWidth = 1
        return view
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

// MARK: - configureModel
extension ProductCategoryCollectionViewCell {
    func configureModel(with productCategory: ProductCategoryCellViewModel) {
        titleLabel.text = productCategory.title
        if productCategory.isCurrentCategory {
            containerView.backgroundColor = Theme.Color.black
            titleLabel.textColor = Theme.Color.white
        }
    }
}

// MARK: - Constraints
extension ProductCategoryCollectionViewCell {
    private func addUIElements() {
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
    }

    private func configureConstraints() {
        let containerViewConstraints = [
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]

        let titleLabelConstraints = [
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20)
        ]

        NSLayoutConstraint.activate(containerViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
    }
}
