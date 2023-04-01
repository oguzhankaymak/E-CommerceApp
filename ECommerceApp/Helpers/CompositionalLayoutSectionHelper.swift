import UIKit

class CompositionalLayoutSectionHelper {
    static func createProductCategoriesSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(60),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(60), heightDimension: .absolute(40))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging

        let topHeaderSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.4)
        )

        let topHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: topHeaderSize,
            elementKind: ProductCollectionReusableHeaderView.kind,
            alignment: .top)

        let sectionHeaderItemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(60)
        )

        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: sectionHeaderItemSize,
            elementKind: CollectionSectionHeaderView.kind,
            alignment: .topLeading)

        section.boundarySupplementaryItems = [topHeader, sectionHeader]

        return section
    }
}
