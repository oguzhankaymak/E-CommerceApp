import UIKit

final class EmptyDataIconView: UIView {

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Theme.AppFont.productInfo
        label.textColor = Theme.Color.lightGrey
        return label
    }()

    // MARK: - Init
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        addUIElements()
        configureConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("EmptyDataIconView has not been implemented")
    }
}

// MARK: - Configure
extension EmptyDataIconView {
    func configure(model: EmptyDataIconViewModel) {
        let image = UIImage(
            systemName: model.imageKey,
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 24)
        )?.withTintColor(Theme.Color.lightGrey, renderingMode: .alwaysOriginal)

        imageView.image = image
        titleLabel.text = model.title
    }
}

// MARK: - Constraints
extension EmptyDataIconView {
    private func addUIElements() {
        addSubview(imageView)
        addSubview(titleLabel)
    }

    private func configureConstraints() {

        let imageViewConstraints = [
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -20),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ]

        let titleLabelConstrains = [
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ]

        NSLayoutConstraint.activate(imageViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstrains)
    }
}
