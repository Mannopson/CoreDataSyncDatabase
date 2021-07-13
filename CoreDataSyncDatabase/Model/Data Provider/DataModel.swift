//
//  DataModel.swift
//  CoreDataSyncDatabase
//
//  Created by AzizOfficial on 6/19/21.
//

import Foundation
import CoreData
import UIKit

class DataModel {
    
    static let shared = DataModel.init()
    
    public func context() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.coreDataStack.persistentContainer.viewContext
    }
    
    public func saveObject(title: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let managedObject = Model(context: context())
        managedObject.setValue(title, forKey: "title")
        managedObject.setValue(Date.init(), forKey: "added")
        
        do {
            try context().save()
            completion(.success(true))
        } catch {
            completion(.failure(error))
        }
    }
    
    public func deleteObject(managedObject: NSManagedObject, completion: @escaping (Result<Bool, Error>) -> Void) {
        context().delete(managedObject)
        
        do {
            try context().save()
            completion(.success(true))
        } catch {
            completion(.failure(error))
        }
    }
}
