import UIKit
import SDWebImage

protocol ProductCollectionReusableHeaderViewDelegate: AnyObject {
    func exploreButtonDidTap()
}

class ProductCollectionReusableHeaderView: UICollectionReusableView {

    static let kind = "product-collection-header"
    static let identifier = "product-collection-header"

    weak var delegate: ProductCollectionReusableHeaderViewDelegate?

    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.Color.antiFlashWhite
        view.layer.cornerRadius = Theme.CornerRadius.large
        return view
    }()

    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false

        let image = UIImage(named: "undraw_shopping_app")
        imageView.image = image
        imageView.accessibilityIdentifier = "colletion_header_imageView"
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "You can find everything"
        label.font = Theme.AppFont.italicSmall
        label.textColor = Theme.Color.black
        label.textAlignment = .center
        return label
    }()

    private lazy var exploreButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.Color.black
        button.layer.cornerRadius = Theme.CornerRadius.normal
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(exploreButtonDidTap), for: .touchUpInside)
        button.accessibilityIdentifier = "explore_button"
        return button
    }()

    private lazy var exploreButtonLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Explore"
        label.font = Theme.AppFont.italicSmall
        label.textColor = Theme.Color.white
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Theme.Color.backgroundColor
        addUIElements()
        configureConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("ProductCollectionReusableHeaderView has not been implemented")
    }

    @objc private func exploreButtonDidTap() {
        delegate?.exploreButtonDidTap()
    }
}

// MARK: - Constraints
extension ProductCollectionReusableHeaderView {
    private func addUIElements() {
        addSubview(containerView)
        addSubview(productImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(exploreButton)
        exploreButton.addSubview(exploreButtonLabel)
    }

    private func configureConstraints() {

        let containerViewConstraints = [
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 40),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -60)
        ]

        let productImageViewConstraints = [
            productImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: -30),
            productImageView.leadingAnchor.constraint(equalTo: containerView.centerXAnchor, constant: 20),
            productImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            productImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ]

        let titleLabelConstraints = [
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -20),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: productImageView.leadingAnchor, constant: -20)
        ]

        let exploreButtonConstraints = [
            exploreButton.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor),
            exploreButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            exploreButton.widthAnchor.constraint(equalToConstant: 100),
            exploreButton.heightAnchor.constraint(equalToConstant: 30)
        ]

        let exploreTitleLabelConstraints = [
            exploreButtonLabel.centerXAnchor.constraint(equalTo: exploreButton.centerXAnchor),
            exploreButtonLabel.centerYAnchor.constraint(equalTo: exploreButton.centerYAnchor)
        ]

        NSLayoutConstraint.activate(containerViewConstraints)
        NSLayoutConstraint.activate(productImageViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(exploreButtonConstraints)
        NSLayoutConstraint.activate(exploreTitleLabelConstraints)
    }
}
