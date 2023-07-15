import UIKit

class SuccessViewController: UIViewController {

    var coordinator: SuccessCoordinatorProtocol?
    var buttonDidTap: (() -> Void)!
    var buttonName: String!

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Thank you! Your order has been successfully received."
        label.font = Theme.AppFont.productCardPrice
        label.textColor = Theme.Color.gray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var imageView: UIImageView = {
        let image = UIImage(
            systemName: "hand.thumbsup.circle",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 100,
                weight: .medium)
        )

        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Your order number is #123456789. An order confirmation has been sent to your email."
        label.font = Theme.AppFont.productCardPrice
        label.textColor = Theme.Color.gray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var mainButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 8
        button.backgroundColor = Theme.Color.black
        button.setTitle(buttonName, for: .normal)
        button.setTitleColor(Theme.Color.white, for: .normal)
        button.addTarget(self, action: #selector(mainButtonDidTap), for: .touchUpInside)
        button.accessibilityIdentifier = "main_button"
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.Color.backgroundColor
        addUIElements()
        configureConstraints()
    }

    @objc func mainButtonDidTap() {
        buttonDidTap()
    }
}

// MARK: - Constraints
extension SuccessViewController {
    private func addUIElements() {
        view.addSubview(titleLabel)
        view.addSubview(imageView)
        view.addSubview(infoLabel)
        view.addSubview(mainButton)
    }

    private func configureConstraints() {

        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ]

        let imageViewConstraints = [
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20)
        ]

        let infoLabelConstraints = [
            infoLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 60),
            infoLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            infoLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ]

        let mainButtonConstraints = [
            mainButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            mainButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainButton.widthAnchor.constraint(equalToConstant: view.frame.width / 1.1),
            mainButton.heightAnchor.constraint(equalToConstant: 50)
        ]

        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(imageViewConstraints)
        NSLayoutConstraint.activate(infoLabelConstraints)
        NSLayoutConstraint.activate(mainButtonConstraints)
    }
}
