import UIKit

class CollectionSectionHeaderView: UICollectionReusableView {
    static let kind = "sectionHeader"
    static let identifier = "sectionHeader"

    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var titleLabel: UILabel =  {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addUIElements()
        configureConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("CollectionSectionHeaderView has not been implemented")
    }
}

// MARK: - Configure Model
extension CollectionSectionHeaderView {
    func configureModel(with title: String) {
        titleLabel.text = title
    }
}

// MARK: - Constraints
extension CollectionSectionHeaderView {
    private func addUIElements() {
        addSubview(containerView)
        containerView.addSubview(titleLabel)
    }

    private func configureConstraints() {

        let containerViewConstraints = [
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]

        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ]

        NSLayoutConstraint.activate(containerViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
    }
}
