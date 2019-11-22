//
//  InstructorTableViewCell.swift
//  AnywhereFitness
//
//  Created by Niranjan Kumar on 11/19/19.
//  Copyright © 2019 NarJesse. All rights reserved.
//

import UIKit

class InstructorTableViewCell: UITableViewCell {
    
    @IBOutlet weak var className: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var level: UILabel!

    var classController: ClassController?
    
    var aClass: Class? {
        didSet {
            updateViews()
        }
    }
    
    private func updateViews() {
        var dateFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, h:mm a"
            formatter.timeZone = TimeZone.autoupdatingCurrent
            return formatter
        }
        className.text = aClass?.name
        guard let time = time else { return }
        time.text = dateFormatter.string(from: (aClass?.date)!)
        level.text = aClass?.intensityLevel
    }
}
