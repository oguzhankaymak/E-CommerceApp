import UIKit
import SDWebImage

final class ProductCard: UIView {

    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = Theme.CornerRadius.normal
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private lazy var productTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Theme.AppFont.productCardTitle
        label.textColor = Theme.Color.black
        return label
    }()

    private lazy var productDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Theme.AppFont.productCardDescription
        label.textColor = Theme.Color.gray
        label.numberOfLines = 2
        return label
    }()

    private lazy var productRatingImageView: UIImageView = {
        let icon = UIImage(
            systemName: "star.fill",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 10, weight: .bold)
        )?.withTintColor(Theme.Color.starColor, renderingMode: .alwaysOriginal)

        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = icon

        return imageView
    }()

    private lazy var productRatingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Theme.AppFont.productRating
        label.textColor = Theme.Color.gray
        return label
    }()

    private lazy var productPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Theme.AppFont.productCardPrice
        label.textColor = Theme.Color.black
        return label
    }()

    private lazy var productBuyButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add to cart", for: .normal)
        button.backgroundColor = .gray
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = Theme.CornerRadius.small
        button.layer.masksToBounds = true
        return button
    }()

    // MARK: - Init
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addUIElements()
        configureConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("ProductCard has not been implemented")
    }
}

// MARK: - Configure
extension ProductCard {
    func configure(
        productImageURL: URL,
        productTitle: String,
        productDescription: String,
        productPrice: String,
        productRating: String
    ) {
        productImageView.sd_setImage(with: productImageURL)
        productTitleLabel.text = productTitle
        productDescriptionLabel.text = productDescription
        productPriceLabel.text =  productPrice
        productRatingLabel.text = productRating
    }
}

// MARK: - Constraints
extension ProductCard {
    private func addUIElements() {
        addSubview(productImageView)
        addSubview(productTitleLabel)
        addSubview(productDescriptionLabel)
        addSubview(productRatingImageView)
        addSubview(productRatingLabel)
        addSubview(productPriceLabel)
        addSubview(productBuyButton)
    }

    private func configureConstraints() {
        let productImageViewConstraints = [
            productImageView.topAnchor.constraint(equalTo: topAnchor),
            productImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            productImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            productImageView.bottomAnchor.constraint(equalTo: centerYAnchor, constant: 10)
        ]

        let productTitleLabelConstraints = [
            productTitleLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 10),
            productTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            productTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ]

        let productDescriptionLabelConstraints = [
            productDescriptionLabel.topAnchor.constraint(equalTo: productTitleLabel.bottomAnchor, constant: 8),
            productDescriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            productDescriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ]

        let productRatingImageViewConstraints = [
            productRatingImageView.topAnchor.constraint(equalTo: productDescriptionLabel.bottomAnchor, constant: 12),
            productRatingImageView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ]

        let productRatingLabelConstraints = [
            productRatingLabel.leadingAnchor.constraint(equalTo: productRatingImageView.trailingAnchor, constant: 2),
            productRatingLabel.centerYAnchor.constraint(equalTo: productRatingImageView.centerYAnchor)
        ]

        let productPriceLabelConstraints = [
            productPriceLabel.centerYAnchor.constraint(equalTo: productRatingLabel.centerYAnchor),
            productPriceLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ]

        let productBuyButtonConstraints = [
            productBuyButton.topAnchor.constraint(equalTo: productRatingImageView.bottomAnchor, constant: 20),
            productBuyButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            productBuyButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            productBuyButton.heightAnchor.constraint(equalToConstant: 25),
            productBuyButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ]

        NSLayoutConstraint.activate(productImageViewConstraints)
        NSLayoutConstraint.activate(productTitleLabelConstraints)
        NSLayoutConstraint.activate(productDescriptionLabelConstraints)
        NSLayoutConstraint.activate(productRatingImageViewConstraints)
        NSLayoutConstraint.activate(productRatingLabelConstraints)
        NSLayoutConstraint.activate(productPriceLabelConstraints)
        NSLayoutConstraint.activate(productBuyButtonConstraints)
    }
}
