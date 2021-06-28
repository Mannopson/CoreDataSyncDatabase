//
//  ViewController.swift
//  CoreDataSyncDatabase
//
//  Created by AzizOfficial on 6/19/21.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    lazy var fetchedResultsController: NSFetchedResultsController<Model> = {
        let fetchedResquest: NSFetchRequest<Model> = Model.fetchRequest()
        fetchedResquest.sortDescriptors = [NSSortDescriptor.init(key: "added", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController.init(fetchRequest: fetchedResquest, managedObjectContext: DataModel.shared.context(), sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError()
        }
        return fetchedResultsController
    }()
    
    @objc func addAction(sender: UIBarButtonItem) {
        let alertController = UIAlertController.init(title: "Add Title", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Title body goes here:"
        }
        alertController.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction.init(title: "Save", style: .default, handler: { action in
            if let text = alertController.textFields?.first?.text {
                DataModel.shared.saveObject(title: text) { result in
                    switch result {
                    case .success(_): Notification.shared.setNotification(title: text)
                    case .failure(let error): ErrorMessage.shared.presentAlertMessage(withError: error.localizedDescription, owner: self)
                    }
                }
            }
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    private func formatter(withDate: Date) -> String {
        let formatter = DateFormatter.init()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: withDate)
    }
    
    private func configureCells(cell: UITableViewCell, indexPath: IndexPath) {
        cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        cell.detailTextLabel?.font = UIFont.preferredFont(forTextStyle: .footnote)
        
        let managedObject = fetchedResultsController.object(at: indexPath)
        if let title = managedObject.value(forKey: "title") as? String {
            cell.textLabel?.text = title
        }
        if let added = managedObject.value(forKey: "added") as? Date {
            cell.detailTextLabel?.text = formatter(withDate: added)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addAction(sender:)))
        tableView.dataSource = self
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections?[section] {
            return sections.numberOfObjects
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        configureCells(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            let managedObject = fetchedResultsController.object(at: indexPath)
            DataModel.shared.deleteObject(managedObject: managedObject) { result in
                switch result {
                case .failure(let error):
                    ErrorMessage.shared.presentAlertMessage(withError: error.localizedDescription, owner: self)
                case .success(_):
                    break
                }
            }
        default:
            break
        }
    }
}

extension ViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) {
                configureCells(cell: cell, indexPath: indexPath)
            }
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
