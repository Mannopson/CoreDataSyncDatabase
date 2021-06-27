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
                    case .success(_): Notification.shared.setNotification()
                    case .failure(let error): ErrorMessage.shared.presentAlertMessage(withError: error.localizedDescription, owner: self)
                    }
                }
            }
        }))
        present(alertController, animated: true, completion: nil)
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
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell.init()
    }
}

extension ViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
