//
//  AllClassesTableViewCell.swift
//  AnywhereFitness
//
//  Created by Niranjan Kumar on 11/19/19.
//  Copyright © 2019 NarJesse. All rights reserved.
//

import UIKit

class AllClassesTableViewCell: UITableViewCell {
    
    // MARK: - Variables
    @IBOutlet weak var className: UILabel!
    @IBOutlet weak var instructorName: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var level: UILabel!
    @IBOutlet weak var attendingButton: UIButton!

    var alertDelegate: UITableViewController?

    var classController: ClassController?
    var aClass: Class? {
        didSet {
            updateViews()
        }
    }
    
    
    
    // MARK: - Methods & Functions
    
    @IBAction func attendingTapped(_ sender: UIButton) {
        
        if let aClass = aClass {
            classController?.updateClassAttending(classes: aClass, context: CoreDataStack.shared.mainContext)
            aClass.isAttending.toggle()


            if !aClass.isAttending {
                attendingButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
//                attendingButton.setTitle("Going", for: .normal)
            } else {
                attendingButton.setImage(UIImage(systemName: "circle"), for: .normal)
//                attendingButton.setTitle("Not Going", for: .normal)

            }
        }
        updateViews()
    }

    
    
    private func updateViews() {
        var dateFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, h:mm a"
            formatter.timeZone = TimeZone.autoupdatingCurrent
            return formatter
        }
        
        guard let aClass = aClass else { return }
        className.text = aClass.name
        instructorName.text = "Instructor: \(aClass.instructorName!)"
        guard let time = time else { return }
        time.text = dateFormatter.string(from: (aClass.date)!)
        level.text = aClass.intensityLevel
        
        
        if !aClass.isAttending {
            attendingButton.setImage(UIImage(systemName: "circle"), for: .normal)
//            attendingButton.setTitle("Not Going", for: .normal)
        } else {
            attendingButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            addedAlert()
//            attendingButton.setTitle("Going", for: .normal)

        }
    }

    func addedAlert() {
        let alertController = UIAlertController(title: "💪", message: "You've added this class! We'll remind you an hour before class starts!", preferredStyle: .alert)
        let action = UIAlertAction(title: "Let's Go!", style: .default, handler: nil)
        alertController.addAction(action)
        guard let delegate = alertDelegate else { return }
        delegate.present(alertController, animated: true, completion: nil)
    }

}
