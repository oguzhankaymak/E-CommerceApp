import UIKit

class CollectionSectionHeaderView: UICollectionReusableView {

    static let kind = "sectionHeader"
    static let identifier = "sectionHeader"

    lazy var titleLabel: UILabel =  {
        let label = UILabel()
        label.font = Theme.AppFont.sectionTitle
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

// MARK: - Configure
extension CollectionSectionHeaderView {
    func configureModel(with title: String) {
        titleLabel.text = title
    }
}

// MARK: - Constraints
extension CollectionSectionHeaderView {
    private func addUIElements() {
        addSubview(titleLabel)
    }

    private func configureConstraints() {

        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ]

        NSLayoutConstraint.activate(titleLabelConstraints)
    }
}
