
import UIKit

class StoreItemCollectionViewController: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        let itemSize =
           NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3),
           heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize =
           NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
           heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize:
           groupSize, subitem: item, count: 3)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8,
           bottom: 8, trailing: 8)
        section.interGroupSpacing = 8
       
        collectionView.collectionViewLayout =
           UICollectionViewCompositionalLayout(section: section)
        */
        collectionView.register(StoreItemCollectionViewSectionHeader.self, forSupplementaryViewOfKind: "Header", withReuseIdentifier: StoreItemCollectionViewSectionHeader.reuseIdentifier)
        
    }
    
    func collectionViewLayout(for searchScope: SearchScope) {
        // My solution:
        var groupWidth: CGFloat
        var groupCount: Int
        var scrolling: UICollectionLayoutSectionOrthogonalScrollingBehavior
        
        switch searchScope {
        case .all:
            groupWidth = 1/3
            groupCount = 1
            scrolling = .continuous
        default:
            groupWidth = 1
            groupCount = 3
            scrolling = .none
        }
        
        
        let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.92), heightDimension: .estimated(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: "Header", alignment: .top)
        
        let itemSize =
        NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .absolute(166))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize =
        NSCollectionLayoutSize(widthDimension: .fractionalWidth(groupWidth), heightDimension: .absolute(166))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: groupCount)
        
        let section = NSCollectionLayoutSection(group: group)

        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        section.interGroupSpacing = 8
        section.orthogonalScrollingBehavior = scrolling
        section.boundarySupplementaryItems = [header]
        
    
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        collectionView.collectionViewLayout =
          layout
        
        /* Book's Solution
        let itemSize = NSCollectionLayoutSize(widthDimension:
               .fractionalWidth(1/3), heightDimension:
               .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = .init(top: 8, leading: 5,
               bottom: 8, trailing: 5)
        
            let groupSize = NSCollectionLayoutSize(widthDimension:
               searchScope.groupWidthDimension, heightDimension:
               .absolute(166))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize:
               groupSize, subitem: item, count: searchScope.groupItemCount)
        
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior =
               searchScope.orthogonalScrollingBehavior
        
            let headerSize = NSCollectionLayoutSize(widthDimension:
               .fractionalWidth(1.0), heightDimension: .absolute(28))
            let headerItem =
               NSCollectionLayoutBoundarySupplementaryItem(layoutSize:
               headerSize, elementKind: "Header", alignment: .topLeading)
        
            section.boundarySupplementaryItems = [headerItem]
        
            let layout = UICollectionViewCompositionalLayout(section:
               section)
        
            collectionView.collectionViewLayout = layout
        */
    }
    
}
