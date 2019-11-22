//
//  ClassInfoViewController.swift
//  AnywhereFitness
//
//  Created by Niranjan Kumar on 11/18/19.
//  Copyright © 2019 NarJesse. All rights reserved.
//

import UIKit

class ClassInfoViewController: UIViewController {
    
    // MARK: - Variables
    
    var classController: ClassController?
    var clientController: ClientController?
    var aClass: Class? {
        didSet {
            updateViews()
        }
    }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        formatter.timeZone = TimeZone.autoupdatingCurrent
        return formatter
    }
    
    @IBOutlet weak var className: UILabel!
    @IBOutlet weak var classType: UILabel!
    @IBOutlet weak var intensity: UILabel!
    @IBOutlet weak var instructorName: UILabel!
    @IBOutlet weak var date: UILabel! // date formatter
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        
    }
    
//    @IBAction func classAdded (_ sender: Any) {
//        guard let aClass = aClass else { return }
//
//        clientController?.clientAddClass(classes: aClass, context: CoreDataStack.shared.mainContext)
//
//        let alertController = UIAlertController(title: "💪!", message: "You've added this class!", preferredStyle: .alert)
//        let action = UIAlertAction(title: "Let's Go!", style: .default, handler: nil)
//        alertController.addAction(action)
//        self.present(alertController, animated: true)
//    }
    
    
    private func updateViews() {
        guard isViewLoaded else { return }
        className.text = "Class Name: \(aClass!.name!)"
        classType.text = "Type of Class: \(String(describing: aClass!.type!))!"
        intensity.text = "Intensity: \(String(describing: aClass!.intensityLevel!))"
        instructorName.text = "Instructor Name: \(String(describing: aClass!.instructorName!))"
        date.text = "Class Start Time: \(dateFormatter.string(from: (aClass?.date!)!))"
        location.text = "Location: \(String(describing: aClass!.location!))"
        duration.text = "Duration: \(String(describing: aClass!.duration!))"
        descriptionTextView.text = "\(aClass!.classDetail!)"
    }
    
    
//    // MARK: - Navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "AddSegue" {
//            if let classInfoVC = segue.destination as? ProfileTableViewController {
//                classInfoVC.clientController = clientController
//            }
//        }
//    }
}
 
 
