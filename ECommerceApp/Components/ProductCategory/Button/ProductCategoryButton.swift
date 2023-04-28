import UIKit

protocol ProductCategoryButtonDelegate: AnyObject {
    func productCategoryButtonDidTap(categoryIndex: Int)
}

final class ProductCategoryButton: UIButton {

    weak var delegate: ProductCategoryButtonDelegate?

    let buttonWidth: CGFloat = 12

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)

        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = Theme.Color.white
        titleLabel?.font = Theme.AppFont.emptyText
        layer.cornerRadius = Theme.CornerRadius.small
        layer.borderColor = Theme.Color.black.cgColor
        layer.borderWidth = 1
        addTarget(
            self,
            action: #selector(productCategoryButtonDidTap),
            for: .touchUpInside
        )
    }

    required init?(coder: NSCoder) {
        fatalError("ProductCategoryButton has not been implemented")
    }

    func configure(model: ProductCategoryButtonModel) {
        setTitle(model.categoryName.capitalized, for: .normal)
        backgroundColor = model.isActiveCategory ? Theme.Color.black : Theme.Color.white
        setTitleColor(model.isActiveCategory ? Theme.Color.white : Theme.Color.black, for: .normal)
        tag = model.categoryIndex

        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: topAnchor),
            bottomAnchor.constraint(equalTo: bottomAnchor),
            widthAnchor.constraint(equalToConstant: CGFloat(model.categoryName.count) * buttonWidth)
        ])
    }
}
// MARK: - Target Methods
extension ProductCategoryButton {

    @objc private func productCategoryButtonDidTap(sender: UIButton) {
        delegate?.productCategoryButtonDidTap(categoryIndex: sender.tag)
    }
}
