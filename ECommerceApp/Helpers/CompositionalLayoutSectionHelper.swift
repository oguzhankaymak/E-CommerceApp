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

        let sectionHeaderItemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(60)
        )

        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: sectionHeaderItemSize,
            elementKind: CollectionSectionHeaderView.kind,
            alignment: .topLeading)

        section.boundarySupplementaryItems = [header]

        return section
    }
}
