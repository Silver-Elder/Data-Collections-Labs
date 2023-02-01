// BillManager

import Foundation
import UserNotifications // You need to add this for your app to be able to read the user's notification settings

struct Bill: Codable {
    let id: UUID
    var amountDue: Double?
    var dueDate: Date?
    var paidDate: Date?
    var payee: String?
    var remindDate: Date?
    var notificationID: String?
    
    init(id: UUID = UUID()) {
        self.id = id
    }
}

extension Bill: Hashable {
    static let notificationCategoryID: String = "Notification"
    static let markAsPaid: String = "Bill has been paid"
    static let remindActionID: String = "Reminder"
    
    static func ==(_ lhs: Bill, _ rhs: Bill) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
   mutating func sheduleReminder(for scheduledDate: Date, scheduledBill: @escaping (Bill) -> ()) {
        var updatedBill = self
        
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

            let triggerDateComponents = Calendar.current.dateComponents([.minute, .hour, .day, .month, .year], from: scheduledDate)
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
    
   mutating func removeReminders() {
        
       if let notificationID = notificationID {
           UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationID])
       }
       
       notificationID = nil
       remindDate = nil
    }
    
private func askForAuthorization(hasAuthorization: @escaping (Bool) -> ()) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { (settings) in
            switch settings.authorizationStatus {
            case .authorized:
                hasAuthorization(true)
                
            case .notDetermined:
                notificationCenter.requestAuthorization(options: [.alert, .sound], completionHandler: { (granted, _) in
                    hasAuthorization(granted)
                })
                
            case .denied, .provisional, .ephemeral:
                hasAuthorization(false)
            @unknown default:
                hasAuthorization(false)
            }
        }
    }
}
