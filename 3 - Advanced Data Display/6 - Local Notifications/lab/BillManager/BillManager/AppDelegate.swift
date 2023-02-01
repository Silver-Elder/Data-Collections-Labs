//
//  AppDelegate.swift
//  BillManager
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let usersNotificationCenter = UNUserNotificationCenter.current()
        
        let remindToPayAction = UNNotificationAction(identifier: Bill.remindActionID, title: "Pay Bill")
        let markAsPaidAction = UNNotificationAction(identifier: Bill.markAsPaid, title: "Mark as paid", options: [.authenticationRequired])
        
        let alarmCategory = UNNotificationCategory(identifier: Bill.notificationCategoryID, actions: [remindToPayAction, markAsPaidAction], intentIdentifiers: [])
        
        usersNotificationCenter.setNotificationCategories([alarmCategory])
        usersNotificationCenter.delegate = self
        
        
        return true
    }
        
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let notificaitonID = response.notification.request.identifier
        
        if var bill = Database().getBill(forNotificationID: notificaitonID) {
            if let dueDate = bill.dueDate {
                bill.sheduleReminder(for: dueDate, scheduledBill: { bill in
                    if bill.dueDate == nil {
                        print("Can't schedule bill because notification permissions were revoked.")
                    }
                })
            }
        }
        
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            completionHandler([.list, .banner, .sound])
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

