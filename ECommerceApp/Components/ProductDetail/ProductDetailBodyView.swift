import UIKit

final class ProductDetailBodyView: UIView {

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Theme.AppFont.title
        label.textColor = Theme.Color.black
        label.numberOfLines = 0
        label.accessibilityIdentifier = "title_label"
        return label
    }()

    private lazy var brandLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Theme.AppFont.productCardTitle
        label.textColor = Theme.Color.gray
        label.accessibilityIdentifier = "brand_label"
        return label
    }()

    private lazy var discountView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 60).isActive = true
        view.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return view
    }()

    private lazy var discountImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false

        let icon = UIImage(
            systemName: "percent",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 14, weight: .semibold)
        )

        imageView.image = icon
        imageView.tintColor = .red
        imageView.accessibilityIdentifier = "discount_imageView"
        return imageView
    }()

    private lazy var discountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Theme.AppFont.productInfo
        label.textColor = Theme.Color.gray
        label.accessibilityIdentifier = "discount_label"
        return label
    }()

    private lazy var ratingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 60).isActive = true
        view.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return view
    }()

    private lazy var ratingImageView: UIImageView = {
        let icon = UIImage(
            systemName: "star.fill",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 14, weight: .semibold)
        )?.withTintColor(Theme.Color.starColor, renderingMode: .alwaysOriginal)

        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = icon
        imageView.accessibilityIdentifier = "rating_imageView"
        return imageView
    }()

    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Theme.AppFont.productInfo
        label.textColor = Theme.Color.gray
        label.accessibilityIdentifier = "rating_label"
        return label
    }()

    private lazy var stockView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 40).isActive = true
        view.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return view
    }()

    private lazy var stockImageView: UIImageView = {
        let icon = UIImage(
            systemName: "bag.circle",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 14, weight: .semibold)
        )?.withTintColor(Theme.Color.gray, renderingMode: .alwaysOriginal)

        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = icon
        imageView.accessibilityIdentifier = "stock_imageView"
        return imageView
    }()

    private lazy var stockLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Theme.AppFont.productInfo
        label.textColor = Theme.Color.gray
        label.accessibilityIdentifier = "stock_label"
        return label
    }()

    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        return stackView
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Theme.AppFont.productCardTitle
        label.textColor = Theme.Color.gray
        label.numberOfLines = 0
        label.accessibilityIdentifier = "description_label"
        return label
    }()

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addUIElements()
        configureConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("ProductDetailBodyView has not been implemented")
    }
}

// MARK: - Configure
extension ProductDetailBodyView {

    func configure(
        title: String,
        brandName: String,
        discount: String,
        rating: String,
        stock: String,
        description: String
    ) {
        titleLabel.text = title
        brandLabel.text = brandName
        discountLabel.text = discount
        ratingLabel.text = rating
        stockLabel.text = stock
        descriptionLabel.text = description
    }
}

// MARK: - Constraints
extension ProductDetailBodyView {

    private func addUIElements() {
        addSubview(titleLabel)
        addSubview(brandLabel)
        addSubview(infoStackView)

        infoStackView.addArrangedSubview(discountView)
        infoStackView.addArrangedSubview(ratingView)
        infoStackView.addArrangedSubview(stockView)

        discountView.addSubview(discountImageView)
        discountView.addSubview(discountLabel)

        ratingView.addSubview(ratingImageView)
        ratingView.addSubview(ratingLabel)

        stockView.addSubview(stockImageView)
        stockView.addSubview(stockLabel)

        addSubview(descriptionLabel)
    }

    // swiftlint:disable function_body_length
    private func configureConstraints() {
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ]

        let brandLabelConstraints = [
            brandLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            brandLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            brandLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ]

        let infoStackViewConstraints = [
            infoStackView.topAnchor.constraint(equalTo: brandLabel.bottomAnchor, constant: 25),
            infoStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            infoStackView.widthAnchor.constraint(equalToConstant: 240)
        ]

        let discountImageViewConstraints = [
            discountImageView.topAnchor.constraint(equalTo: discountView.topAnchor),
            discountImageView.leadingAnchor.constraint(equalTo: discountView.leadingAnchor)
        ]

        let discountLabelConstraints = [
            discountLabel.centerYAnchor.constraint(equalTo: discountImageView.centerYAnchor),
            discountLabel.leadingAnchor.constraint(equalTo: discountImageView.trailingAnchor, constant: 4)
        ]

        let ratingImageViewConstraints = [
            ratingImageView.topAnchor.constraint(equalTo: ratingView.topAnchor),
            ratingImageView.leadingAnchor.constraint(equalTo: ratingView.leadingAnchor)
        ]

        let ratingLabelConstraints = [
            ratingLabel.centerYAnchor.constraint(equalTo: ratingImageView.centerYAnchor),
            ratingLabel.leadingAnchor.constraint(equalTo: ratingImageView.trailingAnchor, constant: 4)
        ]

        let stockImageViewConstraints = [
            stockImageView.topAnchor.constraint(equalTo: stockView.topAnchor),
            stockImageView.leadingAnchor.constraint(equalTo: stockView.leadingAnchor)
        ]

        let stockLabelConstraints = [
            stockLabel.centerYAnchor.constraint(equalTo: stockImageView.centerYAnchor),
            stockLabel.leadingAnchor.constraint(equalTo: stockImageView.trailingAnchor, constant: 4)
        ]

        let descriptionLabelConstrains = [
            descriptionLabel.topAnchor.constraint(equalTo: infoStackView.bottomAnchor, constant: 40),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor)
        ]

        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(brandLabelConstraints)
        NSLayoutConstraint.activate(infoStackViewConstraints)
        NSLayoutConstraint.activate(discountImageViewConstraints)
        NSLayoutConstraint.activate(discountLabelConstraints)
        NSLayoutConstraint.activate(ratingImageViewConstraints)
        NSLayoutConstraint.activate(ratingLabelConstraints)
        NSLayoutConstraint.activate(stockImageViewConstraints)
        NSLayoutConstraint.activate(stockLabelConstraints)
        NSLayoutConstraint.activate(descriptionLabelConstrains)
    }
}
