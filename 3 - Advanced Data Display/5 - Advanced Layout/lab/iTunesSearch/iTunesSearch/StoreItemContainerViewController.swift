
import UIKit

// For next lab, see p.702

class StoreItemContainerViewController: UIViewController, UISearchResultsUpdating {
    
    @IBOutlet var tableContainerView: UIView!
    @IBOutlet var collectionContainerView: UIView!
    
    let searchController = UISearchController() // Note; this is also set to display it's segmented control when selected – which is what the user will use to select their search result media type
    let storeItemController = StoreItemController()
    
//    var items = [StoreItem]()
    
    var selectedSearchScope: SearchScope {
        let selectedIndex = searchController.searchBar.selectedScopeButtonIndex
        let searchScope = SearchScope.allCases[selectedIndex]
        
        return searchScope
    }
    
    
    // keep track of async tasks so they can be cancelled if appropriate.
    var searchTask: Task<Void, Never>? = nil // This web search 'Task' (used in "fetchMatchingItems()" below), will be cancelled if the user edits the searchController before the web search 'Task' is complete, as the value of this 'Task' variable will be replaced with whatever new value is assigned to it when "fetchMatchingItems()" is run.
    // However, since we don't want a new network request to be made with every new keystroke change the user makes to our searchController, two new methods were added to the "updateSearchResult(for:)" method (a.k.a. function): "cancelPreviousPerformRequests(withTarget:selector:object:) and perform(_:with:afterDelay:). With every keystroke, you queue up a new request and cancel previous ones—until the user stops typing for 0.3 seconds. Debouncing is a common technique for search controls that interact with a web service" (Develop in Swift Data Collections – Itunes Search Lab, p.626).
    var tableViewImageLoadTasks: [IndexPath: Task<Void, Never>] = [:]
    var collectionViewImageLoadTasks: [IndexPath: Task<Void, Never>] = [:]
    
    var itemsSnapshot = NSDiffableDataSourceSnapshot<String, StoreItem>()
//    var itemsSnapshot: NSDiffableDataSourceSnapshot<String, StoreItem> {
//        var snapshot = NSDiffableDataSourceSnapshot<String, StoreItem>()
//
//        snapshot.appendSections(["Results"])
//        snapshot.appendItems(items)
//
//        return snapshot
//    }
    
    
    var tableViewDataSource: UITableViewDiffableDataSource<String, StoreItem>!
    var collectionViewDataSource: UICollectionViewDiffableDataSource<String, StoreItem>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.automaticallyShowsSearchResultsController = true
        searchController.searchBar.showsScopeBar = true
        searchController.searchBar.scopeButtonTitles = SearchScope.allCases.map { $0.title }
    }
    
    func configureTableViewDataSource(_ tableView: UITableView) {
        tableViewDataSource = StoreItemTableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath) as! ItemTableViewCell
            
            self.tableViewImageLoadTasks[indexPath]?.cancel()
            self.tableViewImageLoadTasks[indexPath] = Task {
                /*
                cell.titleLabel.text = itemIdentifier.name
                cell.detailLabel.text = itemIdentifier.artist
                cell.itemImageView.image = UIImage(systemName: "photo")
                do {
                    let image = try await
                    self.storeItemController.fetchImage(from: itemIdentifier.artworkURL)
                    
                    cell.itemImageView.image = image
                } catch let error as NSError where error.domain ==
                            NSURLErrorDomain && error.code == NSURLErrorCancelled {
                    // Ignore cancellation errors
                } catch {
                    
                    print("Error fetching image: \(error)")
                }
                 */
                await cell.configure(for: itemIdentifier, storeItemController: self.storeItemController)
                
                self.tableViewImageLoadTasks[indexPath] = nil
            }
            
            return cell
        })
    }
    
    func configureCollectionViewDataSource(_ collectionView: UICollectionView) {
        collectionViewDataSource = UICollectionViewDiffableDataSource<String, StoreItem>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Item", for: indexPath) as! ItemCollectionViewCell
            
            self.collectionViewImageLoadTasks[indexPath]?.cancel()
            self.collectionViewImageLoadTasks[indexPath] = Task {
                /*
                cell.titleLabel.text = itemIdentifier.name
                cell.detailLabel.text = itemIdentifier.artist
                cell.itemImageView.image = UIImage(systemName: "photo")
                do {
                    let image = try await
                    self.storeItemController.fetchImage(from: itemIdentifier.artworkURL)
                    
                    cell.itemImageView.image = image
                } catch let error as NSError where error.domain ==
                            NSURLErrorDomain && error.code == NSURLErrorCancelled {
                    // Ignore cancellation errors
                } catch {
                    
                    print("Error fetching image: \(error)")
                }
                 */
                await cell.configure(for: itemIdentifier, storeItemController: self.storeItemController)
                
                self.collectionViewImageLoadTasks[indexPath] = nil
            }
            
            return cell
        })
        
        collectionViewDataSource.supplementaryViewProvider = {
            collectionView, kind, indexPath -> UICollectionReusableView? in
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: "Header", withReuseIdentifier: StoreItemCollectionViewSectionHeader.reuseIdentifier, for: indexPath) as! StoreItemCollectionViewSectionHeader
            
            let title = self.itemsSnapshot.sectionIdentifiers[indexPath.section]
            headerView.setTitle(title)
            
            return headerView
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(fetchMatchingItems), object: nil)
        perform(#selector(fetchMatchingItems), with: nil, afterDelay: 0.3)
    }
    
    @IBAction func switchContainerView(_ sender: UISegmentedControl) {
        tableContainerView.isHidden.toggle()
        collectionContainerView.isHidden.toggle()
    }
    
    func createSectionedSourceSnapshot(from items: [StoreItem]) -> NSDiffableDataSourceSnapshot<String, StoreItem> {
        var sectionSnapshot = NSDiffableDataSourceSnapshot<String, StoreItem>()
        // My Solution:
        sectionSnapshot.appendSections(["Movie", "Music", "App", "Book"])
        
        for item in items {
            switch item.kind {
            case "feature-movie":
                sectionSnapshot.appendItems([item], toSection: "Movie")
            case "song", "album":
                sectionSnapshot.appendItems([item], toSection: "Music")
            case "software":
                sectionSnapshot.appendItems([item], toSection: "App")
            case "ebook":
                sectionSnapshot.appendItems([item], toSection: "Book")
            default:
                continue
            }
        }
        
        for section in sectionSnapshot.sectionIdentifiers {
            if sectionSnapshot.numberOfItems(inSection: section) == 0 {
                sectionSnapshot.deleteSections([section])
            }
        }
        
        return sectionSnapshot
        
        /*
        //The Book's Solution:
        
        let movies = items.filter { $0.kind == "feature-movie" }
            let music = items.filter { $0.kind == "song" || $0.kind == "album" }
            let apps = items.filter { $0.kind == "software" }
            let books = items.filter { $0.kind == "ebook" }
        
            let grouped: [(SearchScope, [StoreItem])] = [
                (.movies, movies),
                (.music, music),
                (.apps, apps),
                (.books, books)
            ]
        
            var snapshot = NSDiffableDataSourceSnapshot<String, StoreItem>()
            grouped.forEach { (scope, items) in
                if items.count > 0 {
                    snapshot.appendSections([scope.title])
                    snapshot.appendItems(items, toSection: scope.title)
                }
            }
        
            return snapshot
         */
    }
    
    func handleFetchedItems(_ items: [StoreItem]) async {
        let currentSnapshotItems = itemsSnapshot.itemIdentifiers
//        var updatedSnapshot = NSDiffableDataSourceSnapshot<String,
//           StoreItem>()
//        updatedSnapshot.appendSections(["Results"])
//        updatedSnapshot.appendItems(currentSnapshotItems + items)
        let updatedSnapshot = createSectionedSourceSnapshot(from: currentSnapshotItems + items)
        itemsSnapshot = updatedSnapshot
        
        collectionViewController?.collectionViewLayout(for: selectedSearchScope)
        
        await tableViewDataSource.apply(itemsSnapshot, animatingDifferences: true)
        await collectionViewDataSource.apply(itemsSnapshot, animatingDifferences: true)
    }
    
    func fetchAndHandleItemsForSearchScope(_ searchScopes: [SearchScope], withSearchTerm searchTerm: String) async throws {
        try await withThrowingTaskGroup(of: (SearchScope, [StoreItem]).self) { group in
            for searchScope in searchScopes { group.addTask {
                try Task.checkCancellation()
                // Set up query dictionary​ 
                let query = ["term": searchTerm,
                             "media": searchScope.mediaType,
                             "lang": "en_us",
                             "limit": "50"  ]
                return (searchScope, try await                self.storeItemController.fetchItems(matching: query))
                }
            }
            for try await (searchScope, items) in group {
                try Task.checkCancellation()
                if searchTerm == self.searchController.searchBar.text && (self.selectedSearchScope == .all || self.selectedSearchScope == searchScope) {
                    await handleFetchedItems(items)
                }
            }
        }
    }
    
    @objc func fetchMatchingItems() {
        
//        self.items = []
        itemsSnapshot.deleteAllItems()
        
        let searchTerm = searchController.searchBar.text ?? ""
//        let mediaType = selectedSearchScope.mediaType
       
        let searchScopes: [SearchScope]
        if selectedSearchScope == .all {
            searchScopes = [.movies, .music, .apps, .books]
        } else {
            searchScopes = [selectedSearchScope]
        }
        
        // cancel existing task since we will not use the result
        searchTask?.cancel()
        searchTask = Task {
            if !searchTerm.isEmpty {
                
//                // set up query dictionary
//                let query = [
//                    "term": searchTerm,
//                    "media": mediaType,
//                    "lang": "en_us",
//                    "limit": "20"
//                ]
                
                // use the item controller to fetch items
                do {
//                    // use the item controller to fetch items
//                    let items = try await storeItemController.fetchItems(matching: query)
//                    if searchTerm == self.searchController.searchBar.text &&
//                        query["media"] == mediaType {
////                        self.items = items
//                    }
                    
                    try await fetchAndHandleItemsForSearchScope(searchScopes, withSearchTerm: searchTerm)
                    
                } catch let error as NSError where error.domain == NSURLErrorDomain && error.code == NSURLErrorCancelled {
                    // ignore cancellation errors
                } catch {
                    // otherwise, print an error to the console
                    print(error)
                }
                // apply data source changes
                await tableViewDataSource.apply(itemsSnapshot, animatingDifferences: true)
                await collectionViewDataSource.apply(itemsSnapshot, animatingDifferences: true)
            } else {
                // apply data source changes
                await tableViewDataSource.apply(itemsSnapshot, animatingDifferences: true)
                await collectionViewDataSource.apply(itemsSnapshot, animatingDifferences: true)
            }
            
            // Cancel any images that are still being fetched and reset the imageTask dictionaries​ 
            collectionViewImageLoadTasks.values.forEach { task in task.cancel() }
            collectionViewImageLoadTasks = [:]
            tableViewImageLoadTasks.values.forEach { task in task.cancel() }
            tableViewImageLoadTasks = [:]
            
            searchTask = nil
        }
    }
    
    weak var collectionViewController: StoreItemCollectionViewController?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tableViewController = segue.destination as?
               StoreItemListTableViewController {
                configureTableViewDataSource(tableViewController.tableView)
            }
        
        if let collectionViewController = segue.destination as?
               StoreItemCollectionViewController {
            collectionViewController.collectionViewLayout(for: selectedSearchScope)
            configureCollectionViewDataSource(collectionViewController.collectionView)
            
            self.collectionViewController = collectionViewController
            }
    }

}
