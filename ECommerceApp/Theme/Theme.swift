import UIKit

final class Theme {
    enum CornerRadius {
        static let small: CGFloat = 8
        static let normal: CGFloat = 12
        static let large: CGFloat = 18
        static let extraLarge: CGFloat = 40
    }
}

// MARK: - Color
extension Theme {
    enum Color {
        static let black: UIColor = .black
        static let white: UIColor = .white
        static let backgroundColor: UIColor = .systemBackground
    }

    enum BorderColor {
        static let gray: CGColor = UIColor.gray.cgColor
    }
}

// MARK: - Font
extension Theme {
    enum AppFont {
        static let extraLargetitle = Font.systemFont(size: FontSize.extraLarge, weight: FontWeight.bold)
        static let title = Font.systemFont(size: FontSize.large, weight: FontWeight.bold)
        static let descriptionOnboarding = Font.systemItalicFont(size: FontSize.description)
        static let segmentedControlTitle = Font.systemFont(size: FontSize.normal, weight: FontWeight.regular)
        static let navigationBarItalic = Font.systemItalicFont(size: FontSize.navigationItem)
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
        static let extraLarge: CGFloat = 75
        static let large: CGFloat = 25
        static let navigationItem: CGFloat = 20
        static let description: CGFloat = 17
        static let normal: CGFloat = 14
        static let small: CGFloat = 12
    }

    private enum FontWeight {
        static let bold = UIFont.Weight.bold
        static let regular = UIFont.Weight.regular
        static let light = UIFont.Weight.light
    }
}
