
import UIKit

class StoreItemListTableViewController: UITableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // As all the data for our "ListTableViewController", and our "CollectionViewController", is the same, we can write all of our other 'tableView' functions in our 'StoreItemContainerViewController' class, and apply them to both of four "List" and "Collevtion" view contollers
}

