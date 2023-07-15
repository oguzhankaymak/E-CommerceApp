import UIKit

protocol QuantityInputViewDelegate: AnyObject {
    func didTapPlusButton()
    func didTapMinusButton()
}

final class QuantityInputView: UIView {

    weak var delegate: QuantityInputViewDelegate?

    lazy var quantityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "1"
        label.font = Theme.AppFont.productCardPrice
        return label
    }()

    private lazy var plusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false

        let image = UIImage(
            systemName: "plus",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 8,
                weight: .medium
            )
        )?.withTintColor(.white, renderingMode: .alwaysOriginal)

        button.layer.cornerRadius = 4
        button.setImage(image, for: .normal)
        button.backgroundColor = Theme.Color.black
        button.addTarget(self, action: #selector(didTapPlusButton), for: .touchUpInside)
        button.accessibilityIdentifier = "plus_button"
        return button
    }()

    private lazy var minusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false

        let image = UIImage(
            systemName: "minus",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 10,
                weight: .medium
            )
        )?.withTintColor(.white, renderingMode: .alwaysOriginal)

        button.layer.cornerRadius = 4
        button.setImage(image, for: .normal)
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(didTapMinusButton), for: .touchUpInside)
        button.accessibilityIdentifier = "minus_button"
        return button
    }()

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false

        addUIElements()
        configureConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("QuantityInput has not been implemented")
    }
}

extension QuantityInputView {

    @objc private func didTapPlusButton() {
        delegate?.didTapPlusButton()
    }

    @objc private func didTapMinusButton() {
        delegate?.didTapMinusButton()
    }
}

// MARK: - Constraints
extension QuantityInputView {

    private func addUIElements() {
        addSubview(plusButton)
        addSubview(quantityLabel)
        addSubview(minusButton)
    }

    private func configureConstraints() {

        let plusButtonConstraints = [
            plusButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            plusButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            plusButton.widthAnchor.constraint(equalToConstant: 16),
            plusButton.heightAnchor.constraint(equalToConstant: 16)
        ]

        let quantityLabelConstraints = [
            quantityLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            quantityLabel.leadingAnchor.constraint(equalTo: plusButton.trailingAnchor, constant: 8)
        ]

        let minusButtonConstraints = [
            minusButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            minusButton.leadingAnchor.constraint(equalTo: quantityLabel.trailingAnchor, constant: 8),
            minusButton.widthAnchor.constraint(equalToConstant: 16),
            minusButton.heightAnchor.constraint(equalToConstant: 16)
        ]

        NSLayoutConstraint.activate(plusButtonConstraints)
        NSLayoutConstraint.activate(quantityLabelConstraints)
        NSLayoutConstraint.activate(minusButtonConstraints)
    }
}
