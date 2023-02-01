//
//  MenuTableViewController.swift
//  Restaurant
//
//  Created by Sterling Jenkins on 12/8/22.
//

import UIKit

class MenuTableViewController: UITableViewController {
    
    
    
    init?(coder: NSCoder, category: String) {
        self.category = category
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var category: String = ""
    var menuItems = [MenuItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if menuItems.isEmpty {
            Task {
                do {
                    menuItems = try await APIController().fetchMenu(filterBy: category)
                    tableView.reloadData()
                } catch {
                    print(error)
                }
            }
        }
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return menuItems.count > 0 ? menuItems.count : 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Menu Item", for: indexPath) as! MenuTableViewCell
        
        if !menuItems.isEmpty {
            let menuItem = menuItems[indexPath.row]
            
            cell.menuItemTitle.text = menuItem.title
            cell.menuItemDescription.text = menuItem.price.formatted(.currency(code: "usd"))
            
            Task {
                do {
                    let photo = try await APIController().fetchPhoto(from: menuItem.image)
                    cell.menuPhoto.image = photo
                } catch {
                    print(error)
                }
            }
        } else {
            cell.menuItemTitle.text = "More to come!"
            cell.menuItemDescription.text = ""
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if !menuItems.isEmpty {
//            YourOrderTableViewController().orders.append(menuItems[indexPath.row])
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
