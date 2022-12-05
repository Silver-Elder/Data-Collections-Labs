
import UIKit

@MainActor
class StoreItemListTableViewController: UITableViewController {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var filterSegmentedControl: UISegmentedControl!
    
    // add item controller property
    
    var items = [StoreItem]()
    var imageLoadTasks: [IndexPath: Task<Void, Never>] = [:]
    let storeItemController = StoreItemController()
    
    let queryOptions = ["movie", "music", "software", "ebook"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func fetchMatchingItems() {
        
        self.items = []
        self.tableView.reloadData()
        
        let searchTerm = searchBar.text ?? ""
        let mediaType = queryOptions[filterSegmentedControl.selectedSegmentIndex]
        
        if !searchTerm.isEmpty {
            
            let queryDictionary = ["media": mediaType, "term": searchTerm, "lang": "en_us", "limit": "15"]
            
            Task {
                do {
                    self.items = try await storeItemController.fetchItems(matching: queryDictionary)
                    tableView.reloadData()
                } catch {
                    print(error)
                }
            }
            // if successful, use the main queue to set self.items and reload the table view
            // otherwise, print an error to the console
        }
    }
    
    func configure(cell: ItemCell, forItemAt indexPath: IndexPath) {
        
        let item = items[indexPath.row]
        
        cell.name = item.trackName
        
        cell.artist = item.artistName
        
        // Book Prompt: Initialize a network task to fetch the item's artwork keeping track of the task in imageLoadTasks so they can be cancelled if the cell will not be shown after the task completes.
        
        // if successful, set the cell.artworkImage using the returned image
        
        imageLoadTasks[indexPath] = Task { // This sets my imageLoadTasks value, although I don't understand what it's doing
            do {
                cell.artworkImage = try await storeItemController.fetchImage(from: item.artworkURL)
                imageLoadTasks[indexPath] = nil
                // Once this task is complete, this line of code removes it from the list of pending tasks
            } catch {
                cell.artworkImage = nil
            }
        }
        
        
    }
    
    @IBAction func filterOptionUpdated(_ sender: UISegmentedControl) {
        
        fetchMatchingItems()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath) as! ItemCell
        configure(cell: cell, forItemAt: indexPath)

        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // cancel the image fetching task if we no longer need it
        imageLoadTasks[indexPath]?.cancel()
    }
}

extension StoreItemListTableViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        fetchMatchingItems()
        searchBar.resignFirstResponder()
    }
}

// Pick up on p.452 (Though you may have already completed those tasks, or done the same work sifferently than the book would've. Review the page to learn how they comleted this step)
