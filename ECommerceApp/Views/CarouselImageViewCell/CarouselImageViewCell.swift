import UIKit

class CarouselImageViewCell: UICollectionViewCell {

    static let identifier = "carousel-image-cell"

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addUIElements()
        configureConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("CarouselImageViewCell has not been implemented")
    }
}

// MARK: - Configure Model
extension CarouselImageViewCell {

    func configureModel(with imageUrl: String) {

        guard let imageURL = URL(string: imageUrl) else { return }
        imageView.sd_setImage(with: imageURL)
    }
}

// MARK: - Constraints
extension CarouselImageViewCell {

    private func addUIElements() {
        contentView.addSubview(imageView)
    }

    private func configureConstraints() {
        let imageViewConstraints = [
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]

        NSLayoutConstraint.activate(imageViewConstraints)
    }
}
