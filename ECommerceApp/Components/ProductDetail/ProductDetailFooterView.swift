import UIKit

protocol ProductDetailFooterViewDelegate: AnyObject {
    func buyButtonDidTap()
}

final class ProductDetailFooterView: UIView {

    weak var delegate: ProductDetailFooterViewDelegate?

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Theme.AppFont.sectionTitle
        label.textColor = Theme.Color.black
        return label
    }()

    private lazy var buyButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false

        button.backgroundColor = Theme.Color.gray
        button.layer.cornerRadius = 10
        button.setTitle("Add to cart", for: .normal)
        button.setTitleColor(Theme.Color.white, for: .normal)
        button.addTarget(self, action: #selector(buyButtonDidTap), for: .touchUpInside)
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
        fatalError("ProductDetailFooterView has not been implemented")
    }

    @objc private func buyButtonDidTap() {
        delegate?.buyButtonDidTap()
    }
}

// MARK: - Configure
extension ProductDetailFooterView {
    func configure(price: String) {
        priceLabel.text = price
    }
}

// MARK: - Constraints
extension ProductDetailFooterView {
    private func addUIElements() {
        addSubview(priceLabel)
        addSubview(buyButton)
    }

    private func configureConstraints() {
        let priceLabelConstraints = [
            priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            priceLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]

        let buyButtonConstraints = [
            buyButton.widthAnchor.constraint(equalToConstant: 150),
            buyButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            buyButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            buyButton.heightAnchor.constraint(equalToConstant: 40)
        ]

        NSLayoutConstraint.activate(priceLabelConstraints)
        NSLayoutConstraint.activate(buyButtonConstraints)
    }
}
