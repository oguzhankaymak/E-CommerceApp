import UIKit

protocol CartProductTableViewCellDelegate: AnyObject {
    func didTapPlusButton()
    func didTapMinusButton()
}

class CartProductTableViewCell: UITableViewCell {

    static let identifier = "cart-product-cell"

    weak var delegate: CartProductTableViewCellDelegate?

    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.Color.backgroundColor
        return view
    }()

    private lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = Theme.CornerRadius.normal
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Theme.AppFont.productCardTitle
        label.textColor = Theme.Color.black
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Theme.AppFont.productCardDescription
        label.textColor = Theme.Color.gray
        label.numberOfLines = 2
        return label
    }()

    private lazy var quantityInputView = QuantityInputView()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Theme.AppFont.productCardPrice
        label.textColor = Theme.Color.black
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none

        addUIElements()
        configureConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("CartProductTableViewCell has not been implemented")
    }
}

// MARK: - Configure
extension CartProductTableViewCell {
    func configure(image: String, title: String, description: String, price: Double, quantity: Int) {
        guard let imageURL = URL(string: image) else { return }

        thumbnailImageView.sd_setImage(with: imageURL)
        titleLabel.text = title
        descriptionLabel.text = description
        priceLabel.text = String(format: "$%.02f", price)
        quantityInputView.quantityLabel.text = ToString(quantity)

        quantityInputView.delegate = self
    }
}

// MARK: - QuantityInputDelegate
extension CartProductTableViewCell: QuantityInputViewDelegate {
    func didTapPlusButton() {
        delegate?.didTapPlusButton()
    }

    func didTapMinusButton() {
        delegate?.didTapMinusButton()
    }
}

// MARK: - Constraints
extension CartProductTableViewCell {

    private func addUIElements() {
        contentView.addSubview(containerView)
        containerView.addSubview(thumbnailImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(quantityInputView)
        containerView.addSubview(priceLabel)
    }

    private func configureConstraints() {

        let containerViewConstraints = [
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]

        let thumbnailImageViewConstraints = [
            thumbnailImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            thumbnailImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 120),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 120)
        ]

        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: thumbnailImageView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 10)
        ]

        let descriptionLabelConstraints = [
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ]

        let quantityInputViewConstraints = [
            quantityInputView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 30),
            quantityInputView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            quantityInputView.trailingAnchor.constraint(equalTo: containerView.centerXAnchor),
            quantityInputView.heightAnchor.constraint(equalToConstant: 16)
        ]

        let priceLabelConstraints = [
            priceLabel.centerYAnchor.constraint(equalTo: quantityInputView.centerYAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ]

        NSLayoutConstraint.activate(containerViewConstraints)
        NSLayoutConstraint.activate(thumbnailImageViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(descriptionLabelConstraints)
        NSLayoutConstraint.activate(quantityInputViewConstraints)
        NSLayoutConstraint.activate(priceLabelConstraints)
    }
}
