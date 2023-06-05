import UIKit

final class Theme {
    enum CornerRadius {
        static let extraSmall: CGFloat = 4
        static let skeleton: CGFloat = 5
        static let special: CGFloat = 7
        static let small: CGFloat = 8
        static let normal: CGFloat = 12
        static let large: CGFloat = 18
        static let extraLarge: CGFloat = 25
    }
}

// MARK: - Color
extension Theme {
    enum Color {
        static let black: UIColor = .black
        static let white: UIColor = .white
        static let backgroundColor: UIColor = .systemBackground
        static let antiFlashWhite: UIColor = UIColor.rgba(red: 241, green: 244, blue: 247, alpha: 1)
        static let starColor: UIColor = UIColor.rgba(red: 234, green: 154, blue: 58, alpha: 1)
        static let gray: UIColor = .gray
        static let darkGrey = UIColor.rgba(red: 239, green: 241, blue: 241, alpha: 1)
        static let lightGrey = UIColor.rgba(red: 201, green: 201, blue: 201, alpha: 1)
        static let secondaryBlack = UIColor.rgba(red: 0, green: 0, blue: 0, alpha: 0.8)
        static let textFieldBackgroundColor: UIColor = .secondarySystemFill
        static let label: UIColor = .label
    }

    enum BorderColor {
        static let gray: CGColor = UIColor.gray.cgColor
    }
}

// MARK: - Font
extension Theme {
    enum AppFont {
        static let sectionTitle = Font.systemFont(size: FontSize.large, weight: FontWeight.bold)
        static let title = Font.systemFont(size: FontSize.large, weight: FontWeight.bold)
        static let productInfo = Font.systemFont(size: FontSize.normal, weight: FontWeight.semiBold)
        static let productCardTitle = Font.systemFont(size: FontSize.small, weight: FontWeight.semiBold)
        static let productCardDescription = Font.systemFont(size: FontSize.small, weight: FontWeight.regular)
        static let productCardPrice = Font.systemFont(size: FontSize.small, weight: FontWeight.bold)
        static let productRating = Font.systemFont(size: FontSize.extraSmall, weight: FontWeight.regular)
        static let italicSmall = Font.systemItalicFont(size: FontSize.small)
        static let emptyText = Font.systemFont(size: FontSize.normal, weight: FontWeight.regular)
    }

    private enum Font {
        static func systemFont(size: CGFloat, weight: UIFont.Weight) -> UIFont {
            return UIFont.systemFont(ofSize: size, weight: weight)
        }

        static func systemItalicFont(size: CGFloat) -> UIFont {
            return UIFont.italicSystemFont(ofSize: size)
        }
    }

    private enum FontSize {
        static let large: CGFloat = 22
        static let description: CGFloat = 17
        static let normal: CGFloat = 14
        static let small: CGFloat = 12
        static let extraSmall: CGFloat = 10
    }

    private enum FontWeight {
        static let bold = UIFont.Weight.bold
        static let semiBold = UIFont.Weight.semibold
        static let regular = UIFont.Weight.regular
        static let light = UIFont.Weight.light
    }
}
