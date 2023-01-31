
import UIKit

// “orthogonally: to scroll at a 90-degree angle to the layout's scrolling direction”

class ViewController: UIViewController {
        
    // MARK: Supplementary Views
    enum SupplementaryViewKind {
        static let header = "header"
        static let topLine = "topLine"
        static let bottomLine = "bottomLine"
    }
    
    // MARK: Section Definitions
    enum Section: Hashable {
        case promoted
        case standard(String)
        case categories
    }

    @IBOutlet var collectionView: UICollectionView!
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    var sections = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Collection View Setup
        collectionView.collectionViewLayout = createLayout()
        
        collectionView.register(PromotedAppCollectionViewCell.self, forCellWithReuseIdentifier: PromotedAppCollectionViewCell.reuseIdentifier)
        collectionView.register(StandardAppCollectionViewCell.self, forCellWithReuseIdentifier: StandardAppCollectionViewCell.reuseIdentifier)
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.reuseIdentifier)
        
        collectionView.register(SectionHeaderView.self,
           forSupplementaryViewOfKind: SupplementaryViewKind.header,
           withReuseIdentifier: SectionHeaderView.reuseIdentifier)
        collectionView.register(LineView.self, forSupplementaryViewOfKind:
           SupplementaryViewKind.topLine, withReuseIdentifier:
           LineView.reuseIdentifier)
        collectionView.register(LineView.self, forSupplementaryViewOfKind:
           SupplementaryViewKind.bottomLine, withReuseIdentifier:
           LineView.reuseIdentifier)
            // "Note: "the types that implement your supplementary views don't have to correspond one-to-one with the registered kinds of supplementary views" (Develop in Swift Data Collections - AppStoreLayout, p.689).
                
        configureDataSource()
    }
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout
               { (sectionIndex, layoutEnvironment) ->
               NSCollectionLayoutSection? in
                   
               // let supplementaryItemContentInsets =  NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4) // Change this to make the line look better
               let supplementaryItemContentInsets =  NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)
                   
               let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.92), heightDimension: .estimated(44))
                let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: SupplementaryViewKind.header, alignment: .top)
//               headerItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)
               headerItem.contentInsets = supplementaryItemContentInsets
                   
               let lineItemHeight = 1 /
                  layoutEnvironment.traitCollection.displayScale
               let lineItemSize =
                  NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.92),
                  heightDimension: .absolute(lineItemHeight))
                   
               let topLineItem =
                  NSCollectionLayoutBoundarySupplementaryItem(layoutSize:
                  lineItemSize, elementKind: SupplementaryViewKind.topLine,
                  alignment: .top)
               topLineItem.contentInsets = supplementaryItemContentInsets
               
               let bottomLineItem =
                  NSCollectionLayoutBoundarySupplementaryItem(layoutSize:
                  lineItemSize, elementKind: SupplementaryViewKind.bottomLine,
                  alignment: .bottom)
               bottomLineItem.contentInsets = supplementaryItemContentInsets
                   
                   let section = self.sections[sectionIndex]
                   switch section {
                   case .promoted:
                       // MARK: Promoted Section Layout
                       let itemSize =
                       NSCollectionLayoutSize(widthDimension:
                            .fractionalWidth(1), heightDimension: .fractionalWidth(1))
                       let item = NSCollectionLayoutItem(layoutSize: itemSize)
                       item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)
                       
                       
                       let groupSize =
                       NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.92), heightDimension: .estimated(300))
                       let group =
                       NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                       
                       let section = NSCollectionLayoutSection(group: group)
                       section.orthogonalScrollingBehavior = .groupPagingCentered
                       section.boundarySupplementaryItems = [topLineItem, bottomLineItem]
                       section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0)
                       
                       return section
                   case .standard:
                       
                       
                       // Mark: Standard Section Layout
                       let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/3))
                       let item = NSCollectionLayoutItem(layoutSize: itemSize)
                       item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)
                       
                       let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.92), heightDimension: .estimated(250))
                       let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 3)
                       
                       let section = NSCollectionLayoutSection(group: group)
                       section.orthogonalScrollingBehavior = .groupPagingCentered
                       section.boundarySupplementaryItems = [headerItem, bottomLineItem]
                       section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0)
                       
                       return section
                   case .categories:
                       // MARK: Categories Section Layout
                       let itemSize =
                       NSCollectionLayoutSize(widthDimension:
                            .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                       let item = NSCollectionLayoutItem(layoutSize: itemSize)
                       
                       let availableLayoutWidth =
                          layoutEnvironment.container.effectiveContentSize.width
                       let upperGroupsWidth = availableLayoutWidth * 0.92
                       let remainingWidth = availableLayoutWidth - upperGroupsWidth
                       let halfOfRemainingWidth = remainingWidth / 2.0
                       let nonCategorySectionItemInset = CGFloat(4)
                       let itemLeadingAndTrailingInset = halfOfRemainingWidth +
                          nonCategorySectionItemInset
                       
                       item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: itemLeadingAndTrailingInset, bottom: 0, trailing: itemLeadingAndTrailingInset)
                       
                       let groupSize =
                       NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44))
                       let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                       
                       let section = NSCollectionLayoutSection(group: group)
                       section.boundarySupplementaryItems = [headerItem]
                       
                       return section
                   }
            }
            return layout
    }
    
    func configureDataSource() {
        // MARK: Data Source Initialization
        dataSource = .init(collectionView: collectionView, cellProvider: {
           (collectionView, indexPath, item) -> UICollectionViewCell? in
            let section = self.sections[indexPath.section]
            switch section {
            case .promoted:
                let cell =
                collectionView.dequeueReusableCell(withReuseIdentifier: PromotedAppCollectionViewCell.reuseIdentifier, for: indexPath) as! PromotedAppCollectionViewCell
                cell.configureCell(item.app!)
                
                return cell
            case .standard:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StandardAppCollectionViewCell.reuseIdentifier, for: indexPath) as! StandardAppCollectionViewCell
                
                let isThirdItem = (indexPath.row + 1).isMultiple(of: 3)
                cell.configureCell(item.app!, hideBottomLine: isThirdItem)
                
                return cell
            case .categories:
                let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.reuseIdentifier, for: indexPath) as! CategoryCollectionViewCell
                
                let isLastItem = collectionView.numberOfItems(inSection: indexPath.section) == indexPath.row + 1
                cell.configureCell(item.category!, hideBottomLine: isLastItem)
                
                return cell
            }
        })
        
        // MARK: Snapshot Definition
            //Note: “By using the 'MARK' comment, you'll be able to quickly jump to this definition later using either the jump bar or the minimap. 'MARK' comments are a useful navigation tool for more complex projects, and you'll be using them throughout this lesson."
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.promoted])
        snapshot.appendItems(Item.promotedApps, toSection: .promoted)
        
        let popularSection = Section.standard("Popular this week")
        let essentialSection = Section.standard("Essential picks")
        snapshot.appendSections([popularSection, essentialSection])
        snapshot.appendItems(Item.popularApps, toSection: popularSection)
        snapshot.appendItems(Item.essentialApps, toSection: essentialSection)
        
        snapshot.appendSections([.categories])
        snapshot.appendItems(Item.categories, toSection: .categories)
        
        sections = snapshot.sectionIdentifiers
        dataSource.apply(snapshot)
        
        // MARK: Supplementary View Provider
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath -> UICollectionReusableView? in
            switch kind {
            case SupplementaryViewKind.header:
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: SupplementaryViewKind.header, withReuseIdentifier: SectionHeaderView.reuseIdentifier, for: indexPath) as! SectionHeaderView
                
                let section = self.sections[indexPath.section]
                let sectionName: String
                switch section {
                case .promoted:
                    return nil
                case .standard(let name):
                    sectionName = name
                case .categories:
                    sectionName = "Top Categories"
                }
                
                headerView.setTitle(sectionName)
        
                return headerView
        
            case SupplementaryViewKind.topLine, SupplementaryViewKind.bottomLine:
                let lineView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LineView.reuseIdentifier, for: indexPath) as! LineView
                return lineView
        
            default:
                return nil
            }
        }
    }
}

