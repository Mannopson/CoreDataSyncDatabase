//
//  Notification.swift
//  CoreDataSyncDatabase
//
//  Created by AzizOfficial on 6/19/21.
//

import Foundation
import UserNotifications

class Notification {
    
    static let shared = Notification.init()
    
    public func setNotification(title: String) {
        let content = UNMutableNotificationContent.init()
        content.title = title
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "SINGLE_ACTION_CATEGORY"
        
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 10.0, repeats: false)
        let request = UNNotificationRequest.init(identifier: UUID.init().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
