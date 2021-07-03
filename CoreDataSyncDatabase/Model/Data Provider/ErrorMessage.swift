//
//  ErrorMessage.swift
//  CoreDataSyncDatabase
//
//  Created by AzizOfficial on 6/19/21.
//

import Foundation
import UIKit

class ErrorMessage {
    
    static let shared = ErrorMessage.init()
    
    public func presentAlertMessage(withError: String, owner: UIViewController) {
        let alertController = UIAlertController.init(title: "Error", message: withError, preferredStyle: .alert)
        alertController.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: nil))
        owner.present(alertController, animated: true, completion: nil)
    }
}
