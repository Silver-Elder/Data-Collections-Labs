//
//  BillListTableViewController.swift
//  BillManager
//

import UIKit
import CoreData

private class SwipeableDataSource: UITableViewDiffableDataSource<Int, Bill> {
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
}

class BillListTableViewController: UITableViewController {
    
    fileprivate var dataSource: SwipeableDataSource!

    override func viewDidLoad() {
        super.viewDidLoad()
//        testSetReminder()
        navigationItem.leftBarButtonItem = editButtonItem
        
        dataSource = SwipeableDataSource(tableView: tableView) { tableView, indexPath, bill in
            let cell = tableView.dequeueReusableCell(withIdentifier: "BillCell", for: indexPath)
            
//            let bill = Database.shared.bills[indexPath.row]
            
            var content = cell.defaultContentConfiguration()
            content.text = bill.payee
            content.secondaryText = String(format: "%@ - Due: %@", arguments: [(bill.amountDue ?? 0).formatted(.currency(code: "usd")), bill.formattedDueDate])
            cell.contentConfiguration = content
            
            return cell
        }
        
        tableView.dataSource = dataSource
        
        updateSnapshot()
        
        NotificationCenter.default.addObserver(forName: Database.billUpdatedNotification, object: nil, queue: nil) { _ in
            self.updateSnapshot()
        }
    }
    
    func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Bill>()
        snapshot.appendSections([0])
        snapshot.appendItems(Database.shared.bills, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (contextualAction, view, completionHandler) in
            guard let bill = self.dataSource.itemIdentifier(for: indexPath) else { return }
            Database.shared.delete(bill: bill)
            Database.shared.save()
            self.updateSnapshot()
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash.fill")

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
        
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        performSegue(withIdentifier: "billDetail", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = sender as? IndexPath, segue.identifier == "billDetail" {
            let navigationController = segue.destination as? UINavigationController
            let billDetailTableViewController = navigationController?.viewControllers.first as? BillDetailTableViewController
            billDetailTableViewController?.bill = Database.shared.bills[indexPath.row]
        }
    }
    
    /*
    func testSetReminder() {
        let scheduledBill: (Bill) -> Void = { bill in
            print(bill.remindDate)
            print(bill.notificationID)
            
        }
        let scheduledDate = Date().addingTimeInterval(5)
        var updatedBill = Bill()
        
        updatedBill.removeReminders() // Removes all previous reminders
        
        updatedBill.askForAuthorization { (authorized) in
            guard authorized else {
                DispatchQueue.main.async {
                    scheduledBill(updatedBill)
                }

                return
            }

           let reminderContent = UNMutableNotificationContent()
            reminderContent.title = "Bill Reminder"
            reminderContent.body = String("$\(updatedBill.amountDue?.formatted()) is due to \(updatedBill.payee) on \(updatedBill.dueDate)")
            reminderContent.categoryIdentifier = Bill.notificationCategoryID

            let triggerDateComponents = Calendar.current.dateComponents([.second, .minute, .hour, .day, .month, .year], from: scheduledDate)
            let dateTrigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: false)

            updatedBill.notificationID = UUID().uuidString

            let requestPermissionToShowUpdate = UNNotificationRequest(identifier: updatedBill.notificationID!, content: reminderContent, trigger: dateTrigger)

            UNUserNotificationCenter.current().add(requestPermissionToShowUpdate) { (error: Error?) in
                DispatchQueue.main.async {
                    if let error = error {
                        print(error.localizedDescription)
                        scheduledBill(updatedBill)
                    } else {
                        updatedBill.remindDate = scheduledDate
                        scheduledBill(updatedBill)
                    }
                }
            }
        }
        
    }
     */
    
    @IBAction func unwindFromBillDetail(segue: UIStoryboardSegue) { }
}
