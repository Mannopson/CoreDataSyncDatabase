//
//  NotificationViewController.swift
//  NotificationContent
//
//  Created by AzizOfficial on 7/9/21.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var label: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        self.label?.text = notification.request.content.body
    }
    
    func didReceive(_ response: UNNotificationResponse, completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {
        if response.notification.request.content.categoryIdentifier == "SINGLE_ACTION_CATEGORY", response.actionIdentifier == "done_id" {
            DispatchQueue.main.async {
                print("DONE!")
            }
            completion(.doNotDismiss)
        }
    }
}
