//
//  InstructorTableViewController.swift
//  AnywhereFitness
//
//  Created by Niranjan Kumar on 11/19/19.
//  Copyright © 2019 NarJesse. All rights reserved.
//

import UIKit
import CoreData

class InstructorTableViewController: UITableViewController {

    let classController = ClassController()
    
    lazy var fetchedResultsController: NSFetchedResultsController<Class> = {
        
        let fetchRequest: NSFetchRequest<Class> = Class.fetchRequest()
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "type", ascending: true),
            NSSortDescriptor(key: "date", ascending: true)
        ]
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.mainContext, sectionNameKeyPath: "type", cacheName: nil)
        
        frc.delegate = self
        
        do {
            try frc.performFetch()
        } catch {
            fatalError("Error performing fetch for frc: \(error)")
        }
        
        return frc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "instructorHasLoggedIn") {
            return
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let clientLoginVC = storyboard.instantiateViewController(identifier: "InstructorLoginViewController") as? InstructorLoginViewController {
            present(clientLoginVC, animated: true, completion: nil)
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "InstructorCell", for: indexPath) as? InstructorTableViewCell else { return UITableViewCell() }
        cell.classController = classController
        cell.aClass = fetchedResultsController.object(at: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionInfo = fetchedResultsController.sections?[section] else { return nil }
        return sectionInfo.name.capitalized
    }
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let aClass = fetchedResultsController.object(at: indexPath)
            classController.deleteClass(classes: aClass, context: CoreDataStack.shared.mainContext)
        }
    }
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreateClassSegue" {
            if let createClassVC = segue.destination as? CreateClassViewController {
                createClassVC.classController = classController
            }
        } else if segue.identifier == "EditClassSegue" {
            if let editClassVC = segue.destination as? CreateClassViewController, let indexPath = tableView.indexPathForSelectedRow {
                editClassVC.aClass = fetchedResultsController.object(at: indexPath)
                editClassVC.classController = classController
                
            }
            
        }
    }


}



extension InstructorTableViewController: NSFetchedResultsControllerDelegate {
func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.beginUpdates()
}
func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.endUpdates()
}
func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                didChange anObject: Any,
                at indexPath: IndexPath?,
                for type: NSFetchedResultsChangeType,
                newIndexPath: IndexPath?) {
    switch type {
    case .insert:
        guard let newIndexPath = newIndexPath else { return }
        tableView.insertRows(at: [newIndexPath], with: .fade)
    case .delete:
        guard let indexPath = indexPath else { return }
        tableView.deleteRows(at: [indexPath], with: .fade)
    case .move:
        guard let indexPath = indexPath,
            let newIndexPath = newIndexPath else { return }
        tableView.moveRow(at: indexPath, to: newIndexPath)
    case .update:
        guard let indexPath = indexPath else { return }
        tableView.reloadRows(at: [indexPath], with: .fade)
    @unknown default:
        fatalError()
    }
}
func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                didChange sectionInfo: NSFetchedResultsSectionInfo,
                atSectionIndex sectionIndex: Int,
                for type: NSFetchedResultsChangeType) {
    let indexSet = IndexSet(integer: sectionIndex)
    switch type {
    case .insert:
        tableView.insertSections(indexSet, with: .fade)
    case .delete:
        tableView.deleteSections(indexSet, with: .fade)
    default:
        return
    }
}
}
