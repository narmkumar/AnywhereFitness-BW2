//
//  CreateClassViewController.swift
//  AnywhereFitness
//
//  Created by Niranjan Kumar on 11/18/19.
//  Copyright © 2019 NarJesse. All rights reserved.
//

import UIKit
import CoreData

class CreateClassViewController: UIViewController {
    
    // MARK: - Variables
    var classController: ClassController?
    
    let context = CoreDataStack.shared.mainContext
    var aClass: Class? {
        didSet {
            updateViews()
        }
    }
    
    
    var typePicker = UIPickerView()
    var intensityPicker = UIPickerView()
    var durationPicker = UIPickerView()
    var typeData = ["Choose a workout", "Yoga" , "Cycling" , "Cardio" , "Strength Training" , "HIIT" ]
    var intensityData = ["Choose an intensity", "Easy" , "Medium" , "Difficult"]
    var durationData = ["Choose a duration", "30 minutes" , "60 minutes" , "90 minutes" ]
    
    // MARK: - Outlets
    @IBOutlet weak var classNameTextField: UITextField!
    @IBOutlet weak var yourNameTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var intensityTextField: UITextField!
    @IBOutlet weak var durationTextField: UITextField!
    @IBOutlet weak var classSizeTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var date: UIDatePicker!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        typePicker.delegate = self
        intensityPicker.delegate = self
        typePicker.dataSource = self
        intensityPicker.dataSource = self
        durationPicker.delegate = self
        durationPicker.dataSource = self
        typePicker.tag = 1
        intensityPicker.tag = 2
        durationPicker.tag = 3
        typeTextField.inputView = typePicker
        intensityTextField.inputView = intensityPicker
        durationTextField.inputView = durationPicker
        date.minuteInterval = 15
        dismissPickerView()
        updateViews()
    }
    
    // MARK: - Methods & Functions
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        
        guard let className = classNameTextField.text, !className.isEmpty else { return }
        guard let instructorName = yourNameTextField.text, !instructorName.isEmpty else { return }
        guard let location = locationTextField.text, !location.isEmpty else { return }
        guard let type = typeTextField.text, !type.isEmpty else { return }
        guard let intensity = intensityTextField.text, !intensity.isEmpty else { return }
        guard let duration = durationTextField.text, !duration.isEmpty else { return }
        guard let maxClassSize = classSizeTextField.text, !maxClassSize.isEmpty else { return }
        guard let classSize = Int16(maxClassSize) else { return }
        guard let aDescription = descriptionTextView.text, !description.isEmpty else { return }
        let newDate = date.date
        
            if let aClass = aClass {
                classController?.updateClass(classes: aClass, name: className, instructorName: instructorName, type: type, duration: duration, intensityLevel: intensity, location: location, maxClassSize: classSize, classDetail: aDescription, date: newDate, context: context)
            } else {
                classController?.createClass(name: className, instructorName: instructorName, type: type, duration: duration, intensityLevel: intensity, location: location, maxClassSize: classSize, classDetail: aDescription, date: newDate, isAttending: false, context: context)
            }
        navigationController?.popViewController(animated: true)
    }
    
    func updateViews() {
        guard isViewLoaded else { return }
        guard let aClass = aClass else { return }
        
        title = aClass.name
        classNameTextField.text = aClass.name
        yourNameTextField.text = aClass.instructorName
        locationTextField.text = aClass.location
        typeTextField.text = aClass.type
        intensityTextField.text = aClass.intensityLevel
        durationTextField.text = aClass.duration
        classSizeTextField.text = "\(String(describing: aClass.maxClassSize))"
        descriptionTextView.text = aClass.classDetail
        date.date = aClass.date!
    }
        
    func dismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.dismissKeyboard))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        intensityTextField.inputAccessoryView = toolBar
        typeTextField.inputAccessoryView = toolBar
        durationTextField.inputAccessoryView = toolBar
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

 // MARK: - Extensions
extension CreateClassViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return typeData.count
        } else if pickerView.tag == 2 {
            return intensityData.count
        } else {
            return durationData.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            typeTextField.text = typeData[row]
        } else if pickerView.tag == 2 {
            intensityTextField.text = intensityData[row]
        } else {
            durationTextField.text = durationData[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return typeData[row]
        } else if pickerView.tag == 2 {
            return intensityData[row]
        } else {
            return durationData[row]
        }
    }
}


