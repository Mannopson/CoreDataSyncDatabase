//
//  LocalNotificationCenter.swift
//  CoreDataSyncDatabase
//
//  Created by AzizOfficial on 7/3/21.
//

import Foundation
import UserNotifications

class LocalNotificationCenter {
    static let shared = LocalNotificationCenter.init()
    private let center = UNUserNotificationCenter.current()
    
    public func request() {
        center.requestAuthorization(options: [.sound, .badge, .alert]) { granted, error in
            
        }
    }
}
