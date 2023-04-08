import UIKit
import SDWebImage

final class ProductCardSkeletonView: UIView {

    private lazy var productImageViewGradientLayer = SkeletonGradientLayer()

    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.addSublayer(productImageViewGradientLayer)

        let imageViewGroup = Animation.makeAnimationGroup()
        imageViewGroup.beginTime = 0.0
        productImageViewGradientLayer.add(imageViewGroup, forKey: "backgroundColor")

        return imageView
    }()

    private lazy var productTitleGradientLayer = SkeletonGradientLayer()

    private lazy var productTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "productTitleLabel"
        label.layer.addSublayer(productTitleGradientLayer)

        let titleGroup = Animation.makeAnimationGroup()
        titleGroup.beginTime = 0.0
        productTitleGradientLayer.add(titleGroup, forKey: "backgroundColor")

        return label
    }()

    private lazy var productDescriptionLabelLayer = SkeletonGradientLayer()

    private lazy var productDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "productDescriptionLabel"
        label.numberOfLines = 2
        label.layer.addSublayer(productDescriptionLabelLayer)

        let descriptionGroup = Animation.makeAnimationGroup()
        descriptionGroup.beginTime = 0.0
        productDescriptionLabelLayer.add(descriptionGroup, forKey: "backgroundColor")

        return label
    }()

    let productRatingViewLayer = SkeletonGradientLayer()

    private lazy var productRatingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.addSublayer(productRatingViewLayer)

        let productRatingViewGroup = Animation.makeAnimationGroup()
        productRatingViewGroup.beginTime = 0.0
        productRatingViewLayer.add(productRatingViewGroup, forKey: "backgroundColor")

        return view
    }()

    let productPriceLabelLayer = SkeletonGradientLayer()

    private lazy var productPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$0.0"
        label.layer.addSublayer(productPriceLabelLayer)

        let productPriceLabelGroup = Animation.makeAnimationGroup()
        productPriceLabelGroup.beginTime = 0.0
        productPriceLabelLayer.add(productPriceLabelGroup, forKey: "backgroundColor")

        return label
    }()

    let productBuyButtonLayer = SkeletonGradientLayer()

    private lazy var productBuyButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.addSublayer(productBuyButtonLayer)

        let productBuyButtonGroup = Animation.makeAnimationGroup()
        productBuyButtonGroup.beginTime = 0.0
        productBuyButtonLayer.add(productBuyButtonGroup, forKey: "backgroundColor")

        return button
    }()

    // MARK: - Init
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addUIElements()
        configureConstraints()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        productTitleGradientLayer.frame = productTitleLabel.bounds
        productTitleGradientLayer.cornerRadius = Theme.CornerRadius.skeleton

        productImageViewGradientLayer.frame = productImageView.bounds
        productImageViewGradientLayer.cornerRadius = Theme.CornerRadius.skeleton

        productDescriptionLabelLayer.frame = productDescriptionLabel.bounds
        productDescriptionLabelLayer.cornerRadius = Theme.CornerRadius.skeleton

        productRatingViewLayer.frame = productRatingView.bounds
        productRatingViewLayer.cornerRadius = Theme.CornerRadius.skeleton

        productPriceLabelLayer.frame = productPriceLabel.bounds
        productPriceLabelLayer.cornerRadius = Theme.CornerRadius.skeleton

        productBuyButtonLayer.frame = productBuyButton.bounds
        productBuyButtonLayer.cornerRadius = Theme.CornerRadius.skeleton

    }

    required init?(coder: NSCoder) {
        fatalError("ProductCard has not been implemented")
    }
}

// MARK: - Constraints
extension ProductCardSkeletonView {
    private func addUIElements() {
        addSubview(productImageView)
        addSubview(productTitleLabel)
        addSubview(productDescriptionLabel)
        addSubview(productRatingView)
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

        let productRatingViewConstraints = [
            productRatingView.topAnchor.constraint(equalTo: productDescriptionLabel.bottomAnchor, constant: 12),
            productRatingView.leadingAnchor.constraint(equalTo: leadingAnchor),
            productRatingView.widthAnchor.constraint(equalToConstant: 40),
            productRatingView.heightAnchor.constraint(equalToConstant: 15)
        ]

        let productPriceLabelConstraints = [
            productPriceLabel.centerYAnchor.constraint(equalTo: productRatingView.centerYAnchor),
            productPriceLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ]

        let productBuyButtonConstraints = [
            productBuyButton.topAnchor.constraint(equalTo: productRatingView.bottomAnchor, constant: 20),
            productBuyButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            productBuyButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            productBuyButton.heightAnchor.constraint(equalToConstant: 25),
            productBuyButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ]

        NSLayoutConstraint.activate(productImageViewConstraints)
        NSLayoutConstraint.activate(productTitleLabelConstraints)
        NSLayoutConstraint.activate(productDescriptionLabelConstraints)
        NSLayoutConstraint.activate(productRatingViewConstraints)
        NSLayoutConstraint.activate(productPriceLabelConstraints)
        NSLayoutConstraint.activate(productBuyButtonConstraints)
    }
}
