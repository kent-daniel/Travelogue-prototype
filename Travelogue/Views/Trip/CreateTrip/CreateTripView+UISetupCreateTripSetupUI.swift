//
//  CreateTripSetupUI.swift
//  Travelogue
//
//  Created by kent daniel on 10/5/2023.
//

import UIKit


// UI Setup
extension CreateTripViewController{
    // UI set up
    
    func tableViewSetup() {
        membersTable.layer.cornerRadius = 8
        membersTable.layer.masksToBounds = true
        membersTable.isEditing = true
        membersTable.dataSource = self
        membersTable.delegate = self
        membersTable.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        membersTable.register(MemberTableViewCell.self, forCellReuseIdentifier: "membersCell")
        membersTable.heightAnchor.constraint(equalToConstant: 0).isActive = true // Set initial height to 0
    }
    
    // set up datePicker
    func setupDatePicker(){
        
        // Set up the date pickers
        fromDateDatePicker.datePickerMode = .date
        fromDateDatePicker.addTarget(self, action: #selector(fromDateChanged(_:)), for: .valueChanged)
        
        toDateDatePicker.datePickerMode = .date
        toDateDatePicker.addTarget(self, action: #selector(toDateChanged(_:)), for: .valueChanged)
        // Set the input view of the text fields to custom input views containing the date pickers
        fromDateTextField.inputView = createInputView(with: fromDateDatePicker)
        toDateTextField.inputView = createInputView(with: toDateDatePicker)
    }
    private func createInputView(with datePicker: UIDatePicker) -> UIView {
        // Create a custom input view with a height of 250 points
        let inputView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 100))
        
        // Add the date picker to the input view
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        inputView.addSubview(datePicker)
        datePicker.centerXAnchor.constraint(equalTo: inputView.centerXAnchor).isActive = true
        datePicker.centerYAnchor.constraint(equalTo: inputView.centerYAnchor).isActive = true
        
        // Add a tap gesture recognizer to dismiss the input view
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissInputView))
        view.addGestureRecognizer(tapGestureRecognizer)
        
        return inputView
    }
    @objc private func dismissInputView() {
        view.endEditing(true)
    }
    @objc func fromDateChanged(_ sender: UIDatePicker) {
        // Format the selected date and set it as the text of the active text field
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd"
        let dateString = formatter.string(from: sender.date)
        
        if fromDateTextField.isFirstResponder {
            fromDateTextField.text = dateString
            fromDate = sender.date
        }
    }
    
    @objc func toDateChanged(_ sender: UIDatePicker) {
        // Format the selected date
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd"
        let dateString = formatter.string(from: sender.date)
        
        // Compare the selected date with the from date
        if sender.date < fromDate {
            // Leave the text field empty if the selected date is less than the from date
            toDateTextField.text = nil
        } else {
            // Set the text of the text field to the selected date if it's greater than or equal to the from date
            toDateTextField.text = dateString
        }
    }
}
